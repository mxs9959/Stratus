//
//  Template.swift
//  Stratus
//
//  Created by Max Scholle on 11/22/23.
//

import Foundation
import SwiftUI

class Template: ObservableObject, Identifiable {
    @Published private var name: String
    @Published private var priority: Int = 5 //Range between 0 and 10
    @Published private var mandatory: Bool
    @Published private var duration: Int //Duration in minutes
    @Published private var color: Color
    
    init(name: String, priority: Int, mandatory: Bool, duration: Int, color: Color) {
        if(priority>=0 && priority<=10){
            self.priority = priority
        }
        self.mandatory = mandatory
        self.duration = duration
        self.name = name
        self.color = color
    }
    init(){
        self.name = "Sample template"
        self.priority = 5
        self.mandatory = false
        self.duration = 60
        self.color = Consts.defaultTaskColor
    }
    
    
    public func getTemplateDetails() -> (String, Int, Bool, Int, Color){
        return (self.name, self.priority, self.mandatory, self.duration, self.color)
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
}

class Task: Template {
    @Published private var title: String
    @Published private var begin: DateTime
    
    init(priority: Int, mandatory: Bool, duration: Int, begin: DateTime, color: Color, title: String){
        self.begin = begin
        self.title = title
        super.init(name: "custom", priority: priority, mandatory: mandatory, duration: duration, color:color)
    }
    init(begin: DateTime){
        self.begin = begin
        self.title = "Sample task"
        super.init()
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
    
    init(details: (String, Int, Bool, Int, Color)){
        self.name = details.0
        self.priority = Double(details.1)
        self.mandatory = details.2
        self.duration = "\(details.3)"
        self.color = details.4
    }
}

class TaskDetails: TemplateDetails {
    
    @Published public var title: String
    @Published public var begin: Date
    
    init(details: (String, Int, Bool, Int, Color, DateTime)){
        self.title = details.0
        self.begin = details.5.convertToDate()
        super.init(details:("custom", details.1, details.2, details.3, details.4))
    }
    
    override init(details: (String, Int, Bool, Int, Color)){
        self.title = details.0
        self.begin = DateTime.getNow(rounded:false).convertToDate()
        super.init(details:("custom", details.1, details.2, details.3, details.4))
    }
    
    public static func getSampleDetails() -> (String, Int, Bool, Int, Color, DateTime){
        return ("Sample task", 5, false, 60, Consts.randomColor(), DateTime.getNow(rounded: true))
    }
    
}
