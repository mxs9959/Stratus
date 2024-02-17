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
    
    static var scrollWidthEditing: CGFloat = UIScreen.main.bounds.width - 2*10
    static var cornerRadiusField: CGFloat = 10
    
    static var scrollWidthTemplates: CGFloat = UIScreen.main.bounds.width - 2*20
    
    static var defaultTaskColor: Color = Color(red:198/255, green:132/255, blue:88/255)
    static var LB: Double = 100
    static func randomColor() -> Color {
        return Color(red:Double.random(in:LB..<255)/255,green:Double.random(in:LB..<255)/255,blue:Double.random(in:LB..<255)/255)
    }
    
    static var funEmojis = ["😀", "😆", "😃", "😌", "😇", "😂", "😜", "🤨", "🧐", "😎", "😋", "🥳", "🤥", "🤯", "🫨", "🤑", "🤠", "👌", "💪", "👍", "👏"]
    static func randomEmoji() -> String {
        return funEmojis[Int.random(in:0..<funEmojis.count)]
    }
    
}

class Config: ObservableObject {
    
    @Published public var sleepBegin: Date
    @Published public var sleepEnd: Date
    @Published public var sleepEnabled: Bool
    
    @Published public var freeTimeEnabled: Bool
    @Published public var freeTimeTarget: Double
    
    @Published public var goalsEnabled: [Bool]
    
    init(){
        self.sleepBegin = DateTime(day: 1, month: 1, year: 2024, hour: 22, minute: 0).convertToDate()
        self.sleepEnd = DateTime(day: 2, month: 1, year: 2024, hour: 6, minute: 0).convertToDate()
        self.sleepEnabled = true
        self.freeTimeTarget = 4
        self.freeTimeEnabled = true
        self.goalsEnabled = [true]
    }
    public func getSleepDisplayRange() -> String {
        return DateTime.convertDateToDT(date: self.sleepBegin).getFormattedTime() + " to " + DateTime.convertDateToDT(date: self.sleepEnd).getFormattedTime()
    }
    
}
