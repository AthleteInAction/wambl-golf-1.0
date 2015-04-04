//
//  DashboardCtrl.swift
//  Golf
//
//  Created by Will Robinson on 4/3/15.
//  Copyright (c) 2015 Will Robinson. All rights reserved.
//

import UIKit

protocol DashboardPTC {
    
    func addRound(round: PFObject)
    
}

class DashboardCtrl: UITableViewController, DashboardPTC {
    
    var rounds: [PFObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var query = PFQuery(className:"Rounds")
        
        query.whereKey("user", equalTo: PFUser.currentUser())
        query.orderByDescending("date")
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            
            if !(error != nil) {
               
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        
                        self.rounds.append(object)
                        
                    }
                }
                
                self.tableView.reloadData()
                
            } else {
                
                var code = error.userInfo?["code"] as Int
                
                Error.report(user: nil, error: error, alert: true)
                
            }
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
        
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return rounds.count
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        
        cell.textLabel?.text = rounds[indexPath.row]["title"] as? String
        cell.detailTextLabel?.text = printDate(rounds[indexPath.row]["date"] as NSDate) as String
        
        return cell
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var vc = storyboard?.instantiateViewControllerWithIdentifier("hole_ctrl") as HoleCtrl
        vc.hole_number = 1
        vc.round = rounds[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
        
    }

    @IBAction func newRound(sender: UIBarButtonItem){
        
        var vc = storyboard?.instantiateViewControllerWithIdentifier("new_round_ctrl") as NewRoundCtrl
        vc.dashboardDelegate = self
        var nav = UINavigationController(rootViewController: vc)
        self.presentViewController(nav, animated: true, completion: nil)
        
    }
    
    func addRound(round: PFObject) {
        
        rounds.insert(round,atIndex: 0)
        
        self.tableView.reloadData()
        
    }
    
    func printDate(date:NSDate) -> String {
        
        let dateFormatter = NSDateFormatter()//3
        
        var theDateFormat = NSDateFormatterStyle.ShortStyle //5
        let theTimeFormat = NSDateFormatterStyle.ShortStyle//6
        
        dateFormatter.dateStyle = theDateFormat//8
        dateFormatter.timeStyle = theTimeFormat//9
        
        return dateFormatter.stringFromDate(date)
        
    }
    
}