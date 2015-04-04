//
//  AppDelegate.swift
//  Golf
//
//  Created by Will Robinson on 4/3/15.
//  Copyright (c) 2015 Will Robinson. All rights reserved.
//

import UIKit

var root: UIWindow!

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // Override point for customization after application launch.
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        root = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        Parse.setApplicationId("ZLIHKPqBIVc18EXt6c2yk7Ex8iFWoKcBgwD1JjNy", clientKey: "T0OekrIYHvmeCH1ksbdwanFfWENxy3hTvsFig61y")
        
        if PFUser.currentUser() != nil {
            
            // USER IS LOGGED IN
            var newStoryboard = UIStoryboard(name: "WamblIn", bundle: nil)
            var vc = newStoryboard.instantiateViewControllerWithIdentifier("dashboard_ctrl") as DashboardCtrl
            var nav = UINavigationController(rootViewController: vc)
            root.rootViewController = nav
            
        } else {
            
            // USER IS LOGGED OUT
            var newStoryboard = UIStoryboard(name: "WamblOut", bundle: nil)
            var vc = newStoryboard.instantiateViewControllerWithIdentifier("login_ctrl") as LoginCtrl
            root.rootViewController = vc
            
        }
        
        root.makeKeyAndVisible()
        
        return true
        
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}
