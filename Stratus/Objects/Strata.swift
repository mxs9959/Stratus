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
    
    init(){
        self.strata = []
    }
    
    public func manualUpdate(){
        objectWillChange.send()
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
