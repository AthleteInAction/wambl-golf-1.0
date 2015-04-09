//
//  TestCtrl.swift
//  Golf
//
//  Created by Will Robinson on 4/6/15.
//  Copyright (c) 2015 Will Robinson. All rights reserved.
//

import UIKit
import CoreLocation

class TestCtrl: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var txt: UILabel!
    
    var cloc: CLLocationManager = CLLocationManager()
//    let region = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: "XGPS150-2B0A09"), identifier: "Dual GPS")
//    let region = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: "2097A628-EA36-443D-B2D8-E08CAA158EC4"), identifier: "Dual GPS")
    let region = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: "2B162531-FD29-4758-85B4-555A6DFF00FF"), identifier: "Test")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        strength.maximumValue = 10000000
        strength.minimumValue = 0
        strength.value = 1000
        ss = strength.value-1050
        label.text = "\(ss)"
        
        cloc.delegate = self
        cloc.requestAlwaysAuthorization()
        cloc.startUpdatingLocation()
        cloc.startRangingBeaconsInRegion(region)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        let location = locations.first as CLLocation
        
//        println("================")
//        println(location)
//        println("================")
        
    }
    
    @IBOutlet weak var strength: UIStepper!
    var ss: Double!
    @IBOutlet weak var label: UILabel!
    @IBAction func change(sender: UIStepper){
        
        println("SENDER: \(sender.value)")
        ss = sender.value-1050
        label.text = "\(ss)"
        
    }
    
    func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: [AnyObject]!, inRegion region: CLBeaconRegion!) {
        
        let knownBeacons = beacons.filter {$0.proximity != CLProximity.Unknown}
        
        var message = "OUT OF RANGE"
        
        if knownBeacons.count > 0 {
            
            let beacon = knownBeacons.first as CLBeacon
            
            let acc: Double = calculateAccuracy(ss, rssi: Double(beacon.rssi))
            
            var accuracy = round(beacon.accuracy*100)/100
            
            switch beacon.proximity {
            case CLProximity.Far:
                message = "FAR :: \(accuracy) :: \(beacon.rssi) :: \(acc)"
            case CLProximity.Near:
                message = "NEAR :: \(accuracy) :: \(beacon.rssi) :: \(acc)"
            case CLProximity.Immediate:
                message = "IMMEDIATE :: \(accuracy) :: \(beacon.rssi) :: \(acc)"
            case CLProximity.Unknown:
                message = "UNKNOWN :: \(accuracy) :: \(beacon.rssi) :: \(acc)"
            default:
                message = "--"
            }
            
            println("----------------")
            println(message)
            println("----------------")
            
        }
        
        txt.text = message
        
    }
    
    func calculateAccuracy(txPower: Double,rssi: Double) -> Double {
        
        var final: Double!
        if (rssi == 0) {
            
            final = -1.0;
        
        }
        
        var ratio: Double = rssi * 1.0 / txPower
        
        if (ratio < 1.0) {
            
            final = pow(ratio,10)
        
        } else {
            
            var accuracy: Double =  (0.89976)*pow(ratio,7.7095) + 0.111
            
            final = accuracy;
        
        }
        
        return round(final*100)/100
        
    }

}
