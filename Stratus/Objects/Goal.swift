//
//  Goal.swift
//  Stratus
//
//  Created by Max Scholle on 2/10/24.
//

import Foundation
import SwiftUI

class Goal: ObservableObject, Codable {
    
    @Published private var templates: [Template]
    @Published private var name: String
    @Published private var enabled: Bool
    
    init(name: String){
        self.templates = []
        self.name = name
        self.enabled = true
    }
    
    enum CodingKeys: CodingKey {
        case templates
        case name
        case enabled
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        templates = try container.decode([Template].self, forKey: .templates)
        name = try container.decode(String.self, forKey: .name)
        enabled = try container.decode(Bool.self, forKey: .enabled)
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(templates, forKey: .templates)
        try container.encode(name, forKey: .name)
        try container.encode(enabled, forKey: .enabled)
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
    public func setEnabled(enabled: Bool){
        self.enabled = enabled
    }
    public func getEnabled() -> Bool{
        return self.enabled
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
