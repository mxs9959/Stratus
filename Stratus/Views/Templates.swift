//
//  Templates.swift
//  Stratus
//
//  Created by Max Scholle on 11/23/23.
//

import SwiftUI

struct TemplatesView: View {
    
    @EnvironmentObject var config: Config
    
    @StateObject var templates: Templates = Templates()
    
    @State var editingTemplate: [Int] = []
    
    var body: some View {
        NavigationStack(path:$editingTemplate) {
            VStack(spacing:0) {
                
                //HEADER
                HStack {
                    Text("Templates")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .bold()
                        .padding()
                    Button(action:templates.addSampleTemplate) {
                        Image(systemName:"plus")
                            .foregroundStyle(Color.accentColor)
                            .imageScale(.large)
                    }
                }
                .frame(width:UIScreen.main.bounds.width, height: Consts.headerHeight)
                .background(.ultraThinMaterial)
                
                //BODY
                if(templates.getTemplates().count > 0){
                    List(0..<templates.getTemplates().count, id:\.self){id in
                        TemplateView(templates:templates, id:id)
                            .listRowBackground(templates.getTemplates()[id].getColor())
                            .swipeActions {
                                Button("Delete"){
                                    templates.removeTemplate(id: id)
                                }
                                .tint(.red)
                                Button("Edit"){
                                    editingTemplate = [id]
                                }
                                .tint(.yellow)
                            }
                    }
                } else {
                    Text("You have no templates.\n\nTap the plus to create a template.")
                        .multilineTextAlignment(.center)
                        .frame(maxHeight:.infinity)
                }
            }
            .background(Color("BodyBackground"))
            .frame(width:UIScreen.main.bounds.width)
            .navigationDestination(for: Int.self){id in
                EditTemplate(templates: templates, details: TemplateDetails(details: templates.getTemplates()[id].getTemplateDetails()), editingTemplate: $editingTemplate, id: id)
            }
        }
    }
}

struct TemplateView: View {
    
    @ObservedObject var templates: Templates
    
    var id: Int
    
    func getThisTemplate() -> Template{
        return templates.getTemplates()[id]
    }
    
    var body: some View {
            HStack {
                Text(getThisTemplate().getName())
                    .foregroundColor(.black)
                    .padding(.leading, Consts.scrollPadding)
                if(getThisTemplate().getMandatory()){
                    Image(systemName: "star.fill")
                }
                Spacer()
                Text("\(getThisTemplate().getPriority())")
                    .foregroundColor(.black)
                    .padding(.all, Consts.scrollPadding)
                    .background(Color.accentColor)
                    .cornerRadius(Consts.cornerRadiusField)
                    .padding(.trailing, Consts.scrollPadding)
            }
        }
}

struct EditTemplate: View {
    
    @EnvironmentObject var config: Config
    
    @ObservedObject var templates: Templates
    
    @StateObject var details: TemplateDetails
    
    @Binding var editingTemplate: [Int]
    
    var id: Int
    
    func edit(){
        editingTemplate = []
        templates.manualUpdate()
        templates.replaceTemplate(id: id, template: Template(name: details.name, priority: Int(details.priority), mandatory: details.mandatory, duration: Int(details.duration) ?? 60, color: details.color))
    }
    
    var body: some View {
        VStack {
            Text("\((id<0) ? "Add" : "Edit") Template")
                .font(.title)
                .bold()
                .padding()
            ScrollView {
                TextField("Name", text:$details.name)
                    .padding(.all, Consts.scrollPadding)
                    .foregroundColor(.gray)
                HStack {
                    Text("Duration (minutes):")
                    TextField("", text:$details.duration)
                        .foregroundColor(.gray)
                }
                .padding(.all, Consts.scrollPadding)
                HStack {
                    Text("Priority")
                    Slider(value: $details.priority, in: 0...10)
                        .padding(.horizontal, Consts.scrollPadding)
                    Text("\(Int(details.priority))")
                }
                .padding(.all, Consts.scrollPadding)
                Toggle("Mandatory", isOn:$details.mandatory)
                    .padding(.all, Consts.scrollPadding)
                ColorPicker("Template Color", selection:$details.color)
                    .padding(.all, Consts.scrollPadding)
            }
            .frame(maxHeight:.infinity)
            Button(action:edit){
                Label("Done", systemImage:"checkmark")
            }
            .padding()
        }
        .frame(width:Consts.scrollWidthEditing)
        .background(Color("BodyBackground"))
    }
    
}

#Preview {
    TemplatesView().environmentObject(Config())
}
