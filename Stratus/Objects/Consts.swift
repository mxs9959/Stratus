//
//  Consts.swift
//  Stratus
//
//  Created by Max Scholle on 11/23/23.
//

import SwiftUI

struct Consts {
    
    static var headerHeight: CGFloat = 65
    
    static var scrollWidthStrata: CGFloat = UIScreen.main.bounds.width - 2*25
    static var scrollPadding: CGFloat = 10
    static var scrollVerticalPadding: CGFloat = 20
    static var borderWidth: CGFloat = 1
    static var cornerRadius: CGFloat = 25
    static var widthToMinutes: CGFloat = 1.25
    
    static var scrollWidthEditing: CGFloat = UIScreen.main.bounds.width - 2*25
    static var cornerRadiusField: CGFloat = 10
    
    static var scrollWidthTemplates: CGFloat = UIScreen.main.bounds.width - 2*20
    
    static var defaultTaskColor: Color = Color(red:198/255, green:132/255, blue:88/255)
    static func randomColor() -> Color {
        return Color(red:Double.random(in:100..<255)/255,green:Double.random(in:100..<255)/255,blue:Double.random(in:100..<255)/255)
    }
    
}

class Config: ObservableObject {
    
    @Published public var backgroundColor: Color
    @Published public var accentColor: Color
    
    init(){
        self.backgroundColor = Color(red: 255/255, green:255/255, blue:255/255)
        self.accentColor = Color(red:0/255, green:48/255, blue:82/255)
    }
    
}
