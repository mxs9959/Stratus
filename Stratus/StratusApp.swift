//
//  StratusApp.swift
//  Stratus
//
//  Created by Max Scholle on 11/22/23.
//

import SwiftUI

@main
struct StratusApp: App {
    
    @StateObject var config = Config()
    
    @State private var selection = 0
    
    @State var path = NavigationPath()
    
    var body: some Scene {
        WindowGroup {
            TabView(selection:$selection) {
                Group {
                    TemplatesView()
                        .tabItem {
                            Label("Templates", systemImage:"doc")
                        }
                        .tag(1)
                    Home()
                        .tabItem {
                            Label("Home", systemImage:"house")
                        }
                        .tag(0)
                    Settings()
                        .tabItem {
                            Label("Settings", systemImage:"gear")
                        }
                        .tag(2)
                }
                .toolbarBackground(.visible, for: .tabBar)
                .toolbarBackground(.ultraThinMaterial, for: .tabBar)
            }
            .environmentObject(config)
        }
    }
}

