//
//  ViewController.swift
//  Weather Santiago
//
//  Created by Jacob Hotz on 2019-09-25.
//  Copyright © 2019 Jacob Hotz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var toggleMode: UIButton!
    
    
    @IBAction func changeMode(_ sender: UIButton) {
        
        // Change title to be that of now not-in-use mode
        if (sender.currentTitle == "Weekly") {
            sender.setTitle("Daily", for: .normal)
        } else {
            sender.setTitle("Weekly", for: .normal)
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }


}

