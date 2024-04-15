//
//  Home.swift
//  Stratus
//
//  Created by Max Scholle on 11/22/23.
//

import SwiftUI

struct Home: View {
    
    @AppStorage("newbie") var newbie: Bool = true
    
    @AppStorage("config") var configJSON: String = Config().toJSONString()
    @AppStorage("strata") var strataJSON: String = Strata().toJSONString()
    @AppStorage("goals") var goalsJSON: String = Goals().toJSONString()
    
    @EnvironmentObject var config: Config
    @EnvironmentObject var strata: Strata
    @EnvironmentObject var goals: Goals
    
    @State var editingTask: [[Int]] = []
    
    @StateObject var showingDate: DateTime = DateTime.getNow(rounded: false)
    
    func detailsToPass(ids: [Int]) -> TaskDetails{
        if(ids[0]>=0 && ids[1] < strata.getStrata()[ids[0]].getTasks().count){
            return TaskDetails(details: strata.getStrata()[ids[0]].getTasks()[ids[1]].getDetails())
        } else {
            return TaskDetails(details: TaskDetails.getSampleDetails())
        }
    }
    
    var body: some View {
        NavigationStack(path:$editingTask) {
            
            ZStack {
                
                //CONTENT
                VStack(spacing:0) {
                    
                    //HEADER
                    HStack {
                        NavigationLink(value:[-1,-1,-1]){
                            Image(systemName:"info.circle")
                                .imageScale(.large)
                        }
                        Text("Your Strats")
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                            .bold()
                            .padding()
                        NavigationLink(value:[-1,-1]){
                            Image(systemName:"plus")
                                .imageScale(.large)
                        }
                    }
                    .frame(width:UIScreen.main.bounds.width, height: Consts.headerHeight)
                    .background(Color("Header"))
                    
                    //BODY
                    HStack {
                        Button(action:{showingDate.addDaysToThis(days: -1)}){
                            Image(systemName:"arrow.left.circle.fill")
                                .imageScale(.large)
                                .padding()
                        }
                        Spacer()
                        Text("\(showingDate.getFormattedDate(weekday:true))")
                            .padding()
                        
                        Spacer()
                        Button(action:{showingDate.addDaysToThis(days: 1)}){
                            Image(systemName:"arrow.right.circle.fill")
                                .imageScale(.large)
                                .padding()
                        }
                    }
                    
                    if(strata.stratsOnDay(day: showingDate)){
                        //Listing strats
                        ScrollView {
                            VStack {
                                ForEach(0..<strata.getStrata().count, id:\.self){ i in
                                    if(strata.getStrata()[i].getBegin()).equals(dateTime: showingDate, onlyDate: true){
                                        StratView(strata:strata, id:i)
                                    }
                                }
                            }
                            .padding(.vertical, Consts.scrollVerticalPadding)
                        }
                    } else {
                        //If no tasks
                        Spacer()
                        Text("You have no strats on this day.")
                            .multilineTextAlignment(.center)
                            .padding()
                        Text(Consts.randomEmoji())
                            .font(.title)
                            .padding()
                    }
                    Spacer()
                    HStack {
                        if(config.sleepEnabled){
                            VStack {
                                HStack {
                                    Image(systemName:"moon.stars.fill")
                                        .foregroundStyle(.purple)
                                    Text("Sleep").bold()
                                        .font(.title3)
                                    
                                }
                                Text(config.getSleepDisplayRange())
                                    .font(.subheadline)
                            }
                            .padding(.all, Consts.scrollPadding)
                        }
                        if(config.freeTimeEnabled && strata.stratsOnDay(day: showingDate)){
                            VStack {
                                Text("\(Int(Double(strata.getFreeTimeForDay(day: showingDate))/(config.freeTimeTarget*60)*100))%")
                                Text("Free Time Goal Met")
                                    .font(.caption2)
                            }
                            .foregroundColor(.black)
                            .padding(.all, Consts.scrollPadding)
                            .background(Color.accentColor)
                            .cornerRadius(Consts.cornerRadiusField)
                            .padding(.trailing, Consts.scrollPadding)
                        }
                    }
                }
                .frame(width:UIScreen.main.bounds.width)
                .background(Color("BodyBackground"))
                .navigationDestination(for: [Int].self){ids in
                    if(ids.count == 3){
                        About()
                    } else {
                        EditTask(
                            details: detailsToPass(ids: ids),
                            editingTask: $editingTask,
                            stratId: ids[0],
                            taskId: ids[1],
                            newTask: !(ids[0]>=0 && strata.getStrata().count > 0 && ids[1] < strata.getStrata()[ids[0]].getTasks().count)
                        )
                        .navigationBarBackButtonHidden(true)
                    }
                }
                
                if(newbie){
                    Welcome(newbie:$newbie)
                } else {
                    //Button("Reset"){newbie = true}
                }
            }
            .onAppear(){
                config.fromJSONString(json: configJSON)
                strata.removeRecurrentTasks().fromJSONString(json: strataJSON)
                goals.fromJSONString(json: goalsJSON)
                strata.generateRecurrentTasks(goals: goals, config: config)
                print(strata.getStrata().count)
            }
            
        }
            
    }
}

