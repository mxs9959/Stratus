//
//  DateTime.swift
//  Stratus
//
//  Created by Max Scholle on 11/22/23.
//

import Foundation
import SwiftUI
import UIKit

class DateTime: ObservableObject, Codable {
    @Published private var day: Int
    @Published private var month: Int
    private var year: Int
    private var hour: Int
    private var minute: Int
    
    enum CodingKeys: CodingKey {
        case day
        case month
        case year
        case hour
        case minute
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        day = try container.decode(Int.self, forKey: .day)
        month = try container.decode(Int.self, forKey: .month)
        year = try container.decode(Int.self, forKey: .year)
        hour = try container.decode(Int.self, forKey: .hour)
        minute = try container.decode(Int.self, forKey: .minute)
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(day, forKey: .day)
        try container.encode(month, forKey: .month)
        try container.encode(year, forKey: .year)
        try container.encode(hour, forKey: .hour)
        try container.encode(minute, forKey: .minute)
    }
    
    public static func getNow(rounded: Bool) -> DateTime {
        let components = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute], from: Date())
        let minute: Int
        if(rounded){
            minute = 0
        } else {
            minute = components.minute ?? 0
        }
        return DateTime(
            day:components.day ?? 1,
            month:components.month ?? 1,
            year:components.year ?? 2024,
            hour:components.hour ?? 0,
            minute:minute
        )
    }
    
    public static func convertDateToDT(date: Date) -> DateTime {
        let components = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute], from: date)
        return DateTime(
            day:components.day ?? 1,
            month:components.month ?? 1,
            year:components.year ?? 2024,
            hour:components.hour ?? 0,
            minute:components.minute ?? 0
        )
    }
    
    init(day: Int, month: Int, year: Int, hour: Int, minute: Int) {
        self.day = day
        self.month = month
        self.year = year
        self.hour = hour
        self.minute = minute
    }
    
    public func setDateTime(day: Int, month: Int, year: Int, hour: Int, minute: Int){
        self.day = day
        self.month = month
        self.year = year
        self.hour = hour
        self.minute = minute
    }
    
    public func compareToDate(date: Date) -> Int { //Returns difference in minutes
        return Calendar.current.dateComponents([.minute], from: date, to: self.convertToDate()).minute ?? 0
    }
    
    public func getDay() -> Int {
        return self.day
    }
    public func getMonth() -> Int {
        return self.month
    }
    public func getHour() -> Int {
        return self.hour
    }
    public func addMinutes(minutes: Int) -> DateTime{
        let result = Calendar(identifier:.gregorian).date(from: DateComponents(year:self.year, month:self.month, day:self.day, hour:self.hour, minute:self.minute))!.addingTimeInterval(60*Double(minutes))
        let components = Calendar.current.dateComponents([.day,.month,.year,.hour,.minute], from: result)
        return DateTime(
            day:components.day ?? 1,
            month:components.month ?? 1,
            year:components.year ?? 2024,
            hour:components.hour ?? 0,
            minute:components.minute ?? 0
        )
    }
    public func getMinute() -> Int {
        return self.minute
    }
    
    public func convertToDate() -> Date{
        return Calendar(identifier:.gregorian).date(from: DateComponents(year:self.year, month:self.month, day:self.day, hour:self.hour, minute:self.minute))!
    }
    
    public func getFormattedTime() -> String {
        var result: String
        if(self.minute<10){
            result = "0" + String(self.minute)
        } else {
            result = String(self.minute)
        }
        if(self.hour == 0){
            result = "12:" + result + " AM"
        } else if(self.hour == 12){
            result = "12:" + result + " PM"
        } else if(self.hour > 12){
            result = String(self.hour - 12) + ":" + result + " PM"
        } else {
            result = String(self.hour) + ":" + result + " AM"
        }
        return result
    }
    public func getFormattedDate(weekday: Bool) -> String {
        return (weekday ? self.getWeekday() + ", ":"") + String(self.month) + "/" + String(self.day)
    }
    
    public func addDaysToThis(days: Int) {
        let result = Calendar(identifier:.gregorian).date(from: DateComponents(year:self.year, month:self.month, day:self.day, hour:self.hour, minute:self.minute))!.addingTimeInterval(86400*Double(days))
        let components = Calendar.current.dateComponents([.day,.month,.year,.hour,.minute], from: result)
        self.day = components.day ?? self.day
        self.month = components.month ?? self.month
        self.year = components.year ?? self.year
        self.hour = components.hour ?? self.hour
        self.minute = components.minute ?? self.minute
        objectWillChange.send()
    }
    
    public func getWeekday() -> String{
        switch(Calendar.current.dateComponents([.weekday], from:self.convertToDate()).weekday){
        case 1: return "Sunday"
        case 2: return "Monday"
        case 3: return "Tuesday"
        case 4: return "Wednesday"
        case 5: return "Thursday"
        case 6: return "Friday"
        case 7: return "Saturday"
        default: return ""
        }
    }
    
    public func midnight() -> DateTime {
        return DateTime(day: self.day, month: self.month, year: self.year, hour: 0, minute: 0)
    }
    
    public func equals(dateTime: DateTime, onlyDate: Bool) -> Bool {
        if(!onlyDate){
            return self.convertToDate() == dateTime.convertToDate()
        } else {
            return self.midnight().convertToDate() == dateTime.midnight().convertToDate()
        }
    }
}

class CodableColor: Codable {
    
    private var components: [CGFloat]
    
    init(color: Color) {
        var components: [CGFloat] = []
        if let c = UIColor(color).cgColor.components {
            components.append(c[0])
            components.append(c[1])
            components.append(c[2])
            components.append(c[3])
            self.components = components
        } else {
            self.components = [0,0,0,0]
        }
    }
    
    public func convertToColor() -> Color {
        return Color(red:components[0], green:components[1], blue:components[2])
    }
    
}
