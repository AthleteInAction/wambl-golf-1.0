//
//  MapLoaderCtrl.swift
//  Golf
//
//  Created by Will Robinson on 4/5/15.
//  Copyright (c) 2015 Will Robinson. All rights reserved.
//

import UIKit
import MapKit

class MapLoaderCtrl: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var map: MKMapView!
    
    var strokes: [CLLocation]!
    var annotations: [MKAnnotation] = []
    var ready: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        map.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        ready = true
        
    }
    
    func setData(){
        
        if ready {
            
            for stroke in strokes {
                
                var annotation = MKPointAnnotation()
                annotation.setCoordinate(stroke.coordinate)
                annotations.append(annotation)
                
                map.addAnnotation(annotations.last)
                
            }
            
            map.showAnnotations(annotations, animated: true)
            
        }
        
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        
        if overlay is MKCircle {
            
            var circle = MKCircleRenderer(overlay: overlay)
            
            circle.strokeColor = UIColor.redColor()
            circle.fillColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.1)
            circle.lineWidth = 1
            
            return circle
            
        } else {
            
            return nil
            
        }
        
    }

}
