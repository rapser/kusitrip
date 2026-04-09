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
        }
        .modelContainer(for: FavoriteModel.self)
    }
}
