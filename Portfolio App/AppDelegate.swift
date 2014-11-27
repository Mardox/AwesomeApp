//
//  AppDelegate.swift
//  Portfolio App
//
//  Created by Hooman Mardokhi on 14/11/2014.
//  Copyright (c) 2014 Hooman Mardokhi. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?
    var progressHud: MBProgressHUD?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        let splitViewController = self.window!.rootViewController as? UISplitViewController
        let navigationController = splitViewController?.viewControllers[splitViewController!.viewControllers.count-1] as? UINavigationController
        navigationController?.topViewController.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem()
        splitViewController?.delegate = self
        
        
        // let path = NSBundle.mainBundle().pathForResource("Config", ofType: "plist")
        // let dict = NSDictionary(contentsOfFile: path!) as NSDictionary!
        
        var navigationBarAppearace = UINavigationBar.appearance()
        
        navigationBarAppearace.tintColor = UIColor.whiteColor()
        navigationBarAppearace.barTintColor = UIColor(red: 0.2, green: 0.2, blue: 0.5, alpha: 1.0)
        navigationBarAppearace.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
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

    // MARK: - Split view

    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController:UIViewController!, ontoPrimaryViewController primaryViewController:UIViewController!) -> Bool {
        if let secondaryAsNavController = secondaryViewController as? UINavigationController {
            if let topAsDetailController = secondaryAsNavController.topViewController as? GalleryTableViewController {
                //if topAsDetailController.detailItem == nil {
                    // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
//                    return fasle
                //}
            }
        }
        return true
    }
    
    //Instance
    private class func instance() -> AppDelegate{
        return UIApplication.sharedApplication().delegate as AppDelegate
    }

    
    
    //Useful to show Progress-HUD
    class func showProgressHudWithMessage(message:String) {
        AppDelegate.instance().showProgressHudWithMessage(message)
    }
    
    private func showProgressHudWithMessage(message:String) {
        if progressHud != nil {
            self.hideProgressHud()
        }
        progressHud = MBProgressHUD(window: self.window)
        self.window?.addSubview(progressHud!)
        progressHud?.labelText = message
        //Show Now
        progressHud?.show(true)
    }
    
    //Useful to Hide Progress-HUD
    class func hideProgressHud() {
        AppDelegate.instance().hideProgressHud()
    }
    
    private func hideProgressHud() {
        progressHud?.removeFromSuperview()
        progressHud = nil
    }


}

