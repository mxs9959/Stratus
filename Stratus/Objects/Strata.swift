//
//  Strata.swift
//  Stratus
//
//  Created by Max Scholle on 11/22/23.
//

import Foundation
import SwiftUI

class Strata: ObservableObject {
    
    @Published private var strata: [Strat] {
        willSet{
            objectWillChange.send()
        }
    }
    @Published private var sleepTime: Int //Sleep time in minutes
    @Published private var stratLoadingScope: (DateTime, DateTime)
    
    init(){
        self.strata = []
        self.sleepTime = 480
        self.stratLoadingScope = (DateTime.getNow(rounded: true).addMinutes(minutes: -1440).midnight(), DateTime.getNow(rounded: true).addMinutes(minutes: 8640).midnight()) //Default range for populating strata is one day behind through five days ahead
     
    }
    
    public func addSampleStrat(){
        strata.append(Strat())
    }
    
    public func getStrata() -> [Strat]{
        return strata
    }
    
    public func addTasksToStrat(id: Int, tasks: [Task]){
        strata[id].addTasks(tasks: tasks)
    }
    
    public func replaceTaskInStrat(stratId: Int, taskId: Int, task: Task){
        strata[stratId].replaceTask(task:task, id:taskId)
    }
    
    public func findStrat(begin: Date) -> Int{
        for i in 0..<self.strata.count {
            if(!self.strata[i].freeTime && (self.strata[i].getBegin().compareToDate(date: begin)<=0 && self.strata[i].getEnd().compareToDate(date: begin)>=0)){
                return i
            }
        }
        self.addSampleStrat()
        return self.strata.count - 1
    }
    
    public func organize(){
        var output: [Strat] = [self.strata[0]]
        for i in 1..<self.strata.count {
            var j = 0
            while self.strata[i].getBegin().compareToDate(date: output[j].getBegin().convertToDate())>0{
                j += 1
                if(j==output.count){
                    break
                }
            }
            if(j==output.count){
                output.append(self.strata[i])
            } else {
                output.insert(self.strata[i], at:j)
            }
        }
        for i in 1..<output.count {
            if(output[i-1].getEnd().compareToDate(date: output[i].getBegin().convertToDate())>=0){
                output[i-1].addTasks(tasks: output[i].getTasks())
                output.remove(at:i)
            }
        }
        self.strata = output
    }
    public func removeStrat(id: Int){
        self.strata.remove(at:id)
    }
    
    public func getSleepHours() -> Int{
        return self.sleepTime/60
    }
    
    public func getSleepMinutes() -> Int{
        return self.sleepTime%60
    }
    
    public func setSleepTime(minutes: Int, hours: Int){
        self.sleepTime = hours*60 + minutes
    }
    
    public func stratsOnDay(day: DateTime) -> Bool{
        for strat in self.strata {
            if strat.getBegin().equals(dateTime: day, onlyDate: true){
                return true
            }
        }
        return false
    }
    
    
}

class Templates: ObservableObject {
    
    @Published private var templates: [Template]
    
    init(){
        self.templates = []
    }
    
    public func manualUpdate(){
        objectWillChange.send()
    }
    
    public func getTemplates() -> [Template]{
        return templates
    }
    
    public func addTemplate(template: Template){
        templates.append(template)
    }
    public func addSampleTemplate(){
        templates.append(Template())
    }
    
    public func replaceTemplate(id: Int, template: Template){
        templates[id] = template
    }
    
    public func removeTemplate(id:Int){
        templates.remove(at:id)
    }
    
}
