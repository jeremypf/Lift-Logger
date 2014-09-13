//
//  Workout.swift
//  WorkoutLogApp
//
//  Created by Jeremy Francispillai on 2014-08-19.
//  Copyright (c) 2014 Jeremy Francispillai. All rights reserved.
//

import Foundation

class Workout {
    var name:String
    var days = [Day]()
    
    init(name:String){
        self.name = name
    }
}