//
//  Lift.swift
//  WorkoutTrackerApp
//
//  Created by Jeremy Francispillai on 2014-07-06.
//  Copyright (c) 2014 Jeremy Francispillai. All rights reserved.
//

import Foundation

class Lift {
    var name:String
    var sets:Int
    var reps:Int
    var weight:Double
    var increment:Double
    
    
    init(name:String, sets:Int, reps:Int, weight: Double, increment:Double){
        self.name = name
        self.sets = sets
        self.reps = reps
        self.weight = weight
        self.increment = increment
    }
    
    func getWeight()->String{
        var text:String = "\(weight)"
        if text.hasSuffix(".0") {
            text = text.substringToIndex(advance(text.startIndex, countElements(text)-2))
        }
        return text
    }
    
    /*func removeZero(num:String)->String{
    var text:String = num
    if text.hasSuffix(".0") {
    text = text.substringToIndex(advance(text.startIndex, countElements(text)-2))
    }
    return text
    }*/
}