//
//  civitatisApp.swift
//  civitatis
//
//  Created by miguel tomairo on 7/04/26.
//

import SwiftUI
import SwiftData

@main
struct civitatisApp: App {
    @State private var coordinator = AppCoordinator()

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
            .preferredColorScheme(.light)
        }
        .modelContainer(for: FavoriteModel.self)
    }
}
