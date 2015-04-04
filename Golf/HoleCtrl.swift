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
    @IBOutlet weak var set: UIButton!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var table: UITableView!
    var score: Int = 0
    var strokes: [PFObject] = []
    
    var location = Location(_accuracy: kCLLocationAccuracyBestForNavigation, _timeout: 20)
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        title = "\(hole_number)"
        
        table.delegate = self
        self.table.reloadData()
        
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
        
        cell.textLabel?.text = strokes[indexPath.row]["objectId"] as? String
//        cell.detailTextLabel?.text = stokes[indexPath.row][""] as? String
        
        return cell
        
    }
    
    @IBAction func setStroke(sender: UIButton){
        
        loader.startAnimating()
        set.hidden = true
        
        location.get { (location, error) -> () in
            
            if let loc = location {
                
                println(loc)
                
                var stroke = PFObject(className:"Strokes")
                stroke["user"] = PFUser.currentUser()
                stroke["hole"] = self.hole_number
                stroke["par"] = (self.par.selectedSegmentIndex+3)
                stroke["point"] = PFGeoPoint(latitude: loc.coordinate.latitude, longitude: loc.coordinate.longitude)
                
                var relation: PFRelation = self.round.relationForKey("strokes")
                relation.addObject(stroke)
                
                self.round.saveInBackgroundWithBlock {
                    (success: Bool, error: NSError!) -> Void in
                    
                    if success {
                        
                        self.strokes.append(stroke)
                        
                    } else {
                        
                        var code = error.userInfo?["code"] as Int
                        
                        Error.report(user: nil, error: error, alert: true)
                        
                    }
                    
                    self.loader.stopAnimating()
                    self.set.hidden = false
                    
                    self.table.reloadData()
                    
                }
                
            } else if let err = error {
                
                println(err)
                
                self.loader.stopAnimating()
                self.set.hidden = false
                
            }
            
        }
        
        
        
        
        
//        gameScore.saveInBackgroundWithBlock {
//            (success: Bool, error: NSError!) -> Void in
//            if (success) {
//                // The object has been saved.
//            } else {
//                // There was a problem, check error.description
//            }
//        }
        
    }
    
}