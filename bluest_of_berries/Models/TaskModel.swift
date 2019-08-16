//
//  TaskModel.swift
//  TestBloopBerry
//
//  Created by Jhonatan Ewunetie on 7/29/19.
//  Copyright © 2019 Jhonatan Ewunetie. All rights reserved.
//

import Foundation
import UIKit
import CoreData

enum Priority: Int16 {
    case none = 0
    case one = 1
    case two = 2
    case three = 3
}

enum TaskType: Int16 {
    case Default = 0
    case Relax = 1
    case Focus = 2
    case Energize = 3
}

struct Task {
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var container: NSPersistentContainer!
    
    var task: TaskObject
    
    var title: String {
        get {
            return task.title!
        }
        set {
            task.title = newValue
        }
    }
    
    var deadline: Date {
        get {
            return task.deadline!
        }
        set {
            task.deadline = newValue
        }
    }
    
    var minutes: Int {
        get {
            return Int(task.minutes)
        }
        set {
            task.minutes = Int16(newValue)
        }
    }
    
    var isComplete: Bool {
        get {
            return task.isComplete
        }
        set {
            task.isComplete = newValue
        }
    }
    
    var priority: Priority {
        get {
            return Priority(rawValue: task.priorityInt)!
        }
        set {
            task.priorityInt = newValue.rawValue
        }
    }
    
    var taskType: TaskType {
        get {
            return TaskType(rawValue: task.taskTypeInt)!
        }
        set {
            task.taskTypeInt = newValue.rawValue
        }
    }
    
    private let dateFormatter = DateFormatter()
    
    init (title: String = "Default Task", deadline: Date = Date.init(), minutes: Int16 = 0, priority: Priority = .none, type: TaskType = .Default, isComplete: Bool = false) {
        container = appDelegate.persistentContainer
        guard container != nil else {
            fatalError("This view needs a persistent container")
        }
        
        task = NSEntityDescription.insertNewObject(forEntityName: "TaskObject", into: container.viewContext) as! TaskObject
        task.title = title
        task.deadline = deadline
        task.minutes = minutes
        
        task.priorityInt = priority.rawValue
        task.taskTypeInt = type.rawValue
        
        task.isComplete = isComplete
        
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "en_US")
    }
    
    init (taskObject: TaskObject) {
        task = taskObject
    }
    
    func deleteTask() {
        container.viewContext.delete(task)
    }
    
    
    func dateToStr() -> String {
        return dateFormatter.string(from: task.deadline!)
    }
    
    func priorityToStr() -> String {
        switch priority {
        case .one:
            return "!"
        case .two:
            return "!!"
        case .three:
            return "!!!"
        default:
            return ""
        }
    }
    
    mutating func strToPriority(str: String) {
        switch str {
        case "Important!":
            self.priority = .one
        case "Urgent!!":
            self.priority = .two
        case "ASAP!!!":
            priority = .three
        default:
            priority = .none
        }
    }
    
    func typeToStr() -> String {
        switch taskType {
        case .Relax:
            return "Relax"
        case .Focus:
            return "Focus"
        case .Energize:
            return "Energize"
        default:
            return ""
        }
    }
    
    mutating func strToType(str: String) {
        switch str {
        case "Relax":
            self.taskType = .Relax
        case "Focus":
            self.taskType = .Focus
        case "Energize":
            self.taskType = .Energize
        default:
            self.taskType = .Default
        }
    }
    
    func typeToColor() -> UIColor {
        switch taskType {
        case .Relax:
            return UIColor(red: 164/255, green: 217/255, blue: 133/255, alpha: 1.0)
        case .Focus:
            return UIColor(red: 120/255, green: 181/255, blue: 217/255, alpha: 1.0)
        case .Energize:
            return UIColor(red: 217/255, green: 164/255, blue: 165/255, alpha: 1.0)
        default:
            return UIColor(white: 1, alpha: 1)
        }
    }
    
    func isEqual(to: Task) -> Bool {
        if (self.title != to.title ||
            Calendar.current.compare(self.deadline, to: to.deadline, toGranularity: .day) != .orderedSame ||
            self.priority != to.priority ||
            self.taskType != to.taskType) {
            return false
        }
        return true
    }
    
    func isEqual(_ first: Task, _ second: Task) -> Bool {
        return first.isEqual(to: second)
    }
}
