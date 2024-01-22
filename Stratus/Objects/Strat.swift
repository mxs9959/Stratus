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
    
    init() {
        self.begin = DateTime.getNow(rounded: true)
        self.end = DateTime.getNow(rounded: true).addMinutes(minutes: 60)
        self.tasks = [Task(begin:DateTime.getNow(rounded: true))]
    }
    
    public func getDisplayRange() -> String {
        if(self.begin.getFormattedDate() != self.end.getFormattedDate()){
            return self.begin.getFormattedDate() + " " + self.begin.getFormattedTime() + " to " + self.end.getFormattedDate() + " " + self.end.getFormattedTime()
        } else {
            return self.begin.getFormattedDate() + ", " + self.begin.getFormattedTime() + " to " + self.end.getFormattedTime()
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
}
