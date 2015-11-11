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
            let row = tableView.indexPathForSelectedRow?.row
            let destination = segue.destinationViewController as! WorkoutSummaryViewController
            destination.workout = workouts[row!]
            destination.workoutData = allWorkoutData[row!]
        }
    }
    
    
    func getWorkouts()->[Workout]{
        
        var allWorkouts = [Workout]()
        allWorkoutData.removeAll(keepCapacity: true)
        
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDelegate.managedObjectContext!
        let request = NSFetchRequest(entityName: "Workout")
        let data:NSArray = try! context.executeFetchRequest(request)
        
        for workoutData in data {
            let wData:NSManagedObject = workoutData as! NSManagedObject
            
            allWorkoutData.append(wData)//adds workout NSManagedObject to allworkoutdata
            
            let workout:Workout = Workout(name: wData.valueForKey("name") as! String)
            let dayDataSet:NSSet = wData.valueForKeyPath("days") as! NSSet
            
            for dayData in dayDataSet {
                let dData:NSManagedObject = dayData as! NSManagedObject
                let day:Day = Day(name: dData.valueForKey("name") as! String)
                let liftDataSet:NSSet = dData.valueForKeyPath("lifts") as! NSSet
                
                for liftData in liftDataSet {
                    let lData:NSManagedObject = liftData as! NSManagedObject
                    let lift:Lift = Lift(name: lData.valueForKey("name") as! String, sets: lData.valueForKey("sets") as! Int, reps: lData.valueForKey("reps") as! Int, weight: lData.valueForKey("weight") as! Double, increment: lData.valueForKey("increment") as! Double)
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
        let cell = tableView.dequeueReusableCellWithIdentifier("WorkoutNameCell", forIndexPath: indexPath)  as! NameTableViewCell
        
        if workouts[indexPath.row].name.characters.count==0 {
            workouts[indexPath.row].name = "Workout \(indexPath.row+1)"
        }
        cell.name.text = workouts[indexPath.row].name
        return cell
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 50
    }

}
