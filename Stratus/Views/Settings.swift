//
//  Settings.swift
//  Stratus
//
//  Created by Max Scholle on 11/23/23.
//

import Foundation
import SwiftUI

struct Settings: View {
    
    @EnvironmentObject var config: Config
    
    var body: some View {
        VStack(spacing:0) {
            HStack {
                Text("Settings")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .bold()
                    .padding()
            }
            .frame(width:UIScreen.main.bounds.width, height: Consts.headerHeight)
            .background(.ultraThinMaterial)
            ScrollView{
                VStack {
                    ColorPicker("Background Color", selection:$config.backgroundColor)
                        .padding(.all, Consts.scrollPadding)
                        .frame(width:Consts.scrollWidthEditing)
                        .background(.ultraThinMaterial)
                        .cornerRadius(Consts.cornerRadius)
                        .foregroundColor(.black)
                }
                .padding(.top, Consts.scrollVerticalPadding)
            }
            Text("Stratus by Max Scholle, 2024")
                .padding(.vertical, Consts.scrollVerticalPadding)
        }
        .frame(width:UIScreen.main.bounds.width)
        .background(Color("BodyBackground"))
    }
}

#Preview {
    Settings().environmentObject(Config())
}
