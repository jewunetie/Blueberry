//
//  addTaskViewController.swift
//  bluest_of_berries
//
//  Created by Kai Alexander Bustos on 7/25/19.
//  Copyright © 2019 Serene Saldana. All rights reserved.
//

import UIKit
import DropDown
import CalendarSwift

class addTaskViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    //Mark: Properties
    var getCurrentDate: Date? = nil
    var userBloopType: TaskType = .Default
    var userEstTime: String = ""
    var pickDateButtonLabel : String = "Pick a date"
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var bloopDescriptionLabel: UILabel!
    @IBOutlet weak var bloopDescriptionTextField: UITextField!
    
    @IBOutlet weak var bloopTypeLabel: UILabel!
    @IBOutlet weak var bloopTypeDDButton: UIButton!
    
    @IBOutlet weak var estTimeLabel: UILabel!
    @IBOutlet weak var estTimeDDButton: UIButton!
    
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var pickDateButton: UIButton!
    
    @IBOutlet weak var priorityLevelLabel: UILabel!
    @IBOutlet weak var prioritySelectionControl: UISegmentedControl!
    
    @IBOutlet weak var addToListButton: UIButton!
    
    let typeList: [String] = ["Default", "Relax", "Focus", "Energize"]
    let timeList: [String] = ["5 minutes", "10 minutes", "15 minutes", "20 minutes", "25 minutes", "30 minutes", "35 minutes", "45 minutes", "50 minutes", "55 minutes", "60 minutes"]
    
    let bloopDescriptionField = UITextView()
    
    //Mark: DropDowns and Calendar properties
    let bloopTypeDD = DropDown()
    let estTimeDD = DropDown()
    
    lazy var dd : [DropDown] = {
        return [self.bloopTypeDD, self.estTimeDD]
    }()
    
    //Mark: Actions
    @IBAction func bloopTypeDD(_ sender: AnyObject) {
        bloopTypeDD.show()
    }
    
    @IBAction func estTimeDD(_ sender: Any) {
        estTimeDD.show()
    }
    
    
    @IBAction func pickDateButtonPressed(_ sender: Any) {
        
    }
    
    
    //Mark: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpbloopTypeDD()
        setUpestTimeDD()
        roundEdges()
        
        self.pickDateButton.setTitle(pickDateButtonLabel, for: .normal)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "calendarSegue" {
            let calendarvc: CalendarViewController = segue.destination as! CalendarViewController
            calendarvc.popoverPresentationController?.backgroundColor = UIColor.darkGray
            calendarvc.popoverPresentationController!.delegate = self
            
            let calendarpopViewController = calendarvc.popoverPresentationController
            calendarpopViewController?.permittedArrowDirections = .any
            calendarpopViewController?.delegate = self
            calendarpopViewController?.sourceView = pickDateButton
            calendarpopViewController?.sourceRect = pickDateButton.bounds
        }
    }
    
    //Mark: Popup Properties
    
    func adaptivePresentationStyle(for controller:
        UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    func presentationController(_ controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
        return UINavigationController(rootViewController: controller.presentedViewController)
    }
    
    //Mark: Setup
    
    func setUpbloopTypeDD(){
        bloopTypeDD.anchorView = bloopTypeDDButton
        bloopTypeDD.bottomOffset = CGPoint(x: 0, y: bloopTypeDD.bounds.height)
        bloopTypeDD.layer.cornerRadius = 8
        bloopTypeDD.dataSource = typeList
        
        bloopTypeDD.selectionAction = { [weak self] (index, item) in
            self?.bloopTypeDDButton.setTitle(item, for: .normal)
            switch item {
            case "Relax":
                self!.userBloopType = .Relax
            case "Focus":
                self!.userBloopType = .Focus
            case "Energize":
                self!.userBloopType = .Energize
            default:
                self!.userBloopType = .Default
            }
        }
        
    }
    
    func setUpestTimeDD(){
        estTimeDD.anchorView = estTimeDDButton
        estTimeDD.direction = .bottom
        estTimeDD.bottomOffset = CGPoint(x: 0, y: estTimeDD.bounds.height)
        estTimeDD.layer.cornerRadius = 8
        estTimeDD.dataSource = timeList
        estTimeDD.selectionAction = { [weak self] (index, item) in
            self?.estTimeDDButton.setTitle(item, for: .normal)
            
            self?.userEstTime = item
        }
    }
    
    func roundEdges(){
        bloopTypeDDButton.layer.cornerRadius = 8
        pickDateButton.layer.cornerRadius = 8
        estTimeDDButton.layer.cornerRadius = 8
        addToListButton.layer.cornerRadius = 8
        DropDown.appearance().cornerRadius = 8
    }
    
    func printUserSelections(){
        print(userBloopType)
        print(userEstTime)
    }
    
    func setBloopTypeColor(items: String){
        switch items{
        case "Default":
            self.estTimeDDButton.backgroundColor = UIColor.white
        case "Relax":
           self.estTimeDDButton.backgroundColor = UIColor(red: 164/255, green: 217/255, blue: 133/255, alpha: 1.0)
        case "Focus":
            self.estTimeDDButton.backgroundColor = UIColor(red: 164/255, green: 217/255, blue: 133/255, alpha: 1.0)
        case "Energize":
            self.estTimeDDButton.backgroundColor = UIColor(red: 164/255, green: 217/255, blue: 133/255, alpha: 1.0)
        default:
            self.estTimeDDButton.backgroundColor = UIColor.white
        }
    }
    
    var level: Priority = .none;
    @IBAction func segmentedOnChange(_ sender: UISegmentedControl) {
        if (sender.selectedSegmentIndex == 0) {
            level = .none;
        } else if (sender.selectedSegmentIndex == 1) {
            level = .one;
        } else if (sender.selectedSegmentIndex == 2) {
            level = .two;
        } else {
            level = .three
        }
        
    }
    
    
    
    
    
    @IBAction func addToList(_ sender: Any) {
        var arr = userEstTime.split(separator: " ")
        let strMin = arr[0]
        let minutes = Int16(strMin)!
        
        if getCurrentDate == nil {
            getCurrentDate = Date.init()
        }
        
        let task = Task(title: bloopDescriptionTextField.text!, deadline: getCurrentDate!, minutes: minutes, priority: level, type: userBloopType, isComplete: false)
        appDelegate.taskManager.addTask(newTask: task)
    }
    
}
