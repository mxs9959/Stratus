//
//  Template.swift
//  Stratus
//
//  Created by Max Scholle on 11/22/23.
//

import Foundation
import SwiftUI

class Template: ObservableObject, Codable {
    @Published private var name: String
    @Published private var priority: Int = 5 //Range between 0 and 10
    @Published private var mandatory: Bool
    @Published private var duration: Int //Duration in minutes
    @Published private var color: Color
    @Published private var recurrence: Int
    @Published private var recurrenceStart: Date
    private var ccolor: CodableColor?
    
    init(name: String, priority: Int, mandatory: Bool, duration: Int, color: Color, recurrence: Int, recurrenceStart: Date) {
        if(priority>=0 && priority<=10){
            self.priority = priority
        }
        self.mandatory = mandatory
        self.duration = duration
        self.name = name
        self.color = color
        self.recurrence = recurrence
        self.recurrenceStart = recurrenceStart
    }
    init(){
        self.name = "Sample template"
        self.priority = 5
        self.mandatory = false
        self.duration = 60
        self.color = Consts.randomColor()
        self.recurrence = 0
        self.ccolor = nil
        self.recurrenceStart = DateTime.getNow(rounded: false).convertToDate()
    }
    
    enum CodingKeys: CodingKey {
        case name
        case priority
        case mandatory
        case duration
        case ccolor
        case recurrence
        case recurrenceStart
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        priority = try container.decode(Int.self, forKey: .priority)
        mandatory = try container.decode(Bool.self, forKey: .mandatory)
        duration = try container.decode(Int.self, forKey: .duration)
        ccolor = try container.decode(CodableColor.self, forKey: .ccolor)
        recurrence = try container.decode(Int.self, forKey: .recurrence)
        recurrenceStart = try container.decode(Date.self, forKey: .recurrenceStart)
        color = ccolor!.convertToColor()
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(priority, forKey: .priority)
        try container.encode(mandatory, forKey: .mandatory)
        try container.encode(duration, forKey: .duration)
        try container.encode(CodableColor(color:color), forKey: .ccolor)
        try container.encode(recurrence, forKey: .recurrence)
        try container.encode(recurrenceStart, forKey: .recurrenceStart)
    }
    
    public func getTemplateDetails() -> (String, Int, Bool, Int, Color, Int, Date){
        return (self.name, self.priority, self.mandatory, self.duration, self.color, self.recurrence, self.recurrenceStart)
    }
    
    public func setPriority(priority: Int){
        if(priority>=0 && priority<=10){
            self.priority = priority
        }
    }
    public func getPriority() -> Int {
        return self.priority
    }
    public func setMandatory(mandatory: Bool){
        self.mandatory = mandatory
    }
    public func getMandatory() -> Bool {
        return self.mandatory
    }
    public func setDuration(duration: Int){
        self.duration = duration
    }
    public func getDuration() -> Int {
        return self.duration
    }
    public func getName() -> String {
        return self.name
    }
    public func getColor() -> Color {
        return self.color
    }
    public func setColor(color: Color) {
        self.color = color
    }
    public func getRecurrence() -> Int{
        return self.recurrence
    }
    public func getRecurrenceStart() -> Date{
        return self.recurrenceStart
    }
}

class Task: Template {
    @Published private var title: String
    @Published private var begin: DateTime
    
    init(priority: Int, mandatory: Bool, duration: Int, begin: DateTime, color: Color, title: String){
        self.begin = begin
        self.title = title
        super.init(name: "custom", priority: priority, mandatory: mandatory, duration: duration, color:color, recurrence:0, recurrenceStart: DateTime.getNow(rounded: false).convertToDate())
    }
    init(begin: DateTime){
        self.begin = begin
        self.title = "Sample task"
        super.init()
    }
    init(details: TemplateDetails, begin: DateTime){
        self.begin = begin
        self.title = details.name
        super.init(name: details.name, priority: Int(details.priority), mandatory: details.mandatory, duration: Int(details.duration) ?? 60, color: details.color, recurrence: details.recurrence, recurrenceStart: DateTime.getNow(rounded: false).convertToDate())
    }
    
    enum CodingKeys: CodingKey {
        case title
        case begin
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        begin = try container.decode(DateTime.self, forKey: .begin)
        try super.init(from: decoder)
    }
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(begin, forKey: .begin)
        try super.encode(to:encoder)
    }
    
    public func setBegin(begin: DateTime){
        self.begin = begin
    }
    public func getBegin() -> DateTime {
        return self.begin
    }
    public func getEnd() -> DateTime {
        return self.begin.addMinutes(minutes: Int(super.getDuration()))
    }
    public func getTitle() -> String {
        return self.title
    }
    public func setTitle(title: String){
        self.title = title
    }
    public func getDetails() -> (String, Int, Bool, Int, Color, DateTime){
        return (self.title, self.getPriority(), self.getMandatory(), self.getDuration(), self.getColor(), self.begin)
    }
    
}

class TemplateDetails: ObservableObject {
    
    @Published public var name: String
    @Published public var priority: Double
    @Published public var mandatory: Bool
    @Published public var duration: String
    @Published public var color: Color
    @Published public var recurrence: Int
    @Published public var recurrenceBegin: Date
    
    init(details: (String, Int, Bool, Int, Color, Int, Date)){
        self.name = details.0
        self.priority = Double(details.1)
        self.mandatory = details.2
        self.duration = "\(details.3)"
        self.color = details.4
        self.recurrence = details.5
        self.recurrenceBegin = details.6
    }
    init(){
        self.name = "Sample template"
        self.priority = 5
        self.mandatory = false
        self.duration = "60"
        self.color = Consts.randomColor()
        self.recurrence = 0
        self.recurrenceBegin = DateTime.getNow(rounded: false).convertToDate()
    }
}

class TaskDetails: TemplateDetails {
    
    @Published public var title: String
    @Published public var begin: Date
    
    init(details: (String, Int, Bool, Int, Color, DateTime)){
        self.title = details.0
        self.begin = details.5.convertToDate()
        super.init(details:("custom", details.1, details.2, details.3, details.4, 0, details.5.convertToDate()))
    }
    
    override init(details: (String, Int, Bool, Int, Color, Int, Date)){
        self.title = details.0
        self.begin = DateTime.getNow(rounded:false).convertToDate()
        super.init(details:("custom", details.1, details.2, details.3, details.4, details.5, details.6))
    }
    
    public static func getSampleDetails() -> (String, Int, Bool, Int, Color, DateTime){
        return ("Sample task", 5, false, 60, Consts.randomColor(), DateTime.getNow(rounded: true))
    }
    
}
