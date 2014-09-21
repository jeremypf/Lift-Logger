//
//  ExerciseTableViewCell.swift
//  WorkoutTrackerApp
//
//  Created by Jeremy Francispillai on 2014-06-28.
//  Copyright (c) 2014 Jeremy Francispillai. All rights reserved.
//

import UIKit

class ExerciseTableViewCell: UITableViewCell {

    var increment:Double = 0.0
    
    var lift:Lift
    
    @IBOutlet var liftName: UILabel!

    @IBOutlet var set1: SetButton!
    @IBOutlet var set2: SetButton!
    @IBOutlet var set3: SetButton!
    @IBOutlet var set4: SetButton!
    @IBOutlet var set5: SetButton!
    @IBOutlet var set6: SetButton!
    @IBOutlet var set7: SetButton!
    @IBOutlet var set8: SetButton!
    @IBOutlet var set9: SetButton!
    @IBOutlet var set10: SetButton!
    
    
    @IBOutlet var stepper: UIStepper!
    @IBOutlet var identifier1: UILabel!
    @IBOutlet var identifier2: UILabel!
    @IBOutlet var identifier3: UILabel!
    @IBOutlet var identifier4: UILabel!
    @IBOutlet var identifier5: UILabel!
    @IBOutlet var identifier6: UILabel!
    @IBOutlet var identifier7: UILabel!
    @IBOutlet var identifier8: UILabel!
    @IBOutlet var identifier9: UILabel!
    @IBOutlet var identifier10: UILabel!
    @IBOutlet var weightLabel: UIButton!
    @IBOutlet var weightPicker: UIPickerView!
    @IBOutlet var weightOk: UIButton!
    @IBOutlet var stepperToggle: UIButton!
    
    @IBOutlet var weight1: UILabel!
    @IBOutlet var weight2: UILabel!
    @IBOutlet var weight3: UILabel!
    @IBOutlet var weight4: UILabel!
    @IBOutlet var weight5: UILabel!
    @IBOutlet var weight6: UILabel!
    @IBOutlet var weight7: UILabel!
    @IBOutlet var weight8: UILabel!
    @IBOutlet var weight9: UILabel!
    @IBOutlet var weight10: UILabel!
    

    var textColour: UIColor
    
    var sets:[SetButton] = [SetButton]()
    var identifiers:[UILabel] = [UILabel]()
    var weights:[UILabel] = [UILabel]()
    var lastClicked:SetButton
    var setWeight:Bool
    
    
    @IBAction func clickSet1(sender: AnyObject) {
        clickedSet(set1)
    }
    @IBAction func clickSet2(sender: AnyObject) {
        clickedSet(set2)
    }
    @IBAction func clickSet3(sender: AnyObject) {
        clickedSet(set3)
    }
    @IBAction func clickSet4(sender: AnyObject) {
        clickedSet(set4)
    }
    @IBAction func clickSet5(sender: AnyObject) {
        clickedSet(set5)
    }
    @IBAction func clickSet6(sender: AnyObject) {
        clickedSet(set6)
    }
    @IBAction func clickSet7(sender: AnyObject) {
        clickedSet(set7)
    }
    @IBAction func clickSet8(sender: AnyObject) {
        clickedSet(set8)
    }
    @IBAction func clickSet9(sender: AnyObject) {
        clickedSet(set9)
    }
    @IBAction func clickSet10(sender: AnyObject) {
        clickedSet(set10)
    }
    
    
    
    @IBAction func clickedComplete(sender: AnyObject) {
        for set in sets {
            //set.setTitle(String(lift.reps), forState: .Normal)
            set.setTitle("\(lift.reps)", forState: .Normal)
            completeSet(set)
            set.completedSet = true
            set.reps = lift.reps
            
        }
        updateLastClicked(sets[lift.sets - 1])
        
    }
    
    @IBAction func clickedStepper(sender: AnyObject) {
        
        if !setWeight{
            lastClicked.setTitle(String(Int(stepper.value)), forState: .Normal)
            lastClicked.reps = Int(stepper.value)
            if stepper.value == 0 {
                clearSet(lastClicked)
                lastClicked.completedSet = false
            } else {
            completeSet(lastClicked)
            }
        } else {
            lastClicked.weight = stepper.value
            weights[indexSetsArray(lastClicked)].text = removeZero("\(lastClicked.weight)")
        }
        
    }
    
    @IBAction func clickedWeight(sender: AnyObject) {
        weightPicker.selectRow(Int(lift.weight/increment), inComponent: 0, animated: false)
        weightPicker.hidden = false
        weightOk.hidden = false
        weightLabel.hidden = true
    }

