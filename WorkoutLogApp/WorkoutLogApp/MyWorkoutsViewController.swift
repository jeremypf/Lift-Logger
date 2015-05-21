//
//  MyWorkoutsViewController.swift
//  WorkoutTrackerApp
//
//  Created by Jeremy Francispillai on 2014-07-06.
//  Copyright (c) 2014 Jeremy Francispillai. All rights reserved.
//

import UIKit
import CoreData

class MyWorkoutsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func unwindToMyWorkouts(segue:UIStoryboardSegue) {
        if let sourceController = segue.sourceViewController as? NewWorkoutViewController{
            if let workout = sourceController.workout {
                workouts = getWorkouts()
            }
            else{
                //days.removeAtIndex(sourceController.tableRow)
            }
            tableView.reloadData()
        }
    }
    
    
    var workouts = [Workout]()
    var allWorkoutData = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        workouts = getWorkouts()
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if segue.identifier == "toWorkout" {
            let row = tableView.indexPathForSelectedRow()?.row
            var destination = segue.destinationViewController as! WorkoutSummaryViewController
            destination.workout = workouts[row!]
            destination.workoutData = allWorkoutData[row!]
        }
    }
    
    
    func getWorkouts()->[Workout]{
        
        var allWorkouts = [Workout]()
        allWorkoutData.removeAll(keepCapacity: true)
        
        var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var context:NSManagedObjectContext = appDelegate.managedObjectContext!
        var request = NSFetchRequest(entityName: "Workout")
        var data:NSArray = context.executeFetchRequest(request, error: nil)!
        
        for workoutData in data {
            var wData:NSManagedObject = workoutData as! NSManagedObject
            
            allWorkoutData.append(wData)//adds workout NSManagedObject to allworkoutdata
            
            var workout:Workout = Workout(name: wData.valueForKey("name") as! String)
            var dayDataSet:NSSet = wData.valueForKeyPath("days") as! NSSet
            
            for dayData in dayDataSet {
                var dData:NSManagedObject = dayData as! NSManagedObject
                var day:Day = Day(name: dData.valueForKey("name") as! String)
                var liftDataSet:NSSet = dData.valueForKeyPath("lifts") as! NSSet
                
                for liftData in liftDataSet {
                    var lData:NSManagedObject = liftData as! NSManagedObject
                    var lift:Lift = Lift(name: lData.valueForKey("name") as! String, sets: lData.valueForKey("sets") as! Int, reps: lData.valueForKey("reps") as! Int, weight: lData.valueForKey("weight") as! Double, increment: lData.valueForKey("increment") as! Double)
                    day.lifts.append(lift)
                }
                workout.days.append(day)
            }
            allWorkouts.append(workout)
        }
        
        return allWorkouts
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return workouts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell = tableView.dequeueReusableCellWithIdentifier("WorkoutNameCell", forIndexPath: indexPath)  as! NameTableViewCell
        
        if count(workouts[indexPath.row].name)==0 {
            workouts[indexPath.row].name = "Workout \(indexPath.row+1)"
        }
        cell.name.text = workouts[indexPath.row].name
        return cell
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 50
    }

}
