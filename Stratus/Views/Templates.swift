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
    @EnvironmentObject var goals: Goals
    
    @State var editingTemplate: [[Int]] = []
    
    var body: some View {
        NavigationStack(path:$editingTemplate) {
            VStack(spacing:0) {
                
                //HEADER
                HStack {
                    Text("Goals")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .bold()
                        .padding()
                    NavigationLink(value:[0,-1]){
                        Image(systemName:"plus")
                            .foregroundStyle(Color.accentColor)
                            .imageScale(.large)
                    }
                }
                .frame(width:UIScreen.main.bounds.width, height: Consts.headerHeight)
                .background(Color("Header"))
                //BODY
                if(goals.anyTemplates()){
                    List(0..<goals.getGoals().count, id:\.self){goalId in
                        if(goals.getGoals()[goalId].getTemplates().count > 0){
                            Section(header: Text("\(goals.getGoals()[goalId].getName())")){
                                ForEach(0..<goals.getGoals()[goalId].getTemplates().count, id:\.self){id in
                                    TemplateView(editingTemplate: $editingTemplate, goalId: goalId, id:id)
                                        .listRowBackground(Color.header)
                                        .swipeActions(allowsFullSwipe: false) {
                                            Button(role:.destructive){
                                                goals.removeTemplateInGoal(id: id, goalId: goalId, config: config)
                                                goals.manualUpdate()
                                            } label: {Label("Delete", systemImage:"trash.fill")}
                                            Button {
                                                editingTemplate = [[goalId, id]]
                                            } label: {Label("Edit", systemImage:"pencil")}
                                        }
                                }
                            }
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
                    if(id[1]>=0){
                        EditTemplate(details: TemplateDetails(details: goals.getGoals()[id[0]].getTemplates()[id[1]].getTemplateDetails()), editingTemplate: $editingTemplate, goalName: goals.getGoals()[id[0]].getName(), goalId: id[0], originalGoalId: id[0], newTemplate: false, id: id[1])
                            .navigationBarBackButtonHidden(true)
                    } else {
                        EditTemplate(details:TemplateDetails(), editingTemplate: $editingTemplate, goalName: goals.getGoals()[id[0]].getName(), goalId: 0, originalGoalId: id[0], newTemplate: true, id: 0)
                            .navigationBarBackButtonHidden(true)
                    }
                } else {
                    EditTask(details: TaskDetails(details: goals.getGoals()[-id[0]-1].getTemplates()[id[1]].getTemplateDetails()), editingTask: $editingTemplate, stratId: -1, taskId: -1, newTask: true)
                        .navigationBarBackButtonHidden(true)
                }
            }
        }
    }
}

struct TemplateView: View {
    
    @EnvironmentObject var goals: Goals
    
    @Binding var editingTemplate: [[Int]]
    
    var goalId: Int
    var id: Int
    
    func getThisTemplate() -> Template{
        return goals.getGoals()[goalId].getTemplates()[id]
    }
    
    var body: some View {
        if(goalId<goals.getGoals().count && id<goals.getGoals()[goalId].getTemplates().count){
            NavigationLink(value:[-goalId-1,id]){
                HStack {
                    Text(getThisTemplate().getName())
                        .foregroundColor(.black)
                        .padding(.leading, Consts.scrollPadding)
                    if(getThisTemplate().getMandatory()){
                        Image(systemName: "star.fill")
                    }
                    Spacer()
                    if(getThisTemplate().getRecurrence() > 0){
                        Text("\(getThisTemplate().getRecurrence())")
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
    @EnvironmentObject var goals: Goals
    
    @StateObject var details: TemplateDetails
    
    @Binding var editingTemplate: [[Int]]
    
    @State var goalName: String
    @State var goalId: Int
    
    var originalGoalId: Int
    var newTemplate: Bool
    var id: Int
    
    func edit(){
        editingTemplate = []
        let newGoal: Bool = goalId==goals.getGoals().count
        if(newGoal){
            goalId = goals.getGoals().count
            goals.createGoal(name: goalName, config: config)
        }
        goals.changeGoalName(id:goalId, name:goalName)
        if(newTemplate){
            goals.getGoals()[goalId].addTemplate(template: Template(name: details.name, priority: Int(details.priority), mandatory: details.mandatory, duration: Int(details.duration) ?? 60, color: details.color, recurrence: details.recurrence, recurrenceStart: details.recurrenceBegin))
        } else if(goalId != originalGoalId){
            goals.getGoals()[goalId].addTemplate(template: Template(name: details.name, priority: Int(details.priority), mandatory: details.mandatory, duration: Int(details.duration) ?? 60, color: details.color, recurrence: details.recurrence, recurrenceStart: details.recurrenceBegin))
            goals.removeTemplateInGoal(id:id, goalId:originalGoalId, config: config)
        } else {
            goals.replaceTemplateInGoal(id: id, goalId: goalId, template: Template(name: details.name, priority: Int(details.priority), mandatory: details.mandatory, duration: Int(details.duration) ?? 60, color: details.color, recurrence: details.recurrence, recurrenceStart: details.recurrenceBegin))
        }
        goals.manualUpdate()
    }
    
    var body: some View {
            VStack {
                HStack {
                    Button(action:{editingTemplate = []}){
                        Image(systemName:"xmark")
                            .imageScale(.large)
                    }
                    Text("\(newTemplate ? "Add" : "Edit") Template")
                        .font(.title)
                        .bold()

                }
                .padding()
                .frame(width:UIScreen.main.bounds.width, height: Consts.headerHeight)
                .background(Color("Header"))
                Form {
                    Group{
                        Section(header:Text("General")){
                            HStack {
                                Text("Title:")
                                Spacer()
                                TextField("", text:$details.name)
                                    .foregroundColor(Color.accentColor)
                            }
                            HStack {
                                Text("Duration (min):")
                                Spacer()
                                TextField("",text:$details.duration)
                                    .foregroundColor(Color.accentColor)
                            }
                            ColorPicker("Template Color", selection:$details.color)
                        }
                        Section(header:Text("Priority")){
                            HStack {
                                Text("Priority")
                                Slider(value: $details.priority, in: 0...10)
                                Text("\(Int(details.priority))")
                            }
                            Toggle("Mandatory", isOn:$details.mandatory)
                        }
                        Section(header:Text("Goal Assignment")){
                            HStack {
                                Picker("Goal Assignment", selection:$goalId){
                                    ForEach(0...goals.getGoals().count, id:\.self){ i in
                                        if(i<goals.getGoals().count){
                                            Text(goals.getGoals()[i].getName())
                                        } else {
                                            Text("Create new goal...")
                                        }
                                    }
                                }
                                .onChange(of:goalId){
                                    if(goalId<goals.getGoals().count){
                                        goalName = goals.getGoals()[goalId].getName()
                                    }
                                }
                            }
                            HStack{
                                if(goalId==goals.getGoals().count){
                                    Text("Name your new goal:")
                                } else {
                                    Text("Rename \"\(goals.getGoals()[goalId].getName())\":")
                                }
                                Spacer()
                                TextField("", text:$goalName)
                                    .foregroundColor(Color.accentColor)
                            }
                        }
                        Section("Recurrence"){
                            HStack {
                                Stepper(onIncrement: {details.recurrence += 1}, onDecrement: {if(details.recurrence>0){details.recurrence -= 1}}){
                                    if(details.recurrence == 0){
                                        Text("Repeat never")
                                    } else {
                                        Text("Repeat every \(details.recurrence) day(s)")
                                    }
                                }
                            }
                            if(details.recurrence>0){
                                DatePicker("Begin: ", selection: $details.recurrenceBegin, displayedComponents: [.date, .hourAndMinute])
                                 
                            }
                        }
                    }
                }
                        .frame(maxHeight:.infinity)
                        .frame(width: Consts.scrollWidthEditing)
                        .padding(.vertical, Consts.scrollPadding)
                        Button(action:edit){
                            Label("Done", systemImage:"checkmark")
                        }
                        .padding()
            }
            .frame(width:UIScreen.main.bounds.width)
            .background(Color("BodyBackground"))
        }
}

#Preview {
    TemplatesView().environmentObject(Config()).environmentObject(Strata()).environmentObject(Goals())
}
