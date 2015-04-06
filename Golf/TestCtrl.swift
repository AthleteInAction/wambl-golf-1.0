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
    
    var cloc: CLLocationManager = CLLocationManager()
//    let region = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: "XGPS150-2B0A09"), identifier: "Dual GPS")
    let region = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: "2097A628-EA36-443D-B2D8-E08CAA158EC4"), identifier: "Dual GPS")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cloc.delegate = self
        cloc.requestAlwaysAuthorization()
        cloc.startRangingBeaconsInRegion(region)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
    }
    
    func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: [AnyObject]!, inRegion region: CLBeaconRegion!) {
        
        println("----------------")
        println(beacons)
        println("----------------")
        
    }

}
