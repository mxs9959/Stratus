//
//  Strata.swift
//  Stratus
//
//  Created by Max Scholle on 11/22/23.
//

import Foundation
import SwiftUI

class Strata: ObservableObject {
    
    @Published private var strata: [Strat]
    @Published private var sleepTime: Int //Sleep time in minutes
    @Published private var freeTimeTotal: Int //Free time total in minutes
    
    init(){
        self.strata = []
        self.sleepTime = 480
        self.freeTimeTotal = 960
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
            if(!self.strata[i].getFreeTime() && (self.strata[i].getBegin().compareToDate(date: begin)<=0 && self.strata[i].getEnd().compareToDate(date: begin)>=0)){
                return i
            }
        }
        self.addSampleStrat()
        return self.strata.count - 1
    }
    
    public func organize(){
        var output: [Strat] = [self.strata[0]]
        for i in 1..<self.strata.count {
            if(self.strata[i].getFreeTime()){
                continue
            }
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
        for i in 1..<output.count {
            output.insert(Strat(begin: output[2*i-2].getEnd(), end:output[2*i-1].getBegin()), at:2*i-1)
        }
        self.strata = output
    }
    
    public func populateRecurring(goals: Goals){
        
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
    public func getFreeTimeForDay(day: DateTime) -> Int{
        var total: Int = 0
        for strat in self.strata {
            if strat.getBegin().equals(dateTime: day, onlyDate: true) && strat.getFreeTime(){
                total += strat.getEnd().compareToDate(date: strat.getBegin().convertToDate())
            }
        }
        return total
    }
    
}

class Goals: ObservableObject {
    
    @Published private var goals: [Goal]
    
    init(){
        self.goals = [Goal(name: "Unassigned Templates")]
    }
    
    public func manualUpdate(){
        objectWillChange.send()
    }
    
    public func anyTemplates() -> Bool {
        for goal in goals {
            if goal.getTemplates().count > 0{
                return true
            }
        }
        return false
    }
    
    public func getGoals() -> [Goal]{
        return self.goals
    }
    
    public func createGoal(name: String, config: Config){
        self.goals.append(Goal(name:name))
        self.refreshGoalsEnabled(config: config)
    }
    
    public func createTemplate(){
        self.goals[0].addTemplate(template: Template())
        objectWillChange.send()
    }
    
    public func replaceTemplateInGoal(id: Int, goalId: Int, template: Template){
        self.goals[goalId].replaceTemplate(id: id, template:template)
    }
    
    public func removeTemplateInGoal(id: Int, goalId: Int, config: Config) {
        self.goals[goalId].removeTemplate(id: id)
        if(self.goals[goalId].getTemplates().count == 0 && self.goals.count >= 2){
            self.goals.remove(at: goalId)
            self.refreshGoalsEnabled(config: config)
        }
        
    }
    
    public func changeGoalName(id: Int, name: String){
        self.goals[id].setName(name:name)
    }
    
    public func refreshGoalsEnabled(config: Config){
        var result: [Bool] = []
        for goal in self.goals {
            result.append(goal.getEnabled())
        }
        config.goalsEnabled = result
    }
    public func updateFromConfig(config: Config){
        for i in 0..<self.goals.count {
            self.goals[i].setEnabled(enabled: config.goalsEnabled[i])
        }
    }
    
}
