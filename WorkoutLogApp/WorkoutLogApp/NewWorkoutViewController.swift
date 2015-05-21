//
//  NewWorkoutViewController.swift
//  WorkoutTrackerApp
//
//  Created by Jeremy Francispillai on 2014-07-15.
//  Copyright (c) 2014 Jeremy Francispillai. All rights reserved.
//

import UIKit
import CoreData

class NewWorkoutViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var createButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    var days:[Day] = [Day]()
    var workout:Workout?
    
    @IBAction func unwindToNewWorkout(segue:UIStoryboardSegue) {
        
        let sourceController = segue.sourceViewController as! NewDayViewController
        if sourceController.tableRow == -1 {
            days.append(sourceController.day!)
        }
        else if let temp = sourceController.day{// make this look better like in myworkouts
            days[sourceController.tableRow] = sourceController.day!
        }
        else{
            days.removeAtIndex(sourceController.tableRow)
        }
        
        tableView.reloadData()
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if sender as? UIBarButtonItem == createButton{
            
            workout = Workout(name: name.text)
            for day in days {
                workout!.days.append(day)
            }
            
            var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            var context:NSManagedObjectContext = appDelegate.managedObjectContext!
            
            
            
            var newWorkout = NSEntityDescription.insertNewObjectForEntityForName("Workout", inManagedObjectContext: context) as! NSManagedObject
            newWorkout.setValue(workout!.name, forKey: "name")
            
            //var workoutDays = newWorkout.valueForKeyPath("days") as NSMutableSet
            
            for (index,day) in enumerate(workout!.days) {
                
                var newDay = NSEntityDescription.insertNewObjectForEntityForName("Day", inManagedObjectContext: context) as! NSManagedObject
                newDay.setValue(day.name, forKey: "name")
                newDay.setValue(index, forKey: "order")
                
                //var dayLifts = newDay.valueForKeyPath("lifts") as NSMutableSet
                
                for (index,lift) in enumerate(day.lifts) {
                    
                    var newLift = NSEntityDescription.insertNewObjectForEntityForName("Lift", inManagedObjectContext: context) as! NSManagedObject
                    
                    newLift.setValue(lift.name, forKey: "name")
                    newLift.setValue(lift.sets, forKey: "sets")
                    newLift.setValue(lift.reps, forKey: "reps")
                    newLift.setValue(lift.weight, forKey: "weight")
                    newLift.setValue(lift.increment, forKey: "increment")
                    
                    newDay.mutableSetValueForKeyPath("lifts").addObject(newLift)
                }
                
                newWorkout.mutableSetValueForKeyPath("days").addObject(newDay)
            }
            
            context.save(nil)
            
        }
        else if sender as? UIBarButtonItem == cancelButton{
            workout = nil
        }
        else {//if press on a table cell
            let row = tableView.indexPathForSelectedRow()?.row
            if row != days.count {
                var destination = segue.destinationViewController as! NewDayViewController
                destination.day = days[row!]
                destination.tableRow = row!
                
                for lift in destination.day!.lifts {
                    destination.lifts.append(lift)
                    println(lift.name)
                }
            }
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return days.count + 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell = tableView.dequeueReusableCellWithIdentifier("DayNameCell", forIndexPath: indexPath) as! NameTableViewCell
        
        if indexPath.row == days.count {
            cell.name.text = "+ Add New Day"
            cell.name.textColor = UIColor.blueColor()
        }
        else{
            if count(days[indexPath.row].name)==0 {
                days[indexPath.row].name = "Day \(indexPath.row+1)"
            }
            cell.name.text = days[indexPath.row].name
            cell.name.textColor = UIColor.blackColor()
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 50
    }

}