struct StratView: View {
    
    @ObservedObject var strata: Strata
    
    var id: Int
    
    var body: some View {
        if(strata.getStrata().count > id){ //Bug fix to prevent index-out-of-range error
            if(strata.getStrata()[id].getFreeTime()){
                VStack {
                    Text(Consts.randomEmoji() + " Free Time").bold()
                            .font(.title3)
                    Text(strata.getStrata()[id].getDisplayRange())
                        .font(.subheadline)
                }
                .padding(.all, Consts.scrollPadding)
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
}

struct TaskView: View {
    
    @ObservedObject var strata: Strata
    
    var id: Int
    var stratId: Int
    
    func getThisTask() -> Task {
        return strata.getStrata()[stratId].getTasks()[id]
    }
    func getConflict() -> Bool {
        return strata.getStrata()[stratId].overlapsPrevious(index: id)
    }
    
    var body: some View {
        if(strata.getStrata().count > stratId){ //Subsequent bug fix
            if(strata.getStrata()[stratId].getTasks().count > id){ //Fixed index-out-of-range bug
                NavigationLink(value: [stratId, id]){
                    VStack {
                        HStack {
                            if(getThisTask().getMandatory()){
                                Image(systemName:"star.fill")
                            }
                            Text("\(getThisTask().getTitle())")
                                .bold()
                                .padding(.trailing, Consts.scrollPadding)
                            if(getConflict()){
                                Text("\(getThisTask().getPriority())")
                                    .foregroundColor(.black)
                                    .padding(.all, Consts.scrollPadding)
                                    .background(getThisTask().getColor())
                                    .cornerRadius(Consts.cornerRadiusField)
                                    .padding(.trailing, Consts.scrollPadding)
                            }
                            Text(getThisTask().getBegin().getFormattedTime() + " to " + getThisTask().getEnd().getFormattedTime())
                            
                        }
                        if(getConflict()){
                            HStack {
                                //Image(systemName: "warning")
                                Text("Warning: this task conflicts with others.")
                                    .font(.caption2)
                                    .foregroundColor(.red)
                            }
                        }
                    }
                    .frame(width:Consts.scrollWidthStrata, height:CGFloat(getThisTask().getDuration())*Consts.widthToMinutes)
                    .foregroundStyle(getConflict() ? Color.red : Color.black)
                    .background(getConflict() ? Color("BodyBackground") : getThisTask().getColor())
                }
            }
        }
    }
}

struct EditTask: View {
    
    @EnvironmentObject var config: Config
    @EnvironmentObject var strata: Strata
    
    @StateObject var details: TaskDetails
    @Binding var editingTask: [[Int]]
    
    @State var stratId: Int
    var taskId: Int
    var newTask: Bool
    
    func edit(){
        if(newTask){
            if(stratId<0){
                stratId = strata.findStrat(begin:details.begin)
            }
            strata.addTasksToStrat(id: stratId, tasks: [Task(priority: Int(details.priority), mandatory: details.mandatory, duration: Int(details.duration) ?? 60, begin: DateTime.convertDateToDT(date: details.begin), color: details.color, title: details.title)])
        } else {
            strata.replaceTaskInStrat(stratId: stratId, taskId:taskId, task: Task(priority: Int(details.priority), mandatory: details.mandatory, duration: Int(details.duration) ?? 60, begin: DateTime.convertDateToDT(date: details.begin), color: details.color, title: details.title))
        }
        strata.getStrata()[stratId].updateRange()
        strata.organize()
        editingTask = []
        
    }
    func delete(){
        if(!newTask){
            strata.getStrata()[stratId].removeTask(id: taskId)
            if(!strata.getStrata()[stratId].getTasks().isEmpty){
                strata.getStrata()[stratId].updateRange()
                strata.organize()
            } else {strata.removeStrat(id:stratId)}
            editingTask = []
        }
    }
    
    var body: some View {
        Group{
            VStack(spacing:0) {
                HStack {
                    Button(action:{editingTask = []}){
                        Image(systemName:"xmark")
                            .imageScale(.large)
                    }
                    Text("\(newTask ? "Add" : "Edit") Task")
                        .font(.title)
                        .bold()

                }
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
                if(!newTask){
                    Button(action:delete){
                        Label("Delete", systemImage:"trash")
                    }
                    .foregroundColor(.red)
                }
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

struct Welcome: View {
    
    @Binding var newbie: Bool
    
    var body: some View {
        VStack {
            Text("Welcome to Stratus!")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .padding()
            Text("Stratus is designed to help with your scheduling needs.")
                .multilineTextAlignment(.center)
                .padding()
            Text("Please tap to see instructions, or continue! Don't forget to give Max feedback.")
                .multilineTextAlignment(.center)
            HStack {
                Link(destination: URL(string: "mailto:maxscholle@westminster.net")!, label: {
                    Text("Instructions")
                })
                Button("Continue"){
                    newbie = false
                }
            }
            .padding()
        }
        .frame(width:300, height:300)
        .background(Color("Header"))
        .cornerRadius(Consts.cornerRadius)
        .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    Home().environmentObject(Config()).environmentObject(Strata())
}
