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

    init() {
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
                .onEventBus { @MainActor event in
                    coordinator.handle(event: event)
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
                try? await Task.sleep(for: .seconds(1))
                withAnimation(.easeInOut(duration: 0.45)) {
                    isSplashLeaving = true
                } completion: {
                    isShowingSplash = false
                }
            }
        }
        .modelContainer(for: FavoriteModel.self)
    }
}
