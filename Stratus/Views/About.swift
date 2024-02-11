//
//  About.swift
//  Stratus
//
//  Created by Max Scholle on 2/11/24.
//

import Foundation
import SwiftUI

struct About: View {
    
    var body: some View {
        
        Text("About")
            .font(.title)
            .padding()
        
        Text("Stratus by Max Scholle, 2024")
            .bold()
            .padding()
        
        Text("Westminster Innovation Fellows Project")
            .padding()
        
        Image("W")
            .imageScale(.small)
            .padding()
        
        Link(destination: URL(string: "mailto:maxscholle@westminster.net")!, label: {
            Text("Report a bug or give feedback")
        })
        .padding()
        
        Text("Thank you for agreeing to test my app!")
            .padding()
    }
    
}

#Preview {
    About()
}
