//
//  ListPageTableViewController.swift
//  bluest_of_berries
//
//  Created by Jhonatan Ewunetie on 7/30/19.
//  Copyright © 2019 Serene Saldana. All rights reserved.
//

import UIKit
import CoreData
import DropDown

var defaultTask = Task.init()
class ListPageTableViewController: UITableViewController {
    
    private var addTaskButton: UIButton?
    private let addTaskButtonImageName = "addTaskButton"
    private static let buttonHeight: CGFloat = 75.0
    private static let buttonWidth: CGFloat = 75.0
    private let roundValue = ListPageTableViewController.buttonHeight/2
    private let trailingValue: CGFloat = 15.0
    private let leadingValue: CGFloat = 15.0
    private let shadowRadius: CGFloat = 2.0
    private let shadowOpacity: Float = 0.5
    private let shadowOffset = CGSize(width: 0.0, height: 5.0)
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        createFloatingButton()
        //taskList = appDelegate.taskManager
        taskList = appDelegate.secondTaskManager
        taskList.sort()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        guard addTaskButton?.superview != nil else {  return }
        DispatchQueue.main.async {
            self.addTaskButton?.removeFromSuperview()
            self.addTaskButton = nil
        }
        super.viewWillDisappear(animated)
    }
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var taskList: TaskManager = TaskManager.init(listofTasks: [])
    
    @IBOutlet var listTableView: UITableView!
    @IBOutlet weak var sortButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        appDelegate.taskManager = taskList
    }
    
    private func createFloatingButton() {
        addTaskButton = UIButton(type: .custom)
        addTaskButton?.translatesAutoresizingMaskIntoConstraints = false
        addTaskButton?.backgroundColor = UIColor(white: 1, alpha: 0)
        addTaskButton?.setImage(UIImage(named: addTaskButtonImageName), for: .normal)
        addTaskButton?.addTarget(self, action: #selector(addTaskButtonPressed(_:)), for: .touchUpInside)
        constrainFloatingButtonToWindow()
        makeFloatingButtonRound()
        addShadowToFloatingButton()
    }
    
    private func constrainFloatingButtonToWindow() {
        DispatchQueue.main.async {
            guard let keyWindow = UIApplication.shared.keyWindow,
                let floatingButton = self.addTaskButton else { return }
            keyWindow.addSubview(floatingButton)
            keyWindow.trailingAnchor.constraint(equalTo: floatingButton.trailingAnchor, constant: self.trailingValue).isActive = true
            keyWindow.bottomAnchor.constraint(equalTo: floatingButton.bottomAnchor, constant: self.leadingValue).isActive = true
            floatingButton.widthAnchor.constraint(equalToConstant: ListPageTableViewController.buttonWidth).isActive = true
            floatingButton.heightAnchor.constraint(equalToConstant: ListPageTableViewController.buttonHeight).isActive = true
        }
    }
    
    private func makeFloatingButtonRound() {
        addTaskButton?.layer.cornerRadius = roundValue
    }
    
    private func addShadowToFloatingButton() {
        addTaskButton?.layer.shadowColor = UIColor.black.cgColor
        addTaskButton?.layer.shadowOffset = shadowOffset
        addTaskButton?.layer.masksToBounds = false
        addTaskButton?.layer.shadowRadius = shadowRadius
        addTaskButton?.layer.shadowOpacity = shadowOpacity
    }
    
    // TODO: Add some logic for when the button is tapped.
    @IBAction private func addTaskButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "AddTaskID", sender: self)
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = listTableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! ListTableViewCell
        let item = taskList.listOfTasks[indexPath.row]
        cell.taskLabel.text = item.title + item.priorityToStr()
        cell.deadlineLabel.text = item.dateToStr()
        cell.minuteLabel.text = "🕒 " + item.minutes.description + " Min"
        
        //when initialized
        if item.isComplete {
            cell.checkboxButton.setBackgroundImage(UIImage(named: "blueberryNoArrow.png"), for: .normal)
            
        } else {
            cell.checkboxButton.setBackgroundImage(UIImage(named: "blueberryArrow.png"), for: .normal)

        }
        
        cell.taskTypeLabel.text = item.typeToStr()
        cell.taskTypeLabel.backgroundColor = item.typeToColor()
        cell.taskTypeLabel.textColor = UIColor(white: 1, alpha: 1.0)
        
        cell.taskTypeLabel.layer.masksToBounds = true
        cell.taskTypeLabel.layer.cornerRadius = 10
        cell.checkboxButtonPressed(cell.checkboxButton)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    var taskToEdit: Task = Task.init()
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: .normal, title: "Edit", handler: { (action, indexPath) in
            self.taskToEdit = self.taskList.removeTask(atIndex: indexPath.row)!
            self.performSegue(withIdentifier: "AddTaskID", sender: self)
        })
        editAction.backgroundColor = UIColor.blue
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete", handler: { (action, indexPath) in
            self.taskList.removeTask(atIndex: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        })
        
        return [deleteAction, editAction]
    }
    
    
    let sortDropDown = DropDown()
    let sortList: [String] = ["Default", "Deadline", "Priority"]
    @IBAction func sortButtonPressed(_ sender: Any) {
        sortDropDown.anchorView = sortButton
        //sortDropDown.bottomOffset = CGPoint(x: 0, y: sortDropDown.bounds.height)
        sortDropDown.layer.cornerRadius = 8
        sortDropDown.dataSource = sortList
        sortDropDown.show()
        sortDropDown.selectionAction = { (index: Int, item: String) in
            self.sortButton.title = item == "Default" ? "Sort" : "Sort By: " + item
            switch item {
            case "Deadline":
                self.taskList.sort(byDeadline: true, byPriority: false)
            case "Priority":
                self.taskList.sort(byDeadline: false, byPriority: true)
            default:
                self.taskList.sort()
            }
        }
    }
    
    /** Action Handler for button **/
    
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddTaskID" {
            let addTaskController = segue.destination as! addTaskViewController
            //addTaskViewController.task = taskToEdit
        }
    }
}
