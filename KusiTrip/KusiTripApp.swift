//
//  KusiTripApp.swift
//  KusiTrip
//
//  Created by miguel tomairo on 7/04/26.
//

import SwiftUI
import SwiftData

@main
struct KusiTripApp: App {
    @State private var coordinator = AppCoordinator()
    @State private var isShowingSplash = true
    @State private var isSplashLeaving = false

    private let modelContainer: ModelContainer
    private let favoritesSync: FavoritesSyncService

    init() {
        do {
            modelContainer = try ModelContainer(for: FavoriteModel.self)
        } catch {
            fatalError("Could not create the SwiftData container: \(error)")
        }
        favoritesSync = FavoritesSyncService(modelContext: modelContainer.mainContext)

        let navAppearance = UINavigationBarAppearance()
        navAppearance.configureWithOpaqueBackground()
        navAppearance.backgroundColor = UIColor(Color.kusiPrimary)
        navAppearance.titleTextAttributes = [.foregroundColor: UIColor(Color.kusiTextPrimary)]
        navAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor(Color.kusiTextPrimary)]
        UINavigationBar.appearance().standardAppearance = navAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navAppearance
        UINavigationBar.appearance().compactAppearance = navAppearance
        UINavigationBar.appearance().tintColor = UIColor(Color.kusiTextPrimary)

        let tabAppearance = UITabBarAppearance()
        tabAppearance.configureWithOpaqueBackground()
        tabAppearance.backgroundColor = UIColor(Color.kusiPrimary)
        UITabBar.appearance().standardAppearance = tabAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabAppearance
    }

    var body: some Scene {
        WindowGroup {
            ZStack {
                Group {
                    if coordinator.isAuthenticated {
                        MainTabView()
                            .environment(coordinator)
                    } else {
                        NavigationStack {
                            LoginView()
                        }
                    }
                }
                .kusiLoadingOverlay(isPresented: coordinator.isLoggingOut, message: "Cerrando sesión…")
                .onEventBus { @MainActor event in
                    coordinator.handle(event: event)
                }
                // Separate subscription: syncing favorites calls the API and must
                // never delay navigation events (login, logout, session expired).
                .onEventBus { @MainActor event in
                    await favoritesSync.handle(event)
                }

                if isShowingSplash {
                    SplashView(isLeaving: isSplashLeaving)
                        .zIndex(1)
                        .allowsHitTesting(!isSplashLeaving)
                }
            }
            .preferredColorScheme(.light)
            .task {
                // Hold the identical frame until the system launch zoom has settled.
                async let minimumSplash: Void = Task.sleep(for: .milliseconds(500))
                await restoreSession()
                try? await minimumSplash
                withAnimation(.easeInOut(duration: 0.3)) {
                    isSplashLeaving = true
                } completion: {
                    isShowingSplash = false
                }
            }
        }
        .modelContainer(modelContainer)
    }

    private func logIn(_ user: User) {
        let event = AppEvent.loginSuccess(userUI: UserMapper.toUI(entity: user))
        coordinator.handle(event: event)
        Task { await favoritesSync.handle(event) }
    }

    /// Logs the user back in from the Keychain.
    /// - With a cached profile the tabs show right away and `GET /auth/me`
    ///   validates the session in the background (if it was revoked, the app
    ///   returns to login through `.sessionExpired`).
    /// - Without one (sessions saved by older versions), the splash waits at
    ///   most a few seconds: a cold start on Render can take up to a minute, and
    ///   in that case the restore finishes in the background.
    private func restoreSession() async {
        let useCase = RestoreSessionUseCase()
        if let cached = useCase.cachedUser() {
            logIn(cached)
            Task {
                if let user = await useCase.execute() {
                    coordinator.currentUser = UserMapper.toUI(entity: user)
                }
            }
            return
        }

        let restore = Task { @MainActor in
            if let user = await useCase.execute() {
                logIn(user)
            }
        }
        await withTaskGroup(of: Void.self) { group in
            group.addTask { await restore.value }
            group.addTask { try? await Task.sleep(for: .seconds(4)) }
            await group.next()
            group.cancelAll()
        }
    }
}
