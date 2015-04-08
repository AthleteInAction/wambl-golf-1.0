//
//  HoleCtrl.swift
//  Golf
//
//  Created by Will Robinson on 4/3/15.
//  Copyright (c) 2015 Will Robinson. All rights reserved.
//

import UIKit
import CoreLocation
import AudioToolbox

class HoleCtrl: UIViewController,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate,UIPickerViewDelegate {
    
    var cloc: CLLocationManager!
    
    var round: PFObject!
    
    @IBOutlet weak var progress: UIProgressView!
    
    var hole_number: Int!
    @IBOutlet weak var par: UISegmentedControl!
    var parIndex: Int!
    @IBOutlet weak var set: UIButton!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var scoreTxt: UILabel!
    var score: Int = 0
    var strokes: [PFObject] = []
    var locations: [CLLocation] = []
    var waiting: Bool = false
    var usersLocation: CLLocation?
    
    var club: String!
    @IBOutlet weak var clubs: UIPickerView!
    var clubsList: [String] = [
        "Putter",
        "60°",
        "56°",
        "52°",
        "Pitching Wedge",
        "9 Iron",
        "8 Iron",
        "7 Iron",
        "6 Iron",
        "5 Iron",
        "4 Iron",
        "3 Iron",
        "3 Wood",
        "Driver"
    ]
    var selectedClub: Int?
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        title = "\(hole_number)"
        
        table.delegate = self
        table.dataSource = self
        
        clubs.delegate = self
        
        cloc = CLLocationManager()
        
        if cloc.delegate != nil {
            println("PASSED")
        } else {
            println("SELF")
            cloc.delegate = self
        }
        
        cloc.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        cloc.requestAlwaysAuthorization()
        cloc.startUpdatingLocation()
        
        parIndex = ((round["pars"] as Array<Int>)[hole_number-1]-3)
        if parIndex > -1 && parIndex <= 2 {
            par.selectedSegmentIndex = parIndex
        }
        
        var query = PFQuery(className:"Strokes")
        
        query.whereKey("round", equalTo: round)
        query.whereKey("hole", equalTo: hole_number)
        query.whereKey("user", equalTo: PFUser.currentUser())
        query.orderByDescending("created_at")
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            
            if !(error != nil) {
                
                for object in objects {
                    
                    var stroke = object as PFObject
                    
                    self.strokes.append(stroke)
                    
                }
                
                self.table.reloadData()
                
            } else {
                
                Error.report(user: PFUser.currentUser(), error: error, alert: true)
                
            }
            
