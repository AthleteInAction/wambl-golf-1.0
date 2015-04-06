//
//  Location.swift
//  Golf
//
//  Created by Will Robinson on 4/3/15.
//  Copyright (c) 2015 Will Robinson. All rights reserved.
//

import Foundation
import CoreLocation

class Location : NSObject, CLLocationManagerDelegate {
    
    private var min: NSTimeInterval = 5
    private var accuracy: CLLocationAccuracy = kCLLocationAccuracyBest
    
    private var timer = NSTimer()
    
    private let locationManager:CLLocationManager = CLLocationManager()
    
    init(_accuracy: CLLocationAccuracy?,_timeout: NSTimeInterval?){
        super.init()
        
        if _timeout != nil {min = _timeout!}
        if _accuracy != nil {accuracy = _accuracy!}
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = accuracy
        locationManager.requestWhenInUseAuthorization()
        
    }
    
    typealias LocationClosure = ((location: CLLocation?, error: NSError?)->())
    private var didComplete: LocationClosure!
    
    private func _didComplete(location: CLLocation?, error: NSError?) {
        
        didComplete(location: location, error: error)
        
    }
    
    internal func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!){
        
        stop()
        _didComplete(nil, error: error)
        
    }
    
    internal func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!){
        
        let location = locations.first as CLLocation
        
        _didComplete(location, error: nil)
        
    }
    
    func monitor(completion: LocationClosure){
        
        didComplete = completion
        
    }
    
    func start(){locationManager.startUpdatingLocation()}
    func stop(){locationManager.stopUpdatingLocation()}
    
}