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
    @StateObject var strata = Strata()
    @StateObject var goals = Goals()
    
    @State private var selection = 0
    
    @State var path = NavigationPath()
    
    var body: some Scene {
        WindowGroup {
            TabView(selection:$selection) {
                Group {
                    TemplatesView()
                        .tabItem {
                            Label("Goals", systemImage:"target")
                        }
                        .tag(1)
                    Home()
                        .tabItem {
                            Label("Home", systemImage:"house")
                        }
                        .tag(0)
                    Scheduling()
                        .tabItem {
                            Label("Scheduling", systemImage:"calendar")
                        }
                        .tag(2)
                }
                .toolbarBackground(.visible, for: .tabBar)
                .toolbarBackground(Color("Header"), for: .tabBar)
            }
            .environmentObject(config)
            .environmentObject(strata)
            .environmentObject(goals)
        }
    }
}