    @IBAction func clickedWeightOk(sender: AnyObject) {
        let previousWeight = lift.weight
        //lift.weight = weightPicker.selectedRowInComponent(0).description as Int
        lift.weight = Double(weightPicker.selectedRowInComponent(0))*increment
        weightLabel.setTitle(removeZero("\(lift.weight)") + " LB", forState: .Normal)
        
        if lift.weight != previousWeight {
            for set in sets {
                set.weight = lift.weight
            }
            
            for weight in weights {
                weight.text = removeZero("\(lastClicked.weight)")
            }
            if setWeight {
                stepper.value = Double(lift.weight/increment)
            }
        }
        
        
        weightPicker.hidden = true
        weightOk.hidden = true
        weightLabel.hidden = false
    }
    
    @IBAction func clickedStepperToggle(sender: AnyObject) {
        setWeight = !setWeight
        
        if setWeight {
            stepper.value = Double(lastClicked.weight)
            stepperToggle.setTitle("Reps", forState: .Normal)
            stepper.stepValue = increment
        } else {
            stepper.value = Double(lastClicked.reps)
            stepperToggle.setTitle("Weight", forState: .Normal)
            stepper.stepValue = 1
        }
    }
    
    
    required init(coder aDecoder: NSCoder) {
        lastClicked = SetButton()
        textColour = lastClicked.currentTitleColor
        lift = Lift(name: "name", sets: 0, reps: 0, weight: 0, increment: 2.5)
        setWeight = false
        increment = 2.5
        super.init(coder: aDecoder)
    }
    
    
    /*override init(style: UITableViewCellStyle, reuseIdentifier: String) {
        lastClicked = set1
        textColour = set1.currentTitleColor
        lift = Lift(name: "name", numSets: 0, numReps: 0, weight: 0, increment: 2.5)
        setWeight = false
        increment = 2.5
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // Initialization code
    }*/

    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        increment = 2.5
        
        sets = [SetButton]()
        sets.append(set1)
        sets.append(set2)
        sets.append(set3)
        sets.append(set4)
        sets.append(set5)
        if set6 != nil{
            sets.append(set6)
            sets.append(set7)
            sets.append(set8)
            sets.append(set9)
            sets.append(set10)
        }
        
        identifiers = [UILabel]()
        identifiers.append(identifier1)
        identifiers.append(identifier2)
        identifiers.append(identifier3)
        identifiers.append(identifier4)
        identifiers.append(identifier5)
        if identifier6 != nil {
            identifiers.append(identifier6)
            identifiers.append(identifier7)
            identifiers.append(identifier8)
            identifiers.append(identifier9)
            identifiers.append(identifier10)
        }
        
        weights = [UILabel]()
        weights.append(weight1)
        weights.append(weight2)
        weights.append(weight3)
        weights.append(weight4)
        weights.append(weight5)
        if weight6 != nil {
            weights.append(weight6)
            weights.append(weight7)
            weights.append(weight8)
            weights.append(weight9)
            weights.append(weight10)
        }
        
        
        textColour = set1.currentTitleColor
        lastClicked = set1
        setWeight = false
        //weightPicker.selectRow(lift.weight/5, inComponent: 0, animated: false)
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //if the set has been done, even if its not fully completed
    func completeSet(button :SetButton){
        
        if button.titleForState(.Normal)?.toInt() < lift.reps{
            button.setBackgroundImage(UIImage(named: "buttonImage2.png"), forState: .Normal)
            button.setTitleColor(UIColor.blueColor(), forState: .Normal)
        } else {
            button.setBackgroundImage(nil, forState: .Normal)
            button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        }
        button.completedSet = true
        
    }
    
    func clearSet (button :SetButton){
        button.setBackgroundImage(UIImage(named: "buttonImage1.png"), forState: .Normal)
        button.setTitleColor(textColour, forState: .Normal)
        lastClicked.setTitle(String(lift.reps), forState: .Normal)
        button.reps = 0
        button.completedSet = false
    }

    func clickedSet(button :SetButton){
        if button.completedSet && lastClicked == button{
            clearSet(button)
        } else if !button.completedSet {
            completeSet(button)
            button.reps = lift.reps
        }
        
        updateLastClicked(button)
    }
    
    func indexSetsArray(button:SetButton)->Int {
        for var i=0;i<lift.sets;i++ {
            if sets[i] == button {
                return i
            }
        }
        return -1
    }
    
    func updateLastClicked(button:SetButton){
        identifiers[indexSetsArray(lastClicked)].hidden = true
        identifiers[indexSetsArray(button)].hidden = false
        lastClicked = button
        if setWeight {
            stepper.value = lastClicked.weight
        } else {
            stepper.value = Double(button.reps)
        }
    }
    
    func removeZero(num:String)->String{
        var text:String = num
        if text.hasSuffix(".0") {
            text = text.substringToIndex(advance(text.startIndex, countElements(text)-2))
        }
        return text
    }
}
