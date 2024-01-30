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
                Section("Sleep") {
                    if(config.sleepEnabled){
                        DatePicker("Sleep start: ", selection: $config.sleepBegin, displayedComponents: [.hourAndMinute])
                        DatePicker("Sleep end: ", selection: $config.sleepEnd, displayedComponents: [.hourAndMinute])
                    }
                    Toggle(isOn:$config.sleepEnabled){
                        Text("Enable sleep: ")
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
    Scheduling().environmentObject(Config()).environmentObject(Strata())
}
