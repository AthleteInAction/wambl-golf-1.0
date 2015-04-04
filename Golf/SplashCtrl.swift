//
//  SplashCtrl.swift
//  Golf
//
//  Created by Will Robinson on 4/3/15.
//  Copyright (c) 2015 Will Robinson. All rights reserved.
//

import UIKit

class SplashCtrl: UIViewController {
    
    var manager: Location = Location(_accuracy: kCLLocationAccuracyBestForNavigation, _timeout: 5)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.get { (location, error) -> () in
            
            if let loc = location {
                
                println(loc.coordinate.latitude)
                println(loc.coordinate.longitude)
                println(loc.altitude)
                println(loc.horizontalAccuracy)
                println(loc.verticalAccuracy)
                println(loc.timestamp)
                println(loc.description)
                
            } else if let err = error {
                
                println(err)
                
            }
            
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
    }

}