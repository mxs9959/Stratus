//
//  Scheduling.swift
//  Stratus
//
//  Created by Max Scholle on 11/23/23.
//

import Foundation
import SwiftUI

struct Scheduling: View {
    
    @EnvironmentObject var strata: Strata
    @EnvironmentObject var config: Config
    @EnvironmentObject var goals: Goals
    
    var body: some View {
        VStack(spacing:0) {
            HStack {
                Text("Scheduling")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .bold()
                    .padding()
            }
            .frame(width:UIScreen.main.bounds.width, height: Consts.headerHeight)
            .background(Color("Header"))
            Form {
                Group {
                    Section("Free Time") {
                        Toggle(isOn: $config.freeTimeEnabled){
                            Text("Enable free time:")
                        }
                        if(config.freeTimeEnabled){
                            HStack {
                                Text("Daily Free Time Goal:")
                                Slider(value: $config.freeTimeTarget, in: 0...24)
                                    .padding(.horizontal, Consts.scrollPadding)
                                Text("\(Int(config.freeTimeTarget)) hrs")
                            }
                        }
                    }
                    Section("Sleep") {
                        Toggle(isOn: $config.sleepEnabled){
                            Text("Enable sleep: ")
                        }
                        if(config.sleepEnabled){
                            DatePicker("Sleep start: ", selection: $config.sleepBegin, displayedComponents: [.hourAndMinute])
                            DatePicker("Sleep end: ", selection: $config.sleepEnd, displayedComponents: [.hourAndMinute])
                        }
                        
                    }
                    Section("Enable Recurring Goals"){
                        ForEach(0..<goals.getGoals().count, id:\.self){i in
                            Toggle(isOn:$config.goalsEnabled[i]){
                                Text(goals.getGoals()[i].getName())
                            }
                            .onChange(of: config.goalsEnabled[i], {goals.updateFromConfig(config: config)})
                        }
                    }
                }
            }
            .background(Color("BodyBackground"))
            .frame(width: Consts.scrollWidthEditing)
        }
        .frame(width:UIScreen.main.bounds.width)
        .background(Color("BodyBackground"))
    }
}

#Preview {
    Scheduling().environmentObject(Config()).environmentObject(Strata()).environmentObject(Goals())
}
