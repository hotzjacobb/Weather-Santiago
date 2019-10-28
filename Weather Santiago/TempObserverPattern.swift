//
//  TempObserverPattern.swift
//  Weather Santiago
//
//  Created by Jeffrey Hotz on 2019-10-28.
//  Copyright © 2019 Jacob Hotz. All rights reserved.
//

import Foundation

protocol Observer {
    var id : Int{ get }
    func update()
}

protocol Observable {
    var observers : [Observer] { get set }
    func addObserver(_ observer: Observer)
    func notifyObservers(_ observers: [Observer])
}
