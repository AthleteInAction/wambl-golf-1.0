// Playground - noun: a place where people can play

import UIKit

var m: Double = 10

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

m.yd
m.yd.rd(2)