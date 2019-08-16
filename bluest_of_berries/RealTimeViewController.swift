//
//  RealTimeViewController.swift
//  bluest_of_berries
//
//  Created by Kevin Alfaro on 7/30/19.
//  Copyright © 2019 Serene Saldana. All rights reserved.
//
import Foundation
import UIKit
import DropDown

class RealTimeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var StartPauseButton: UIButton!
    @IBOutlet weak var ResetButton: UIButton!
    @IBOutlet weak var bloopTypeContainer: UIButton!
    @IBOutlet weak var bloopTableView: UITableView!
    
    
// Outlets
//---------------------------------------------------------------------------------------------------//
    
    var todo = TaskManager(listofTasks: [
        Task(title: "Call Mom", deadline: Date(timeIntervalSince1970: 10), minutes: 10, priority: .three , type: .Relax , isComplete: true),
        Task(title: "Walk Dog", deadline: Date(timeIntervalSince1970: 10), minutes: 10, priority: .three , type: .Relax , isComplete: true)
        ])
    
    var bloopType: [String] = ["Default", "Relax", "Focus", "Energize"]
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var taskList: TaskManager = TaskManager.init(listofTasks: [])
    var taskType: TaskType = .Default
    override func viewDidLoad() {
        super.viewDidLoad()
        time.minutes = minutes
        lbl.text = time.timeString()
        setUpbloopTypeDD()
        taskList = appDelegate.secondTaskManager
        createTableList()
        StartPauseButton.layer.cornerRadius = 8
        ResetButton.layer.cornerRadius = 8
    }
    
    func createTableList() {
        todo = taskList.sort(byTaskType: taskType)
        todo = todo.sort(byMinutes: time.minutes)
    }
    
    
    //Declare as lazy variable, no reason for compiler to generate one unless we explicitly click it
    let bloopTypeDD = DropDown()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todo.listOfTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as! realTimeCell
        let item = todo.listOfTasks[indexPath.row]
        cell.taskLabel.text = item.title
        if item.isComplete {
            cell.checkboxButton.setBackgroundImage(UIImage(named: "blueberryNoArrow.png"), for: .normal)
        } else {
            cell.checkboxButton.setBackgroundImage(UIImage(named: "blueberryArrow.png"), for: .normal)
        }
        
        cell.minuteLabel.text = "🕒 " + item.minutes.description + " Min"
        cell.backgroundColor = item.typeToColor()
        bloopTypeContainer.layer.cornerRadius = 10
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func setUpbloopTypeDD() {
        bloopTypeDD.anchorView = bloopTypeContainer
        bloopTypeDD.bottomOffset = CGPoint(x: 0, y: bloopTypeDD.bounds.height)
        bloopTypeDD.layer.cornerRadius = 8
        bloopTypeDD.dataSource = bloopType
    }
    
    @IBAction func bloopTypeButton(_ sender: Any) {
        bloopTypeDD.show()
        bloopTypeDD.selectionAction = { [weak self] (index, item) in
            self?.bloopTypeContainer.setTitle(item, for: .normal)
            self?.bloopTypeContainer.backgroundColor = self!.taskTypeLabelColorChange(type: item)
            let taskType = self!.strToType(str: item)
            self!.taskType = taskType
            self!.createTableList()
            self!.bloopTableView.reloadData()
        }
    }
    
    func strToType(str: String) -> TaskType{
        switch str {
        case "Relax":
            return .Relax
        case "Focus":
            return .Focus
        case "Energize":
            return .Energize
        default:
            return .Default
        }
    }
    
    func taskTypeLabelColorChange(type: String) -> UIColor {
        switch type {
        case "Relax":
            return UIColor(red: 164/255, green: 217/255, blue: 133/255, alpha: 1.0)
        case "Focus":
            return UIColor(red: 120/255, green: 181/255, blue: 217/255, alpha: 1.0)
        case "Energize":
            return UIColor(red: 217/255, green: 164/255, blue: 165/255, alpha: 1.0)
        default:
            return UIColor(red: 234/255, green: 237/255, blue: 247/255, alpha: 1.0)
        }
    }
    
    // Using our taskManager/taskModel models here, filling in our cells.
    //---------------------------------------------------------------------------------------------------//
    
    
    // TIMER FUNCTIONALITY - Utilizing Time Struct Here
    //---------------------------------------------------------------------------------------------------//
    var minutes: Int = 0
    var time: Time = Time.init()
    var timer: Timer = Timer.init()
    
    func countdown() {
        time.changeSeconds(-1)
        lbl.text = time.timeString()
    }
    
    func timerCount() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {_ in self.countdown()})
    }
    
   @IBAction func pressedStartStopButton(_ sender: Any) {
        if StartPauseButton.currentTitle == "PAUSE" {
            StartPauseButton.setTitle("START", for: .normal)
            timer.invalidate()
        } else {
            StartPauseButton.setTitle("PAUSE", for: .normal)
            timerCount()
        }
    }
    
    @IBAction func resetButtonPressed(_ sender: Any) {
        timer.invalidate()
        StartPauseButton.setTitle("START", for: .normal)
        time.minutes = minutes
        lbl.text = time.timeString()
    }

}