            self.table.reloadData()
            
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        if selectedClub != nil {
            club = clubsList[selectedClub!]
        } else {
            club = clubsList.last
            selectedClub = (clubsList.count-1)
        }
        clubs.selectRow(selectedClub!, inComponent: 0, animated: true)
        
    }

    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
        
        
        
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return clubsList.count
        
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        
        return clubsList[row] as String
        
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        selectedClub = row
        club = clubsList[selectedClub!]
        
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        
        println("ERROR")
        waiting = false
        cloc.stopUpdatingLocation()
        
    }
    
    var affirm: Int = 0
    var accuracy: CLLocationAccuracy = 10
    var verify: Int = 5
    var ll: CLLocation?
    @IBOutlet weak var diffTxt: UILabel!
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        let location = locations.first as CLLocation
        
        pulse(location)
        
        usersLocation = location
        
        if ll != nil && location.horizontalAccuracy <= accuracy {
            affirm++
            diffTxt.text = "DIFF: \(location.distanceFromLocation(ll).yd)"
        }
        
        if ll != nil && location.distanceFromLocation(ll) > 0 {
            
            affirm = 0
            
        }
        
        if location.horizontalAccuracy > accuracy {
            
            affirm = 0
            
        }
        
        if location.horizontalAccuracy <= accuracy && affirm >= verify && waiting {
            
            saveStroke(location)
            
        }
        
        if saving {
            
            
            
        }
        
        ll = location
        
        var p: Float = Float(affirm) / Float(verify)
        
        switch p {
        case 0...0.1:
            p = 0.1
        case 0.1...1:
            break
        default:
            p = 1
        }
        
        progress.setProgress(p, animated: true)
        
        println("Hole: \(hole_number) :: Affirm: \(affirm) ::: \(location.horizontalAccuracy) :: \(location.timestamp)")
        
    }
    
    @IBOutlet weak var blink: UIView!
    @IBOutlet weak var acc: UIProgressView!
    func pulse(location: CLLocation){
        
        var lac: Float = 0
        switch location.horizontalAccuracy {
        case 0...5:
            lac = 1.0
        case 5...10:
            lac = 0.9
        case 10...20:
            lac = 0.8
        case 20...40:
            lac = 0.7
        case 40...80:
            lac = 0.6
        case 80...160:
            lac = 0.5
        case 160...320:
            lac = 0.4
        case 320...640:
            lac = 0.3
        case 640...1280:
            lac = 0.2
        default:
            lac = 0.1
        }
        acc.setProgress(lac, animated: true)
        
        let w = CGFloat(80)
        
        UIView.animateWithDuration(0.2, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 5, options: nil, animations: {
            self.blink.bounds.size.width = 100
            },completion: { (s) -> Void in
                
                UIView.animateWithDuration(0.2, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 5, options: nil, animations: {
                    
                    self.blink.bounds.size.width = w
                    
                },completion: nil)
                
        })
        
    }
    
    var saving: Bool = false
    func saveStroke(location: CLLocation){
        
        saving = true
        waiting = false
        cloc.stopUpdatingLocation()
        
        var stroke = PFObject(className:"Strokes")
        
        stroke["user"] = PFUser.currentUser()
        stroke["round"] = self.round
        stroke["hole"] = self.hole_number
        stroke["par"] = (self.par.selectedSegmentIndex+3)
        stroke["altitude"] = location.altitude
        stroke["accuracy"] = location.horizontalAccuracy
        stroke["desiredAccuracy"] = accuracy
        if strokes.count > 0 {stroke["club"] = club}
        stroke["point"] = PFGeoPoint(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        stroke.saveInBackgroundWithBlock({ (success: Bool, error: NSError!) -> Void in
            
            if success {
                
                self.strokes.append(stroke)
                
                AudioServicesPlaySystemSound(4095)
                
            } else {
                
                Error.report(user: PFUser.currentUser(), error: error, alert: true)
                
            }
            
            self.loader.stopAnimating()
            self.set.hidden = false
            
            self.table.reloadData()
            
            self.cloc.startUpdatingLocation()
            
            self.saving = false
            
            println("SAVED!")
            
        })
        
    }

    @IBAction func nextHole(sender: UIBarButtonItem){
        
        if hole_number < 18 {
            
            var vc = storyboard?.instantiateViewControllerWithIdentifier("hole_ctrl") as HoleCtrl
            vc.hole_number = (hole_number+1)
            vc.round = round
            vc.selectedClub = selectedClub
            vc.cloc = cloc
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
        
        cell.selectionStyle = .None
        
        let stroke = strokes[indexPath.row] as PFObject
        let currentPoint = stroke["point"] as PFGeoPoint
        
        var g = CLLocation(latitude: (currentPoint.latitude as CLLocationDegrees), longitude: (currentPoint.longitude as CLLocationDegrees))
        
        locations.append(g)
        
        if indexPath.row > 0 {
            
            let lastStroke = strokes[indexPath.row-1] as PFObject
            var lastPoint = lastStroke["point"] as PFGeoPoint
            
            let l = lastPoint.location
            let c = currentPoint.location
            
            let d: CLLocationDistance = c.distanceFromLocation(l)
            
            let cl: String = stroke["club"] as String
            
            cell.textLabel?.text = cl
            cell.detailTextLabel?.text = "\(d.yd.rd(2)) yd"
            
        } else {
            
            cell.textLabel?.text = "Tee Box"
            cell.detailTextLabel?.text = nil
            
        }
        
        var p = stroke["point"] as PFGeoPoint
        
        setScore()
        
        return cell
        
    }
    
    func setScore(){
        
        score = strokes.count
        scoreTxt.text = "Score: \(score)"
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            
            let stroke = strokes[indexPath.row]
            
            stroke.deleteInBackgroundWithBlock({ (success: Bool, error: NSError!) -> Void in
                
                if success {
                    
                    self.strokes.removeAtIndex(indexPath.row)
                    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                    tableView.reloadData()
                    
                } else {
                    
                    Error.report(user: PFUser.currentUser(), error: error, alert: true)
                    
                }
                
            })
            
        }
        
    }
    
    @IBAction func setStroke(sender: UIButton){
        
        waiting = true
        
        loader.startAnimating()
        set.hidden = true
        
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
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent) {
        
        if motion == UIEventSubtype.MotionShake {
            
            println("Shake: \(hole_number)")
            
            AudioServicesPlaySystemSound(1350)
            
            setStroke(UIButton())
            
        }
        
    }
    
}