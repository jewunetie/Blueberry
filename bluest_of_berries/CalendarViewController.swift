//
//  CalendarViewController.swift
//  bluest_of_berries
//
//  Created by Kai Alexander Bustos on 8/1/19.
//  Copyright © 2019 Serene Saldana. All rights reserved.
//

import UIKit
import CalendarSwift

class CalendarViewController: UIViewController, UIPopoverControllerDelegate, CalendarViewDelegate {
    
    //Mark: Properties
   
    var currentDate: Date? = nil
    var dateAsString: String = ""
    var dateSplit: Substring = ""
    let addTaskvc = addTaskViewController()

    @IBOutlet weak var calendarPopView: CalendarView!
    @IBOutlet weak var selectDateButton: UIButton!
    
    //Mark: Protocol
    func calendarDateChanged(date: Date) {
        currentDate = date
        dateAsString = currentDate!.description
        
        let endOfDateIndex = dateAsString.index(dateAsString.endIndex, offsetBy: -14)
        dateSplit = dateAsString[..<endOfDateIndex]
    }
    
    //Mark: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        self.calendarPopView.setupCalendar()
        calendarPopView.delegate = self
        setUpCalendar()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "addTaskSegue"{
             let addTaskvc: addTaskViewController = segue.destination as! addTaskViewController
             addTaskvc.pickDateButtonLabel = String(dateSplit)
            addTaskvc.getCurrentDate = currentDate
        }
    }
 
    
    //Mark: Setup
    
    func setUpCalendar(){
        self.calendarPopView.style.language = "en"
        self.calendarPopView.setupCalendar()
        self.calendarPopView.selectedYearDelay = 0.3
        self.calendarPopView.setupCalendar()
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    

}
