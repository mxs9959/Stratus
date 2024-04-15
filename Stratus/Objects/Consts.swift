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
    
    static var recurrenceLimit: Int = 7 //Days to generate
    
}

class Config: ObservableObject, Codable {
    
    @Published public var sleepBegin: Date
    @Published public var sleepEnd: Date
    @Published public var sleepEnabled: Bool
    
    @Published public var freeTimeEnabled: Bool
    @Published public var freeTimeTarget: Double
    @Published public var goalsEnabled: [Bool]
    
    enum CodingKeys: CodingKey {
        case sleepBegin
        case sleepEnd
        case sleepEnabled
        case freeTimeEnabled
        case freeTimeTarget
        case goalsEnabled
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        sleepBegin = try container.decode(Date.self, forKey: .sleepBegin)
        sleepEnd = try container.decode(Date.self, forKey: .sleepEnd)
        sleepEnabled = try container.decode(Bool.self, forKey: .sleepEnabled)
        freeTimeEnabled = try container.decode(Bool.self, forKey: .freeTimeEnabled)
        freeTimeTarget = try container.decode(Double.self, forKey: .freeTimeTarget)
        goalsEnabled = try container.decode([Bool].self, forKey: .goalsEnabled)
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(sleepBegin, forKey: .sleepBegin)
        try container.encode(sleepEnd, forKey: .sleepEnd)
        try container.encode(sleepEnabled, forKey: .sleepEnabled)
        try container.encode(freeTimeEnabled, forKey: .freeTimeEnabled)
        try container.encode(freeTimeTarget, forKey: .freeTimeTarget)
        try container.encode(goalsEnabled, forKey: .goalsEnabled)
    }
    
    init() {
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
    
    public func toJSONString() -> String {
        var result = ""
        do {
            let jsonData = try JSONEncoder().encode(self)
            if let jsonString = String(data: jsonData, encoding: .utf8){
                result = jsonString
            }
        } catch {
            print("An error has occurred while encoding config object.")
        }
        return result
    }
    
    public func fromJSONString(json: String) {
        do {
            if let jsonData = json.data(using: .utf8){
                let config = try JSONDecoder().decode(Config.self, from: jsonData)
                self.sleepBegin = config.sleepBegin
                self.sleepEnd = config.sleepEnd
                self.sleepEnabled = config.sleepEnabled
                self.freeTimeTarget = config.freeTimeTarget
                self.freeTimeEnabled = config.freeTimeEnabled
                self.goalsEnabled = config.goalsEnabled
            }
        } catch {
            print("An error has occurred while decoding config object.")
        }
    }
    
}

