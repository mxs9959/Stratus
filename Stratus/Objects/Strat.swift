//
//  Strat.swift
//  Stratus
//
//  Created by Max Scholle on 11/22/23.
//

import Foundation
import SwiftUI

class Strat: ObservableObject, Codable {
    
    @Published private var begin: DateTime //Strata cover a certain duration of the user's schedule
    @Published private var end: DateTime
    @Published private var tasks: [Task]
    @Published private var freeTime: Bool
    
    init() { //Initializer for general strata
        self.begin = DateTime.getNow(rounded: true)
        self.end = DateTime.getNow(rounded: true).addMinutes(minutes: 60)
        self.tasks = []
        self.freeTime = false
    }
    init(begin: DateTime, end: DateTime){ //Initializer for freeTime strata
        self.begin = begin
        self.end = end
        self.tasks = []
        self.freeTime = true
    }
    
    enum CodingKeys: CodingKey {
        case begin
        case end
        case tasks
        case freeTime
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        begin = try container.decode(DateTime.self, forKey: .begin)
        end = try container.decode(DateTime.self, forKey: .end)
        tasks = try container.decode([Task].self, forKey: .tasks)
        freeTime = try container.decode(Bool.self, forKey: .freeTime)
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(begin, forKey: .begin)
        try container.encode(end, forKey: .end)
        try container.encode(tasks, forKey: .tasks)
        try container.encode(freeTime, forKey: .freeTime)
    }
    
    public func organize(){
        if(self.tasks.count > 0){
            var output: [Task] = [self.tasks[0]]
            for i in 1..<self.tasks.count {
                var j = 0
                while j<output.count {
                    if self.tasks[i].getBegin().compareToDate(date: output[j].getBegin().convertToDate())>0{
                        j += 1
                    } else if self.tasks[i].getBegin().compareToDate(date: output[j].getBegin().convertToDate()) == 0 {
                        if !self.tasks[i].getMandatory() && output[j].getMandatory(){
                            j += 1
                        } else if !self.tasks[i].getMandatory() && self.tasks[i].getPriority() < output[j].getPriority(){
                            j += 1
                        } else {break}
                    } else {break}
                }
                if(j==output.count){
                    output.append(self.tasks[i])
                } else {
                    output.insert(self.tasks[i], at:j)
                }
                
            }
            self.tasks = output
        }
    }
    
    public func updateRange(){
        if(!self.freeTime){
            self.organize()
            self.begin = self.tasks[0].getBegin()
            self.end = self.tasks[self.tasks.count-1].getBegin().addMinutes(minutes: self.tasks[self.tasks.count-1].getDuration())
        }
    }
    
    public func getDisplayRange() -> String {
        if(!self.begin.equals(dateTime: self.end, onlyDate:true)){
            return self.begin.getFormattedDate(weekday:false) + " " + self.begin.getFormattedTime() + " to " + self.end.getFormattedDate(weekday:false) + " " + self.end.getFormattedTime()
        } else {
            return self.begin.getFormattedTime() + " to " + self.end.getFormattedTime()
        }
    }
    

    public func overlapsPrevious(index: Int) -> Bool{
        if(index > 0){
            return self.tasks[index].getBegin().compareToDate(date: self.tasks[index-1].getEnd().convertToDate()) < 0
        } else {
            return false
        }
    }
    
    public func getNewTask() -> Task{
        self.tasks.append(Task(begin:DateTime.getNow(rounded:true)))
        self.freeTime = false
        return self.tasks[self.tasks.count-1]
    }
    public func addTasks(tasks: [Task]){
            for task in tasks {
                self.tasks.append(task)
            }
        if(self.tasks.count > 0){self.freeTime = false}
    }
    public func replaceTask(task: Task, id: Int){
        self.tasks[id] = task
    }
    public func getTasks() -> [Task]{
        return self.tasks
    }
    public func removeTask(id: Int){
        self.tasks.remove(at:id)
        if(self.tasks.count == 0) {self.freeTime = true}
    }
    public func getBegin() -> DateTime {
        self.updateRange()
        return self.begin
    }
    public func getEnd() -> DateTime {
        self.updateRange()
        return self.end
    }
    public func getFreeTime() -> Bool{
        return self.freeTime
    }
    
}
