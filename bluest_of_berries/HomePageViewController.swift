//
//  HomePageViewController.swift
//  bluest_of_berries
//
//  Created by Quan Huie on 7/26/19.
//  Copyright © 2019 Serene Saldana. All rights reserved.
//

import UIKit


class HomePageViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    var taskGoal:TaskType = TaskType.Default
    var timeValue:Int = 0


    //MARK: Outlets
    @IBOutlet weak var defaultRoundedButton: UIButton!
    @IBOutlet weak var relaxRoundedButton: UIButton!
    @IBOutlet weak var focusRoundedButton: UIButton!
    @IBOutlet weak var energizeRoundedButton: UIButton!
    @IBOutlet weak var submitRoundedButton: UIButton!
    @IBOutlet weak var timePicker: UIPickerView!

    //MARK: Actions
    @IBAction func relaxButtonPressed(_ sender: Any) {
        //set pressed button opacity to 0.3
        relaxRoundedButton.layer.opacity = 0.3

        //make sure other buttons are fully highlighted once button is clicked
        focusRoundedButton.layer.opacity = 1.0
        energizeRoundedButton.layer.opacity = 1.0
        defaultRoundedButton.layer.opacity = 1.0

        //set taskGoal
        taskGoal = TaskType.Relax
    }

    @IBAction func focusButtonPressed(_ sender: Any) {
        focusRoundedButton.layer.opacity = 0.3

        relaxRoundedButton.layer.opacity = 1.0
        energizeRoundedButton.layer.opacity = 1.0
        defaultRoundedButton.layer.opacity = 1.0

        taskGoal = TaskType.Focus

    }

    @IBAction func energizeButtonPressed(_ sender: Any) {
        energizeRoundedButton.layer.opacity = 0.3

        relaxRoundedButton.layer.opacity = 1.0
        focusRoundedButton.layer.opacity = 1.0
        defaultRoundedButton.layer.opacity = 1.0
        taskGoal = TaskType.Energize

    }


    @IBAction func defaultButtonPressed(_ sender: Any) {
        defaultRoundedButton.layer.opacity = 0.3

        relaxRoundedButton.layer.opacity = 1.0
        focusRoundedButton.layer.opacity = 1.0
        energizeRoundedButton.layer.opacity = 1.0
        taskGoal = TaskType.Energize
    }



    var timePickerData:[String] = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        relaxRoundedButton.layer.cornerRadius = 8
        focusRoundedButton.layer.cornerRadius = 8
        energizeRoundedButton.layer.cornerRadius = 8
        submitRoundedButton.layer.cornerRadius = 8
        defaultRoundedButton.layer.cornerRadius = 8
        //set default button opacity to 0.3 to show default selection
        defaultRoundedButton.layer.opacity = 0.3

        // Do any additional setup after loading the view.

        self.timePicker.delegate = self
        self.timePicker.dataSource = self

        //input the data into the array
        timePickerData = ["5", "10", "15", "20", "25", "30", "35", "40", "45", "50", "55", "60"]
        timeValue = Int(timePickerData[0])!

    }

    // Number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    //number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return timePickerData.count
    }

    //get data at row
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return timePickerData[row]
    }

    //detect which item was chosen
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        timeValue = Int(timePickerData[row])!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RealTimeViewID" {
            let timerController = segue.destination as! RealTimeViewController
            timerController.minutes = timeValue
            timerController.taskType = taskGoal
        }
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
