//
//  ViewControllerWeekly.swift
//  Weather Santiago
//
//  Created by Jeffrey Hotz on 2019-10-28.
//  Copyright © 2019 Jacob Hotz. All rights reserved.
//

import UIKit

class ViewControllerWeekly: UIViewController {

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
    @IBAction func unwindToCurrentForecast(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
