//
//  NewExerciseViewController.swift
//  WorkoutTrackerApp
//
//  Created by Jeremy Francispillai on 2014-08-09.
//  Copyright (c) 2014 Jeremy Francispillai. All rights reserved.
//

import UIKit

class NewExerciseViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var picker: UIPickerView!
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var weight: UITextField!
    @IBOutlet weak var increment: UITextField!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var deleteButton: UIButton!
    
    
    
    var lift:Lift?
    var tableRow:Int = -1//the row in the lifts table if a lift is being updated... -1 if new
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if tableRow == -1 {
            picker.selectRow(4, inComponent: 0, animated: false)
            picker.selectRow(4, inComponent: 1, animated: false)
            deleteButton.hidden = true
        }
        else {//if editing am existing day
            name.text = lift!.name
            weight.text = removeZero("\(lift!.weight)")
            increment.text = removeZero("\(lift!.increment)")
            picker.selectRow(lift!.sets, inComponent: 0, animated: false)
            picker.selectRow(lift!.reps, inComponent: 1, animated: false)
            
            addButton.title = "Update"
        }
        
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        
        if sender as? UIButton == deleteButton {
            lift = nil
        }
        else {
        
            let weightString:NSString = weight.text as NSString
            let incString:NSString = increment.text as NSString
            
            //println(picker.selectedRowInComponent(1)+1)
    
            lift = Lift(name: name.text, sets: picker.selectedRowInComponent(0)+1, reps: picker.selectedRowInComponent(1)+1, weight: weightString.doubleValue, increment: incString.doubleValue)
        }
    }
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView!) -> Int{
        return 2
    }
    
    func pickerView(pickerView: UIPickerView!, numberOfRowsInComponent component: Int) -> Int{
        if component == 0 {
            return 10
        }
        else {
            return 100
        }
    }
    
    func pickerView(pickerView: UIPickerView!, titleForRow row: Int, forComponent component: Int) -> String!{
        return String(row + 1)
        
    }
    
    
    
    func removeZero(num:String)->String{
        var text:String = num
        if text.hasSuffix(".0") {
            text = text.substringToIndex(advance(text.startIndex, countElements(text)-2))
        }
        return text
    }
    
}
