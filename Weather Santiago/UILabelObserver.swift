//
//  UILabelObserver.swift
//  Weather Santiago
//
//  Created by Jeffrey Hotz on 2019-10-28.
//  Copyright © 2019 Jacob Hotz. All rights reserved.
//

import UIKit

class UILabelObserver: UILabel, Observer {
    
    static private var nextId = 0
    
    var id: Int
    
    required init?(coder aDecoder: NSCoder) {
        self.id = UILabelObserver.nextId
        UILabelObserver.nextId += 1
        super.init(coder: aDecoder)
    }
    
    func update() {
        print("hey")
    }
    

}
