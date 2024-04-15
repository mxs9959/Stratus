//
//  StratusApp.swift
//  Stratus
//
//  Created by Max Scholle on 11/22/23.
//

import SwiftUI

@main
struct StratusApp: App {
    
    @AppStorage("config") var configJSON: String = Config().toJSONString()
    @AppStorage("strata") var strataJSON: String = Strata().toJSONString()
    @AppStorage("goals") var goalsJSON: String = Goals().toJSONString()
    
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
                .onAppear(){
                    config.fromJSONString(json: configJSON)
                    strata.fromJSONString(json: strataJSON)
                    let _ = strata.removeRecurrentTasks()
                    goals.fromJSONString(json: goalsJSON)
                    strata.generateRecurrentTasks(goals: goals)
                }
                .onReceive(config.objectWillChange){
                    configJSON = config.toJSONString()
                }
                .onReceive(strata.objectWillChange){
                    strataJSON = strata.toJSONString()
                }
                .onReceive(goals.objectWillChange){
                    goalsJSON = goals.toJSONString()
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

