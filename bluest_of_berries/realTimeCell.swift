//
//  realTimeCell.swift
//  bluest_of_berries
//
//  Created by Kevin Alfaro on 7/30/19.
//  Copyright © 2019 Serene Saldana. All rights reserved.
//

import Foundation
import UIKit

// Anytime we add a new UI element to a cell, we must make it custom. Hence why we made this, our label custom class.
// UITablieViewcell is done because it needs to be the parent class 
class realTimeCell: UITableViewCell {
    
    @IBOutlet weak var checkboxButton: UIButton!
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var minuteLabel: UILabel!
    
    //image variables
    var blueberryWithArrow = UIImage(named: "blueberryArrow.png")
    var blueberryNoArrow = UIImage(named: "blueberryNoArrow.png")
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func toggleButtonChange(isComplete: Bool, button: UIButton) {
        if isComplete {
            blueberryWithArrow = blueberryWithArrow!.alpha(0.6)
            button.setBackgroundImage(blueberryWithArrow, for: .normal)
        } else {
            button.setBackgroundImage(blueberryNoArrow, for: .normal)
            
        }
    }
    
    @IBAction func checkboxButtonPressed(_ sender: UIButton) {
        //if checkboxButton.currentTitle == "☐" {
        if checkboxButton.currentBackgroundImage == UIImage(named: "blueberryNoArrow.png"){
            
            toggleButtonChange(isComplete: true, button: checkboxButton)
            taskLabel.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25)
            minuteLabel.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25)
        } else {
            toggleButtonChange(isComplete: false, button: checkboxButton)
            taskLabel.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
            minuteLabel.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }
    
    
}
