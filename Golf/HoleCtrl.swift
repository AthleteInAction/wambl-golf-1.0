//
//  HoleCtrl.swift
//  Golf
//
//  Created by Will Robinson on 4/3/15.
//  Copyright (c) 2015 Will Robinson. All rights reserved.
//

import UIKit

class HoleCtrl: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var round: PFObject!
    
    var hole_number: Int!
    @IBOutlet weak var par: UISegmentedControl!
    var parIndex: Int!
    @IBOutlet weak var set: UIButton!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var scoreTxt: UILabel!
    var score: Int = 0
    var strokes: [PFObject] = []
    
    var location = Location(_accuracy: kCLLocationAccuracyBestForNavigation, _timeout: 20)
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        title = "\(hole_number)"
        
        table.delegate = self
        table.dataSource = self
        
        parIndex = ((round["pars"] as Array<Int>)[hole_number-1]-3)
        if parIndex > -1 && parIndex <= 2 {
            par.selectedSegmentIndex = parIndex
        }
        
        var query = PFQuery(className:"Strokes")
        
        query.whereKey("round", equalTo: round)
        query.whereKey("hole", equalTo: hole_number)
        query.whereKey("user", equalTo: PFUser.currentUser())
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            
            if !(error != nil) {
                
                for object in objects {
                    
                    var stroke = object as PFObject
                    
                    self.strokes.append(stroke)
                    
                }
                
                self.score = objects.count
                self.scoreTxt.text = "Score: \(self.score)"
                
            } else {
                
                Error.report(user: PFUser.currentUser(), error: error, alert: true)
                
            }
            
            self.table.reloadData()
            
        }
        
    }

    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
        
        
        
    }

    @IBAction func nextHole(sender: UIBarButtonItem){
        
        if hole_number < 18 {
            
            var vc = storyboard?.instantiateViewControllerWithIdentifier("hole_ctrl") as HoleCtrl
            vc.hole_number = (hole_number+1)
            vc.round = round
            navigationController?.pushViewController(vc, animated: true)
            
        }
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return strokes.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        let stroke = strokes[indexPath.row] as PFObject
        
        cell.textLabel?.text = stroke.objectId
        var p = stroke["point"] as PFGeoPoint
        cell.detailTextLabel?.text = "\(p.longitude) : \(p.latitude)"
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            
            let stroke = strokes[indexPath.row]
            
            stroke.deleteInBackgroundWithBlock({ (success: Bool, error: NSError!) -> Void in
                
                if success {
                    
                    self.strokes.removeAtIndex(indexPath.row)
                    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                    
                    self.score = self.strokes.count
                    self.scoreTxt.text = "Score: \(self.score)"
                    
                } else {
                    
                    Error.report(user: PFUser.currentUser(), error: error, alert: true)
                    
                }
                
            })
            
        }
        
    }
    
    @IBAction func setStroke(sender: UIButton){
        
        loader.startAnimating()
        set.hidden = true
        
        location.get { (location, error) -> () in
            
            if let loc = location {
                
                var stroke = PFObject(className:"Strokes")
                
                stroke["user"] = PFUser.currentUser()
                stroke["round"] = self.round
                stroke["hole"] = self.hole_number
                stroke["par"] = (self.par.selectedSegmentIndex+3)
                stroke["point"] = PFGeoPoint(latitude: loc.coordinate.latitude, longitude: loc.coordinate.longitude)
            
                stroke.saveInBackgroundWithBlock({ (success: Bool, error: NSError!) -> Void in
                    
                    if success {
                        
                        self.strokes.append(stroke)
                        self.score = self.strokes.count
                        self.scoreTxt.text = "Score: \(self.score)"
                        
                    } else {
                        
                        
                        
                    }
                    
                    self.loader.stopAnimating()
                    self.set.hidden = false
                    
                    self.table.reloadData()
                    
                })
                
            } else if let err = error {
                
                // ALERT USER TO ERROR
                var errorAlert = UIAlertController(title: "Error", message: "GPS took too long.", preferredStyle: UIAlertControllerStyle.Alert)
                
                errorAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                    
                    
                    
                }))
                
                root.rootViewController?.presentViewController(errorAlert, animated: true, completion: nil)
                
                self.loader.stopAnimating()
                self.set.hidden = false
                
            }
            
        }
        
    }
    
    @IBAction func parChanged(sender: UISegmentedControl){
        
        var tmp = round["pars"] as Array<Int>
        
        tmp[hole_number-1] = sender.selectedSegmentIndex+3
        
        round["pars"] = tmp
        
        round.saveInBackgroundWithBlock { (success: Bool, error: NSError!) -> Void in
            
            if success {
                
                
                
            } else {
                
                Error.report(user: PFUser.currentUser(), error: error, alert: true)
                
            }
            
        }
        
    }
    
}