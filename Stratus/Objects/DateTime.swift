//
//  DateTime.swift
//  Stratus
//
//  Created by Max Scholle on 11/22/23.
//

import Foundation

class DateTime {
    private var day: Int
    private var month: Int
    private var year: Int
    private var hour: Int
    private var minute: Int
    
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
    public func getFormattedDate() -> String {
        return String(self.month) + "/" + String(self.day)
    }
}
