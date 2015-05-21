//
//  NewDayViewController.swift
//  WorkoutTrackerApp
//
//  Created by Jeremy Francispillai on 2014-08-09.
//  Copyright (c) 2014 Jeremy Francispillai. All rights reserved.
//

import UIKit

class NewDayViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var deleteButton: UIButton!
    
    var lifts:[Lift] = [Lift]()
    var day:Day?
    var tableRow:Int = -1//the row in the days table if a day is being updated... -1 if new
    
    @IBAction func unwindToDay(segue:UIStoryboardSegue) {
        
        let sourceController = segue.sourceViewController as! NewExerciseViewController
        if sourceController.tableRow == -1 {
            lifts.append(sourceController.lift!)
        }
        else if let temp = sourceController.lift{
            lifts[sourceController.tableRow] = sourceController.lift!
        }
        else{
            lifts.removeAtIndex(sourceController.tableRow)
        }
        
        tableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if tableRow == -1 {
            deleteButton.hidden = true
        }
        else {//if editing am existing day
            name.text = day!.name
            addButton.title = "Update"
        }
        
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if sender as? UIBarButtonItem == addButton {
            day = Day(name: name.text)
            
            for lift in lifts {
                day!.lifts.append(lift)
            }
        }
        else if sender as? UIButton == deleteButton{
            day = nil
        }
        else {
            let row = tableView.indexPathForSelectedRow()?.row
            if row != lifts.count {
                var destination = segue.destinationViewController as! NewExerciseViewController
                destination.lift = lifts[row!]
                destination.tableRow = row!
            }
        }
        
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return lifts.count + 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell = tableView.dequeueReusableCellWithIdentifier("DayNameCell", forIndexPath: indexPath) as! NameTableViewCell
        
        if indexPath.row == lifts.count {
            cell.name.text = "+ Add New Lift"
            cell.name.textColor = UIColor.blueColor()
        }
        else{
            if count(lifts[indexPath.row].name)==0 {
                lifts[indexPath.row].name = "Lift \(indexPath.row+1)"
            }
            cell.name.text = lifts[indexPath.row].name
            cell.name.textColor = UIColor.blackColor()
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat{
        return 50
    }
    
}
