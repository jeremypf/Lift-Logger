//
//  LogViewController.swift
//  WorkoutLogApp
//
//  Created by Jeremy Francispillai on 2014-08-23.
//  Copyright (c) 2014 Jeremy Francispillai. All rights reserved.
//

import UIKit
import CoreData

class LogViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {

    var workoutData:NSManagedObject!
    var rows = [AnyObject]()
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        refreshData()
        return rows.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        var cell:LiftSummaryTableViewCell
        
        if rows[indexPath.row] is NSManagedObject {
            cell = tableView.dequeueReusableCellWithIdentifier("LiftSummaryCell", forIndexPath: indexPath) as! LiftSummaryTableViewCell
            
            let set:Int = rows[indexPath.row].valueForKey("setNumber") as! Int
            let equalSet:Int = rows[indexPath.row].valueForKey("equalSetNumber") as! Int
            var setName:String = "\(set)"
            for var i=set+1;i<=equalSet;i++ {
                setName+=",\(i)"
            }
            cell.name.text = setName
            
            let reps:Int = rows[indexPath.row].valueForKey("reps") as! Int
            cell.summary.text = "\(reps)"
            let weight:Double = rows[indexPath.row].valueForKey("weight") as! Double
            cell.summary2.text = "\(weight)"
        }
        else if indexPath.row == 0 || rows[indexPath.row+1] is String{
            println(rows[indexPath.row])
            cell = tableView.dequeueReusableCellWithIdentifier("DayNameCell", forIndexPath: indexPath) as! LiftSummaryTableViewCell
            cell.name.text = rows[indexPath.row+2].valueForKeyPath("lift.day.name") as? String
            //cell.summary.text = rows[indexPath.row+2].valueForKey("date") as String
        }
        else {
            println(rows[indexPath.row])
            cell = tableView.dequeueReusableCellWithIdentifier("LiftNameCell", forIndexPath: indexPath) as! LiftSummaryTableViewCell
            cell.name.text = rows[indexPath.row+1].valueForKeyPath("lift.name") as? String
        }
            
        return cell
    }
    
    func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat{
        if rows[indexPath.row] is NSManagedObject {
            return 25//50
        }else if indexPath.row == 0 || rows[indexPath.row+1] is String{
            return 50//22
        }
        return 22//25
    }
    
    
    func refreshData(){
        
        rows.removeAll(keepCapacity: true)
        
        var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var context:NSManagedObjectContext = appDelegate.managedObjectContext!
        var request = NSFetchRequest(entityName: "CompletedSet")
        
        var sortDescriptors = [NSSortDescriptor]()
        sortDescriptors.append(NSSortDescriptor(key: "date", ascending: false))
        sortDescriptors.append(NSSortDescriptor(key: "setTime", ascending: true))
        //sortDescriptors.append(NSSortDescriptor(key: "lift.name", ascending: false))
        sortDescriptors.append(NSSortDescriptor(key: "setNumber", ascending: true))
        request.sortDescriptors = sortDescriptors
        request.predicate = NSPredicate(format: "lift.day.workout.name= %@", workoutData.valueForKey("name") as! String)
        var data:NSArray = context.executeFetchRequest(request, error: nil)!
        
        for setData in data {
            var set:NSManagedObject = setData as! NSManagedObject
            
            if rows.count != 0 && (set.valueForKeyPath("lift.day.name") as! String) == (rows[rows.count-1].valueForKeyPath("lift.day.name") as! String) && (set.valueForKeyPath("lift.name") as! String) == (rows[rows.count-1].valueForKeyPath("lift.name") as! String) {
                
                if (set.valueForKeyPath("reps") as! Int) == (rows[rows.count-1].valueForKeyPath("reps") as! Int) && (set.valueForKeyPath("weight") as! Double) == (rows[rows.count-1].valueForKeyPath("weight") as! Double){
                    rows[rows.count-1].setValue(set.valueForKey("setNumber") as! Int, forKey: "equalSetNumber")
                }
                else {
                    rows.append(set)
                }
                
            }
            else{
                if rows.count==0 || (set.valueForKeyPath("lift.day.name") as! String) != (rows[rows.count-1].valueForKeyPath("lift.day.name") as! String) || (set.valueForKey("date") as! NSDate) != (rows[rows.count-1].valueForKey("date") as! NSDate){
                    rows.append("day")
                }
                rows.append("lift")
                rows.append(set)
            }
            
        }
        
    }

}
