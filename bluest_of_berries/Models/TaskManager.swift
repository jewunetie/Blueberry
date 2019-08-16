//
//  TaskManager.swift
//  BlueberryPrototype
//
//  Created by Jhonatan Ewunetie on 7/19/19.
//  Copyright © 2019 Kai Alexander Bustos. All rights reserved.
//

import UIKit
import CoreData

struct TaskManager {
    var listOfTasks:[Task] = []
    
    var count: Int {
        get {
            return self.listOfTasks.count
        }
    }
    
    init(listofTasks: [Task]) {
        self.listOfTasks = listofTasks
    }
    
    init(listOfTaskObjects: [TaskObject]) {
        for taskObject in listOfTaskObjects {
            let task = Task.init(taskObject: taskObject)
            self.listOfTasks.append(task)
        }
    }
    
    mutating func deleteTasks() {
        for tasks in listOfTasks  {
            tasks.deleteTask()
        }
    }
    
    mutating func addTask(newTask:Task) {
        self.listOfTasks.append(newTask)
    }
    
    mutating func removeTask(atIndex: Int = -1) -> Task? {
        if atIndex == -1 {
            return self.listOfTasks.remove(at: self.count - 1)
        } else if 0 <= atIndex || atIndex < self.count {
            return self.listOfTasks.remove(at: atIndex)
        } else {
            return nil
        }
    }
    
    mutating func removeTask(element: Task) -> Task? {
        var index = 0
        for tasks in listOfTasks {
            if element.isEqual(to: tasks) {
                return self.removeTask(atIndex: index)
            } else {
                index += 1
            }
        }
        return nil
    }
    
    func compareDeadline(task1: Task, task2: Task) -> Bool {
        return Calendar.current.compare(task1.deadline, to: task2.deadline, toGranularity: .day) == .orderedDescending
    }
    
    func comparePriority(task1: Task, task2: Task) -> Bool {
        return task1.priority.rawValue > task2.priority.rawValue
    }
    
    private var prevDate: Date? = nil
    private mutating func splitArray(at: Task) -> Bool {
        if prevDate == nil {
            self.prevDate = at.deadline
            return false
        } else {
            return Calendar.current.compare(at.deadline, to: prevDate!, toGranularity: .day) != .orderedSame
        }
    }
    
    mutating func sort(byDeadline: Bool = true, byPriority: Bool = true) {
        if byDeadline && byPriority {
            self.listOfTasks.sort(by: self.compareDeadline(task1:task2:))
            var currentBuffer: [Task] = []
            var finalList: [Task] = []
            for tasks in listOfTasks {
                if splitArray(at: tasks) {
                    currentBuffer.sort(by: self.comparePriority(task1:task2:))
                    finalList += currentBuffer
                    currentBuffer = []
                } else {
                    currentBuffer.append(tasks)
                }
            }
            
            currentBuffer.sort(by: self.comparePriority(task1:task2:))
            finalList += currentBuffer
            self.listOfTasks = finalList
            prevDate = nil
        } else if byDeadline {
            self.listOfTasks.sort(by: self.compareDeadline(task1:task2:))
        } else if byPriority {
            self.listOfTasks.sort(by: self.comparePriority(task1:task2:))
        }
    }
    
    func sort(byTaskType: TaskType) -> TaskManager {
        
        var taskList: TaskManager = TaskManager.init(listofTasks: [])
        if byTaskType == .Default {
            taskList = self
        } else {
            for tasks in listOfTasks {
                if tasks.taskType == byTaskType {
                    taskList.addTask(newTask: tasks)
                }
            }
        }
        
        
        taskList.sort()
        return taskList
    }
    
    func sort(byMinutes: Int) -> TaskManager {
        if byMinutes == 0 {
            return TaskManager.init(listofTasks: [])
        }
        
        let bestList = sortByMinutesRec(minutes: byMinutes, currentList: [], remainingList: self.listOfTasks)
        
        print("Best List: \(bestList)")
        return TaskManager.init(listofTasks: bestList)
    }
    
    private func sortByMinutesRec(minutes: Int, currentList: [Task], remainingList: [Task]) -> [Task] {
        if minutes <= 0 {
            return currentList
        }
        
        var bestList: [Task] = currentList
        for tasks in remainingList {
            if tasks.minutes <= minutes {
                let newMin = minutes - tasks.minutes
                var newRemainingList = TaskManager.init(listofTasks: remainingList)
                newRemainingList.removeTask(element: tasks)
                var newCurrentList = currentList
                newCurrentList.append(tasks)
                let resultList = sortByMinutesRec(minutes: newMin, currentList: newCurrentList, remainingList: newRemainingList.listOfTasks)
                bestList = bestList.count > resultList.count ? bestList : resultList
            }
        }
        
        return bestList
    }
    
    // DEBUGGING PURPOSES
    func printTasks() {
        print("\n\n=========== START PRINT =============")
        var i = 1
        for tasks in listOfTasks {
            print("\(i): \(tasks.title)\t\(tasks.deadline.description)\t\t\(tasks.minutes.description) Minutes")
            i += 1;
        }
        print("=========== END PRINT ==============\n\n")
    }
    
    
}
