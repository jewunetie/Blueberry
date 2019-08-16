//
//  AppDelegate.swift
//  TestBloopBerry
//
//  Created by Jhonatan Ewunetie on 7/25/19.
//  Copyright © 2019 Jhonatan Ewunetie. All rights reserved.
//

import UIKit
import CoreData
import DropDown

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TaskModel")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistenet stores: \(error)")
            }
        }
        return container
    }()
    
    lazy var taskManager: TaskManager = TaskManager.init(listofTasks: [])
    lazy var secondTaskManager: TaskManager = TaskManager.init(listofTasks: [
        Task.init(title: "Call Mom", deadline: Date.init(), minutes: 5, priority: .none, type: .Relax, isComplete: false),
        Task.init(title: "Reply to Satya's email", deadline: Date.init(), minutes: 6, priority: .one, type: .Focus, isComplete: false),
        Task.init(title: "Fill out TNT survey", deadline: Date.init(), minutes: 3, priority: .one, type: .Relax, isComplete: false),
        Task.init(title: "Post the Seattle pictures on Instagram", deadline: Date.init(), minutes: 2, priority: .two, type: .Relax, isComplete: false),
        Task.init(title: "Finish script for science fair", deadline: Date.init(), minutes: 10, priority: .two, type: .Focus, isComplete: false),
        Task.init(title: "Do 100 pushups and sit-ups", deadline: Date.init(), minutes: 10, priority: .two, type: .Energize, isComplete: false)
        ].shuffled()
    )
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        taskManager = TaskManager.init(listOfTaskObjects: {
            let itemsFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskObject")
            let requestResults = try! persistentContainer.viewContext.fetch(itemsFetchRequest) as! [TaskObject]
            return requestResults
        }()
        )
        
        DropDown.startListeningToKeyboard()
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        try! persistentContainer.viewContext.save()
    }
    
    
}

