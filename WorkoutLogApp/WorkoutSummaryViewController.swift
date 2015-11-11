//
//  WorkoutSummaryViewController.swift
//  WorkoutLogApp
//
//  Created by Jeremy Francispillai on 2014-08-20.
//  Copyright (c) 2014 Jeremy Francispillai. All rights reserved.
//

import UIKit
import CoreData

class WorkoutSummaryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func unwindToWorkoutSummary(segue:UIStoryboardSegue) {
        if let sourceController = segue.sourceViewController as? WorkoutViewController{
            refreshData()
            tableView.reloadData()
        }
    }
    
    var workout:Workout!
    var workoutData:NSManagedObject!
    var rows = [AnyObject]()
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if segue.identifier == "startSession" {
            let row = tableView.indexPathForSelectedRow?.row
            let destination = segue.destinationViewController as!WorkoutViewController
            destination.day = rows[row!] as! Day
            
            let dayDataSet:NSSet = workoutData.valueForKeyPath("days") as!NSSet
            
            for dayData in dayDataSet {
                let day:NSManagedObject = dayData as!NSManagedObject
                if day.valueForKey("name") as!String == destination.day.name {
                    destination.dayData = dayData as! NSManagedObject
                    return
                }
            }
        }
        else if segue.identifier == "toLog" {
            let destination = segue.destinationViewController as!LogViewController
            destination.workoutData = workoutData
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = workout.name
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        rows.removeAll(keepCapacity: true)
        for day in workout.days {
            rows.append(day)
            for lift in day.lifts {
                rows.append(lift)
            }
        }
        
        return rows.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        if rows[indexPath.row] is Day {
            let cell = tableView.dequeueReusableCellWithIdentifier("DaySummaryCell", forIndexPath: indexPath) as!NameTableViewCell
            cell.name.text = (rows[indexPath.row] as!Day).name
            
            return cell
        }
        //else
        let cell = tableView.dequeueReusableCellWithIdentifier("LiftSummaryCell", forIndexPath: indexPath)  as!LiftSummaryTableViewCell
        
        let lift = rows[indexPath.row] as!Lift
        cell.name.text = lift.name
        cell.summary.text = "\(lift.sets) x \(lift.reps)  \(lift.getWeight())lb"
        
        return cell
    }
    
    func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat{
        if rows[indexPath.row] is Day {
            return 85
        }
        //else
        return 28
    }
    
    
    
    func refreshData(){
        
        var tempWorkout:Workout
        
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as!AppDelegate
        let context:NSManagedObjectContext = appDelegate.managedObjectContext!
        let request = NSFetchRequest(entityName: "Workout")
        request.predicate = NSPredicate(format: "name= %@", workout.name)
        
        /*var sortDescriptors = [NSSortDescriptor]()
        sortDescriptors.append(NSSortDescriptor(key: "order", ascending: true))
        request.sortDescriptors = sortDescriptors*/
        
        let data:NSArray = try! context.executeFetchRequest(request)
        
        let wData:NSManagedObject = data[0] as!NSManagedObject
        
        workoutData = wData
        tempWorkout = Workout(name: wData.valueForKey("name") as!String)
        let dayDataSet:NSSet = wData.valueForKeyPath("days") as!NSSet
        
        
        for dayData in dayDataSet {
            let dData:NSManagedObject = dayData as!NSManagedObject
            let day:Day = Day(name: dData.valueForKey("name") as!String)
            let liftDataSet:NSSet = dData.valueForKeyPath("lifts") as!NSSet
            
            for liftData in liftDataSet {
                let lData:NSManagedObject = liftData as!NSManagedObject
                let lift:Lift = Lift(name: lData.valueForKey("name") as!String, sets: lData.valueForKey("sets") as! Int, reps: lData.valueForKey("reps") as! Int, weight: lData.valueForKey("weight") as! Double, increment: lData.valueForKey("increment") as! Double)
                day.lifts.append(lift)
            }
            tempWorkout.days.append(day)
        }
        
        workout = tempWorkout
        print(workout.name)
    }
}
