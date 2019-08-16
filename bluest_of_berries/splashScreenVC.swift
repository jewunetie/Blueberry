//
//  splashScreen.swift
//  bluest_of_berries
//
//  Created by Serene Saldana on 7/31/19.
//  Copyright © 2019 Serene Saldana. All rights reserved.
//

import UIKit

class splashScreenVC: UIViewController {
    
    
    @IBOutlet weak var listButtonPressed: UIButton!
    @IBOutlet weak var homeButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeButton.layer.cornerRadius = 8
        listButtonPressed.layer.cornerRadius = 8
    }
    
    //these 2 methods hide nav bar on splash and reopen on other pages
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
