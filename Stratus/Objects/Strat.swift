//
//  Strat.swift
//  Stratus
//
//  Created by Max Scholle on 11/22/23.
//

import Foundation
import SwiftUI

class Strat: ObservableObject {
    
    @Published private var begin: DateTime //Strats cover a certain duration of the user's schedule
    @Published private var end: DateTime
    @Published private var tasks: [Task]
    
    public var sleep: Bool
    
    init() {
        self.begin = DateTime.getNow(rounded: true)
        self.end = DateTime.getNow(rounded: true).addMinutes(minutes: 60)
        self.tasks = []
        self.sleep = false
    }
    
    public func organize(){
        var output: [Task] = [self.tasks[0]]
        for i in 1..<self.tasks.count {
            var j = 0
            while self.tasks[i].getBegin().compareToDate(date: output[j].getBegin().convertToDate())>0{
                j += 1
                if(j==output.count){
                    break
                }
            }
            if(j==output.count){
                output.append(self.tasks[i])
            } else {
                output.insert(self.tasks[i], at:j)
            }
        }
        self.tasks = output
    }
    
    public func updateRange(){
        if(!self.sleep){
            self.organize()
            self.begin = self.tasks[0].getBegin()
            self.end = self.tasks[self.tasks.count-1].getBegin().addMinutes(minutes: self.tasks[self.tasks.count-1].getDuration())
        }
    }
    
    public func getDisplayRange() -> String {
        if(self.begin.equals(dateTime: self.end, onlyDate:true)){
            return self.begin.getFormattedDate(weekday:false) + " " + self.begin.getFormattedTime() + " to " + self.end.getFormattedDate(weekday:false) + " " + self.end.getFormattedTime()
        } else {
            return self.begin.getFormattedDate(weekday:false) + ", " + self.begin.getFormattedTime() + " to " + self.end.getFormattedTime()
        }
    }
    
    public func getNewTask() -> Task{
        self.tasks.append(Task(begin:DateTime.getNow(rounded:true)))
        return self.tasks[self.tasks.count-1]
    }
    public func addTasks(tasks: [Task]){
        for task in tasks {
            self.tasks.append(task)
        }
    }
    public func replaceTask(task: Task, id: Int){
        self.tasks[id] = task
    }
    public func getTasks() -> [Task]{
        return self.tasks
    }
    public func removeTask(id: Int){
        self.tasks.remove(at:id)
    }
    public func getBegin() -> DateTime {
        self.updateRange()
        return self.begin
    }
    public func getEnd() -> DateTime {
        self.updateRange()
        return self.end
    }
    
}
