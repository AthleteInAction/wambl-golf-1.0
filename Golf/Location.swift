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
    private var accuracy: CLLocationAccuracy = kCLLocationAccuracyBestForNavigation
    
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
        
        stop()
        didComplete(location: location, error: error)
        
    }
    
    internal func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!){
        
        _didComplete(nil, error: error)
        
    }
    
    internal func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!){
        
        let location = locations.first as CLLocation
        
        println("-------")
        println(location)
        println("-------")
        
        if (location.horizontalAccuracy <= 5){
            timer.invalidate()
            _didComplete(location, error: nil)
        }
        
    }
    
    func get(completion: LocationClosure){
        
        timer.invalidate()
        timer = NSTimer.scheduledTimerWithTimeInterval(min, target: self, selector: "timedOut", userInfo: nil, repeats: false)
        
        didComplete = completion
        
        locationManager.startUpdatingLocation()
        
    }
    
    func stop(){locationManager.stopUpdatingLocation()}
    
    internal func timedOut(){
        
        _didComplete(nil, error: NSError(domain: "Getting location took too long.", code: 87, userInfo: nil))
        
    }
    
}