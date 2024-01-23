//
//  Home.swift
//  Stratus
//
//  Created by Max Scholle on 11/22/23.
//

import SwiftUI

struct Home: View {
    
    @EnvironmentObject var config: Config
    @EnvironmentObject var strata: Strata
    
    @State var editingTask: [[Int]] = []
    
    func detailsToPass(ids: [Int]) -> TaskDetails{
        if(ids[0]>=0 && ids[1] < strata.getStrata()[ids[0]].getTasks().count){
            return TaskDetails(details: strata.getStrata()[ids[0]].getTasks()[ids[1]].getDetails())
        } else {
            return TaskDetails(details: TaskDetails.getSampleDetails())
        }
    }
    
    var body: some View {
        NavigationStack(path:$editingTask) {
            
            //CONTENT
            VStack(spacing:0) {
                
                //HEADER
                HStack {
                    Text("Your Strats")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .bold()
                        .padding()
                }
                .frame(width:UIScreen.main.bounds.width, height: Consts.headerHeight)
                .background(Color("Header"))
                
                //BODY
                if(strata.getStrata().count > 1){
                    //Listing strats
                    ScrollView {
                        VStack {
                            ForEach(0..<strata.getStrata().count, id:\.self){ i in
                                StratView(strata:strata, id:i)
                            }
                        }
                        .padding(.vertical, Consts.scrollVerticalPadding)
                    }
                } else {
                    //If no tasks
                    Spacer()
                    Text("You have no strats.\n\nTap the plus to create a new task.")
                        .multilineTextAlignment(.center)
                    NavigationLink(value:[-1,-1]){
                        Image(systemName:"plus")
                            .padding(Consts.scrollVerticalPadding)
                    }
                    Spacer()
                    StratView(strata:strata, id:0)
                        .padding()
                }
            }
            .frame(width:UIScreen.main.bounds.width)
            .background(Color("BodyBackground"))
            .navigationDestination(for: [Int].self){ids in
                
                EditTask(
                    strata:strata,
                    details: detailsToPass(ids: ids),
                    editingTask: $editingTask,
                    stratId: ids[0],
                    taskId: ids[1],
                    newTask: !(ids[0]>=0 && ids[1] < strata.getStrata()[ids[0]].getTasks().count)
                )
                .navigationBarBackButtonHidden(true)
            }
        }
    }
}

struct StratView: View {
    
    @ObservedObject var strata: Strata
    
    var id: Int
    
    var body: some View {
        
        if strata.getStrata()[id].sleep {
            VStack {
                HStack {
                    Image(systemName:"moon.stars.fill")
                        .foregroundStyle(.purple)
                    Text("Sleep").bold()
                        .font(.title3)
                    
                }
                Text("\(strata.getStrata()[id].getDisplayRange())")
                    .font(.subheadline)
            }
        } else {
            
            VStack {
                Text(strata.getStrata()[id].getDisplayRange())
                    .font(.subheadline)
                    .padding(.top, Consts.scrollPadding)
                VStack(spacing:0) {
                    ForEach(0..<strata.getStrata()[id].getTasks().count, id:\.self){ i in
                        TaskView(strata:strata, id: i, stratId: id)
                    }
                }
                .cornerRadius(Consts.cornerRadius)
                .padding(.bottom,Consts.scrollPadding)
                NavigationLink(value:[id,strata.getStrata()[id].getTasks().count]){
                    Image(systemName:"plus")
                }
            }
            .padding(.all, Consts.scrollPadding)
            .background(Color("Header"))
            .cornerRadius(Consts.cornerRadius)
        }
    }
}

struct TaskView: View {
    
    @ObservedObject var strata: Strata
    
    var id: Int
    var stratId: Int
    
    func getThisTask() -> Task {
        return strata.getStrata()[stratId].getTasks()[id]
    }
    
    var body: some View {
        NavigationLink(value: [stratId, id]){
            HStack {
                Text(getThisTask().getTitle())
                    .bold()
                    .padding(.trailing, Consts.scrollPadding)
                Text(getThisTask().getBegin().getFormattedTime() + " to " + getThisTask().getEnd().getFormattedTime())
            }
            .foregroundStyle(Color.black)
            .frame(width:Consts.scrollWidthStrata, height:CGFloat(getThisTask().getDuration())*Consts.widthToMinutes)
            .background(getThisTask().getColor())
        }
    }
}

struct EditTask: View {
    
    @EnvironmentObject var config: Config
    
    @ObservedObject var strata: Strata
    
    @StateObject var details: TaskDetails
    @Binding var editingTask: [[Int]]
    
    @State var stratId: Int
    var taskId: Int
    var newTask: Bool
    
    func edit(){
        editingTask = []
        if(newTask){
            if(stratId<0){
                stratId = 0 //strata.findStrat(begin:details.begin)
            }
            if(strata.getStrata().count == 0){
                strata.addSampleStrat()
            }
            strata.addTasksToStrat(id: stratId, tasks: [Task(priority: Int(details.priority), mandatory: details.mandatory, duration: Int(details.duration) ?? 60, begin: DateTime.convertDateToDT(date: details.begin), color: details.color, title: details.title)])
        } else {
            strata.replaceTaskInStrat(stratId: stratId, taskId:taskId, task: Task(priority: Int(details.priority), mandatory: details.mandatory, duration: Int(details.duration) ?? 60, begin: DateTime.convertDateToDT(date: details.begin), color: details.color, title: details.title))
        }
        strata.getStrata()[stratId].updateRange()
        strata.manualUpdate()
    }
    
    var body: some View {
        Group{
            VStack(spacing:0) {
                Text("\(newTask ? "Add" : "Edit") Task")
                    .font(.title)
                    .bold()
                    .padding()
                    .frame(width:UIScreen.main.bounds.width, height: Consts.headerHeight)
                    .background(Color("Header"))
                ScrollView {
                    TextField("Name", text:$details.title)
                        .padding(.all, Consts.scrollPadding)
                        .background(Color("Header"))
                        .cornerRadius(Consts.cornerRadiusField)
                    ColorPicker("Task Color", selection:$details.color)
                        .padding(.all, Consts.scrollPadding)
                    DatePicker("Start Time", selection:$details.begin)
                        .padding(.all, Consts.scrollPadding)
                    HStack {
                        Text("Duration (minutes):")
                        TextField("", text:$details.duration)
                            .foregroundColor(.black)
                            .padding(.all, Consts.scrollPadding)
                            .background(Color("Header"))
                            .cornerRadius(Consts.cornerRadiusField)
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
                }
                .padding(.vertical, Consts.scrollPadding)
                .frame(height:.infinity)
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
    Home().environmentObject(Config()).environmentObject(Strata())
}
