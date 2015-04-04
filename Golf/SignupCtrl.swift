//
//  SignupCtrl.swift
//  Golf
//
//  Created by Will Robinson on 4/3/15.
//  Copyright (c) 2015 Will Robinson. All rights reserved.
//

import UIKit

class SignupCtrl: UIViewController {

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var submit: UIButton!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var cancel: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        self.view.endEditing(true)
        
    }
    
    @IBAction func signup(sender: AnyObject){
        
        self.view.endEditing(true)
        
        if name.text != "" && email.text != "" && password.text != "" {
            
            loader.startAnimating()
            submit.hidden = true
            cancel.hidden = true
            
            var user = PFUser()
            
            user.username = email.text
            user.password = password.text
            user.email = email.text
            user["name"] = name.text
            
            user.signUpInBackgroundWithBlock {
                (succeeded: Bool!, error: NSError!) -> Void in
                
                if !(error != nil) {
                    
                    var newWindow = UIWindow(frame: UIScreen.mainScreen().bounds)
                    
                    var newStoryboard = UIStoryboard(name: "WamblIn", bundle: nil)
                    var vc = newStoryboard.instantiateViewControllerWithIdentifier("dashboard_ctrl") as DashboardCtrl
                    var nav = UINavigationController(rootViewController: vc)
                    newWindow.rootViewController = nav
                    newWindow.makeKeyAndVisible()
                    
                    root = newWindow
                    
                } else {
                    
                    var code = error.userInfo?["code"] as Int
                    
                    Error.report(user: nil, error: error, alert: true)
                    
                }
                
                self.loader.startAnimating()
                self.submit.hidden = false
                self.cancel.hidden = false
                
            }
            
        }
        
    }

    @IBAction func login(sender: UIButton){
        
        self.view.endEditing(true)
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
}
