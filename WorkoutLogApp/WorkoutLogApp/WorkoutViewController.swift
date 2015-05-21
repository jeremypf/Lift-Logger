//
//  WorkoutViewController.swift
//  WorkoutTrackerApp
//
//  Created by Jeremy Francispillai on 2014-06-17.
//  Copyright (c) 2014 Jeremy Francispillai. All rights reserved.
//

import UIKit
import CoreData

class WorkoutViewController: UIViewController , UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    var increment:Double = 2.5
    
    var day:Day!
    var dayData:NSManagedObject!
    
    var cells = [ExerciseTableViewCell]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = day.name
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        updateDatabase()
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return day.lifts.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:ExerciseTableViewCell
        var lift:Lift = day.lifts[indexPath.row] as Lift
        
        if lift.sets>10 {
            lift.sets = 10
        } else if lift.sets<1 {
            lift.sets = 1
        }
        
        if lift.sets<=5{
            cell = tableView.dequeueReusableCellWithIdentifier("ExerciseCell3", forIndexPath: indexPath) as! ExerciseTableViewCell
        } else {
            cell = tableView.dequeueReusableCellWithIdentifier("ExerciseCell4", forIndexPath: indexPath) as! ExerciseTableViewCell
        }
        
        cell.liftName.text = lift.name.uppercaseString
        cell.weightLabel.setTitle(removeZero("\(lift.weight)") + " LB", forState: .Normal)
        //println(cell.sets[1].titleLabel.text)
        
        
        for var i=cell.sets.count; i>lift.sets; i-- {
            cell.sets[i-1].removeFromSuperview()
            cell.weights[i-1].removeFromSuperview()
            //cell.sets[i-1].setBackgroundImage(UIImage(named: "buttonImage2.png"), forState: .Normal)
            //cell.sets[i-1].enabled = false
            //cell.sets[i-1].setTitle("t", forState: .Normal)
        }
        
        for button in cell.sets {
            button.setTitle(String(lift.reps), forState: .Normal)
        }
        
        for set in cell.sets {
            set.weight = lift.weight
        }
        
        for weight in cell.weights {
            weight.text = removeZero("\(lift.weight)")
        }
        
        cell.lift = lift
        
        cells.append(cell)
        return cell
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat{
        if day.lifts[indexPath.row].sets>5 {
            return 258
        } else {
            return 180//168
        }
        
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return 300
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String!{
        let num:Double = Double(row) * increment
        return removeZero("\(num)")
    }
    
    func removeZero(num:String)->String{
        var text:String = num
        if text.hasSuffix(".0") {
            text = text.substringToIndex(advance(text.startIndex, count(text)-2))
        }
        return text
    }
    
    
    
    func updateDatabase(){
        
        var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var context:NSManagedObjectContext = appDelegate.managedObjectContext!
        
        var liftDataSet:NSSet = dayData.valueForKeyPath("lifts") as! NSSet
        
        let date = NSDate()
        
        for (index,lift) in enumerate(day.lifts) {
            for lData in liftDataSet {
                if lData.valueForKey("name") as! String == lift.name {
                    var liftData:NSManagedObject = lData as! NSManagedObject
                    
                    var finished:Bool = true
                    var finishedWeight:Double = cells[index].sets[0].weight
                    
                    for (setIndex,set) in enumerate(cells[index].sets) {
                        
                        let setTime = NSDate()
                        
                        if (set.weight < finishedWeight) {
                            finishedWeight = set.weight
                        }
                        
                        if set.reps < lift.reps {
                            finished = false
                        }
                        
                        var newSet = NSEntityDescription.insertNewObjectForEntityForName("CompletedSet", inManagedObjectContext: context) as! NSManagedObject
                        newSet.setValue(set.reps, forKey: "reps")
                        newSet.setValue(set.weight, forKey: "weight")
                        newSet.setValue(date, forKey: "date")
                        newSet.setValue(setTime, forKey: "setTime")
                        newSet.setValue(setIndex+1, forKey: "setNumber")
                        
                        liftData.mutableSetValueForKeyPath("completedSets").addObject(newSet)
                        print(set.reps)
                        println(set.weight)
                    }
                    
                    if finished && finishedWeight >= Double(liftData.valueForKey("weight") as! NSNumber){
                        let newWeight:Double = finishedWeight + Double(liftData.valueForKey("increment") as! NSNumber)
                        liftData.setValue(newWeight, forKey: "weight")
                    }

                }
            }
            
                        
        }
        
        context.save(nil)

    }
    
    
    //not using this at the moment
    @IBAction func finishWorkout(sender: AnyObject) {
        
        var alertController = UIAlertController(title: "Finish Workout?", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        
        var finishAction = UIAlertAction(title: "Finish", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            println("test")
            self.performSegueWithIdentifier("unwindToWorkoutSummary", sender: self)
        }
        
        var cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            println("cancel")
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(finishAction)
        self.presentViewController(alertController, animated: true, completion: nil)
        /*
        var alert: UIAlertView = UIAlertView()
        alert.title = "Finish Workout"
        alert.addButtonWithTitle("Cancel")
        alert.addButtonWithTitle("Finish")
        alert.show()*/
    }
}

