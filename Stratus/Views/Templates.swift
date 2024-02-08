//
//  Templates.swift
//  Stratus
//
//  Created by Max Scholle on 11/23/23.
//

import SwiftUI

struct TemplatesView: View {
    
    @EnvironmentObject var strata: Strata
    @EnvironmentObject var config: Config
    
    @StateObject var templates: Templates = Templates()
    
    @State var editingTemplate: [[Int]] = []
    
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
                .background(Color("Header"))
                
                //BODY
                if(templates.getTemplates().count > 0){
                    List(0..<templates.getTemplates().count, id:\.self){id in
                            TemplateView(templates:templates, editingTemplate: $editingTemplate, id:id)
                            .listRowBackground(Color.header)
                                .swipeActions(allowsFullSwipe: false) {
                                    Button(role:.destructive){
                                        templates.removeTemplate(id: id)
                                    } label: {Label("Delete", systemImage:"trash.fill")}
                                    Button {
                                        editingTemplate = [[id, -1]]
                                    } label: {Label("Edit", systemImage:"pencil")}
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
            .navigationDestination(for: [Int].self){id in
                if(id[0]>=0){
                    EditTemplate(templates: templates, details: TemplateDetails(details: templates.getTemplates()[id[0]].getTemplateDetails()), editingTemplate: $editingTemplate, id: id[0])
                } else {
                    EditTask(strata: strata, details: TaskDetails(details: templates.getTemplates()[id[1]].getTemplateDetails()), editingTask: $editingTemplate, stratId: -1, taskId: -1, newTask: true)
                }
            }
        }
    }
}

struct TemplateView: View {
    
    @ObservedObject var templates: Templates
    
    @Binding var editingTemplate: [[Int]]
    
    var id: Int
    
    func getThisTemplate() -> Template{
        return templates.getTemplates()[id]
    }
    
    var body: some View {
        if(id<templates.getTemplates().count){
            NavigationLink(value:[-1,id]){
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
                        .background(getThisTemplate().getColor())
                        .cornerRadius(Consts.cornerRadiusField)
                        .padding(.trailing, Consts.scrollPadding)
                }
            }
        }
    }
}

struct EditTemplate: View {
    
    @EnvironmentObject var config: Config
    
    @ObservedObject var templates: Templates
    
    @StateObject var details: TemplateDetails
    
    @Binding var editingTemplate: [[Int]]
    
    var id: Int
    
    func edit(){
        editingTemplate = []
        templates.manualUpdate()
        templates.replaceTemplate(id: id, template: Template(name: details.name, priority: Int(details.priority), mandatory: details.mandatory, duration: Int(details.duration) ?? 60, color: details.color))
    }
    
    var body: some View {
        VStack {
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
        }
        .frame(width:UIScreen.main.bounds.width)
        .background(Color("BodyBackground"))
    }
    
}

#Preview {
    TemplatesView().environmentObject(Config()).environmentObject(Strata())
}
