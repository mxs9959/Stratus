//
//  Goal.swift
//  Stratus
//
//  Created by Max Scholle on 2/10/24.
//

import Foundation
import SwiftUI

class Goal: ObservableObject {
    
    @Published private var templates: [Template]
    
    @Published private var name: String
    
    init(name: String){
        self.templates = []
        self.name = name
    }
    
    public func getTemplates() -> [Template] {
        return self.templates
    }
    
    public func getName() -> String{
        return name
    }
    public func setName(name: String){
        self.name = name
    }
    
    public func addTemplate(template: Template){
        self.templates.append(template)
    }
    public func removeTemplate(id: Int){
        self.templates.remove(at:id)
    }
    public func replaceTemplate(id: Int, template: Template){
        self.templates[id] = template
    }
}
