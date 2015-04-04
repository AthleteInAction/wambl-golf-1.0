//
//  NewRoundCtrl.swift
//  Golf
//
//  Created by Will Robinson on 4/3/15.
//  Copyright (c) 2015 Will Robinson. All rights reserved.
//

import UIKit

class NewRoundCtrl: UIViewController {

    var dashboardDelegate: DashboardPTC!
    
    @IBOutlet weak var titleTxt: UITextField!
    @IBOutlet weak var course: UITextField!
    @IBOutlet weak var roundDate: UIDatePicker!
    @IBOutlet weak var submit: UIButton!
    @IBOutlet weak var cancel: UIBarButtonItem!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        self.view.endEditing(true)
        
    }

    @IBAction func createRound(sender: UIButton){
        
        self.view.endEditing(true)
        
        if titleTxt.text != "" && course.text != "" {
            
            loader.startAnimating()
            submit.hidden = true
            
            var round = PFObject(className:"Rounds")
            
            round["title"] = titleTxt.text
            round["course"] = course.text
            round["date"] = roundDate.date as NSDate
            round["user"] = PFUser.currentUser()
            round["pars"] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
            
            round.saveInBackgroundWithBlock {
                (success: Bool, error: NSError!) -> Void in
                
                if (success) {
                    
                    self.dashboardDelegate.addRound(round)
                    
                    self.dismissViewControllerAnimated(true, completion: nil)
                    
                } else {
                    
                    var code = error.userInfo?["code"] as Int
                    
                    Error.report(user: nil, error: error, alert: true)
                    
                }
                
                self.loader.stopAnimating()
                self.submit.hidden = false
                
            }
            
        }
        
    }
    
    @IBAction func cancelRound(sender: UIBarButtonItem){
        
        self.view.endEditing(true)
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func dateChanged(sender: UIDatePicker){
        
        self.view.endEditing(true)
        
    }
    
}