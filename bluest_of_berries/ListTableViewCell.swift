//
//  ListTableViewCell.swift
//  bluest_of_berries
//
//  Created by Jhonatan Ewunetie on 7/30/19.
//  Copyright © 2019 Serene Saldana. All rights reserved.
//

//function to change image opacity
extension UIImage {

    func alpha(_ value:CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}

import UIKit

class ListTableViewCell: UITableViewCell {
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var deadlineLabel: UILabel!
    @IBOutlet weak var minuteLabel: UILabel!
    @IBOutlet weak var checkboxButton: UIButton!
    @IBOutlet weak var taskTypeLabel: UILabel!

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
            //button.setTitle("☑", for: .normal)
            blueberryWithArrow = blueberryWithArrow!.alpha(0.5)
            button.setBackgroundImage(blueberryWithArrow, for: .normal)
        } else {
            //button.setTitle("☐", for: .normal)
            //blueberryNoArrow.alpha = 0.5
            button.setBackgroundImage(blueberryNoArrow, for: .normal)

        }
    }

    func taskTypeLabelColorChange() -> UIColor {
        switch taskTypeLabel.text {
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

    @IBAction func checkboxButtonPressed(_ sender: UIButton) {
        //if checkboxButton.currentTitle == "☐" {
        if checkboxButton.currentBackgroundImage == UIImage(named: "blueberryNoArrow.png"){

            toggleButtonChange(isComplete: true, button: checkboxButton)
            taskLabel.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25)
            deadlineLabel.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25)
            minuteLabel.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25)
            taskTypeLabel.backgroundColor = UIColor(red: 169/255, green: 169/255, blue: 169/255, alpha: 0.25)
            
            if taskTypeLabel.text == "" {
                taskTypeLabel.backgroundColor = UIColor(red: 234/255, green: 237/255, blue: 247/255, alpha: 0.25)
            } else {
                taskTypeLabel.backgroundColor = UIColor(red: 169/255, green: 169/255, blue: 169/255, alpha: 0.25)
            }
        } else {
            toggleButtonChange(isComplete: false, button: checkboxButton)
            taskLabel.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
            deadlineLabel.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
            minuteLabel.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
            taskTypeLabel.backgroundColor = taskTypeLabelColorChange()
        }
    }


}
