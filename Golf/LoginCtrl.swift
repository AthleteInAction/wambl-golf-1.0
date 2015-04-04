//
//  LoginCtrl.swift
//  Golf
//
//  Created by Will Robinson on 4/3/15.
//  Copyright (c) 2015 Will Robinson. All rights reserved.
//

import UIKit

class LoginCtrl: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var submit: UIButton!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var signup: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        self.view.endEditing(true)
        
    }
    
    @IBAction func login(sender: UIButton){
        
        self.view.endEditing(true)
        
        if email.text != "" && password.text != "" {
            
            loader.startAnimating()
            submit.hidden = true
            signup.hidden = true
            
            PFUser.logInWithUsernameInBackground(email.text, password: password.text) {
                (user: PFUser!, error: NSError!) -> Void in
                
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
                
                self.loader.stopAnimating()
                self.submit.hidden = false
                self.signup.hidden = false
                
            }
            
        }
        
    }

    @IBAction func createAccount(sender: UIButton){
        
        self.view.endEditing(true)
        
        var vc = self.storyboard!.instantiateViewControllerWithIdentifier("signup_ctrl") as SignupCtrl
        self.presentViewController(vc, animated: true, completion: nil)
        
    }
    
}