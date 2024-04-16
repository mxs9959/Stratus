//
//  Strata.swift
//  Stratus
//
//  Created by Max Scholle on 11/22/23.
//

import Foundation
import SwiftUI

class Strata: ObservableObject, Codable {
    
    @Published private var strata: [Strat]
    @Published private var sleepTime: Int //Sleep time in minutes
    @Published private var freeTimeTotal: Int //Free time total in minutes
    
    init(){
        self.strata = []
        self.sleepTime = 480
        self.freeTimeTotal = 960
    }
    
    init(strata: [Strat]){
        self.strata = strata
        self.sleepTime = 480
        self.freeTimeTotal = 960
    }
    
    enum CodingKeys: CodingKey {
        case strata
        case sleepTime
        case freeTimeTotal
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        strata = try container.decode([Strat].self, forKey: .strata)
        sleepTime = try container.decode(Int.self, forKey: .sleepTime)
        freeTimeTotal = try container.decode(Int.self, forKey: .freeTimeTotal)
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(strata, forKey: .strata)
        try container.encode(sleepTime, forKey: .sleepTime)
        try container.encode(freeTimeTotal, forKey: .freeTimeTotal)
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
                let strata = try JSONDecoder().decode(Strata.self, from: jsonData)
                self.strata = strata.strata
                self.sleepTime = strata.sleepTime
                self.freeTimeTotal = strata.freeTimeTotal
            }
        } catch {
            print("An error occurred while decoding strata object: \(error).")
        }
    }
    public func generateRecurrentTasks(goals: Goals){
        var c = 0
        for i in 0..<goals.getGoals().count{
            if(goals.getGoals()[i].getEnabled()){
                let goal = goals.getGoals()[i]
                for template in goal.getTemplates(){
                    if(template.getRecurrence()>0){
                        for d in 0..<Consts.recurrenceLimit {
                            c+=1
                            let date = DateTime.convertDateToDT(date: template.getRecurrenceStart()).addMinutes(minutes: d*template.getRecurrence()*1440).convertToDate()
                            self.addTasksToStrat(id: findStrat(begin: date), tasks: [Task(details: TemplateDetails(details: template.getTemplateDetails()), begin: DateTime.convertDateToDT(date: date))])
                        }
                    }
                }
            }
        }
        self.organize()
    }
    
    public func removeRecurrentTasks() -> Strata {
        var c = 0
        for strat in strata {
            let ref = strat.getTasks().count-1
            for i in 0..<strat.getTasks().count{
                if(strat.getTasks()[ref-i].getRecurrence()>0){
                    strat.removeTask(id: ref-i)
                    c+=1
                }
            }
        }
        return self
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
        if(self.strata.count > 0){
            var output: [Strat] = []
            for i in 0..<self.strata.count {
                if(self.strata[i].getFreeTime()){
                    continue
                }
                var j = 0
                if(j < output.count){
                    while self.strata[i].getBegin().compareToDate(date: output[j].getBegin().convertToDate())>0{
                        j += 1
                        if(j==output.count){
                            break
                        }
                    }
                }
                if(j==output.count){
                    output.append(self.strata[i])
                } else {
                    output.insert(self.strata[i], at:j)
                }
            }
            for i in 1..<output.count {
                if(i<output.count && output[i-1].getEnd().compareToDate(date: output[i].getBegin().convertToDate())>=0){
                    output[i-1].addTasks(tasks: output[i].getTasks())
                    output.remove(at:i)
                }
            }
            for i in 0..<output.count {
                if(2*i+1<output.count && output[2*i].getEnd().equals(dateTime: output[2*i+1].getBegin(), onlyDate: true)){
                    output.insert(Strat(begin: output[2*i].getEnd(), end:output[2*i+1].getBegin()), at:2*i+1)
                }
            }
            self.strata = output
        }
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

class Goals: ObservableObject, Codable {
    
    @Published private var goals: [Goal]
    
    init(){
        self.goals = [Goal(name: "Unassigned Templates")]
    }
    
    enum CodingKeys: CodingKey {
        case goals
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        goals = try container.decode([Goal].self, forKey: .goals)
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(goals, forKey: .goals)
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
                let goals = try JSONDecoder().decode(Goals.self, from: jsonData)
                self.goals = goals.goals
            }
        } catch {
            print("An error has occurred while decoding goals object: \(error).")
        }
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
        self.manualUpdate()
        
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
