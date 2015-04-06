extension Double {
    
    var yd: Double {
        
        return self * 1.09361
        
    }
    
    func rd(places: Int) -> Double {
        
        let multiplier = pow(Double(10),Double(places))
        
        let rounded = round(Double(self * multiplier)) / multiplier
        
        return rounded
        
    }
    
}



extension PFGeoPoint {
    
    var location: CLLocation {
        
        let l = CLLocation(latitude: (self.latitude as CLLocationDegrees), longitude: (self.longitude as CLLocationDegrees))
        
        return l
        
    }
    
}

extension CLLocation {
    
    var pfgeopoint: PFGeoPoint {
        
        let l = PFGeoPoint(latitude: self.coordinate.latitude, longitude: self.coordinate.longitude)
        
        return l
        
    }
    
}