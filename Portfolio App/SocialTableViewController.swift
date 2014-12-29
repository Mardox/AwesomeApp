//
//  SocialTableViewController.swift
//  Portfolio App
//
//  Created by Hooman Mardokhi on 15/11/2014.
//  Copyright (c) 2014 Hooman Mardokhi. All rights reserved.
//

import UIKit

class SocialTableViewController: UITableViewController {

    
    let items = [
        MenuItem(menuName: "Facebook", menuIcon: "Facebook", menuSubtitle: "Like us on Facebook"),
        MenuItem(menuName: "Twitter", menuIcon: "Twitter", menuSubtitle: "Follow us on Twitter"),
        MenuItem(menuName: "Google", menuIcon: "Google", menuSubtitle: "Find us on Google+"),
        MenuItem(menuName: "Instagram", menuIcon: "Instagram", menuSubtitle: "Follow us on Instagram"),
        MenuItem(menuName: "Pinterest", menuIcon: "Pinterest", menuSubtitle: "Checkout our pins on Pinterest"),
        MenuItem(menuName: "LinkedIn", menuIcon: "LinkedIn", menuSubtitle: "Join our professional network"),
    ]
    
    var dict : NSDictionary!
    var menus: [Dictionary<String, String>] = []
    var menuDetails = [String: String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Load up the social
        let path = NSBundle.mainBundle().pathForResource("Config", ofType: "plist")
        self.dict = NSDictionary(contentsOfFile: path!) as NSDictionary!
        let title: String = dict.objectForKey("appName") as String!
        self.menus = dict.objectForKey("Social Menu") as Array<Dictionary<String, String>>

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //    func splitViewController(svc: UISplitViewController, shouldHideViewController vc: UIViewController, inOrientation orientation: UIInterfaceOrientation) -> Bool {
    //        return false
    //    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "Social"
        {
            
            var index = self.tableView.indexPathForSelectedRow()
            var indexPath = index?.row
            
            var address : String = ""
            
            var currentMenu = menus[indexPath!] as Dictionary
            address = currentMenu["Url"] as String!
            
            var browser = self.dict.objectForKey("Internal WebView") as Bool!
            if (browser == true){
                var socialViewController = (segue.destinationViewController as? UINavigationController)?.topViewController as WebViewViewController
                socialViewController.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                socialViewController.navigationItem.leftItemsSupplementBackButton = true
                socialViewController._webAddress = address as String!
            }else{
                var url : NSURL
                url = NSURL(string: address)!
                UIApplication.sharedApplication().openURL(url)
            }
            
        }
        
        
    }

    
    
    
    
    // MARK: - Table view data source

    // MARK: - Table View
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var currentMenu = self.menus[indexPath.row] as Dictionary

        var address : String =  currentMenu["Url"] as String!
        var browser = self.dict.objectForKey("Internal WebView") as Bool!

        if (browser == true){
            self.performSegueWithIdentifier("Social", sender: indexPath)
        }else{
            var url : NSURL
            url = NSURL(string: address)!
            UIApplication.sharedApplication().openURL(url)
        }
    
    
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        var cell:MenuTableViewCell? = tableView.dequeueReusableCellWithIdentifier("Cell") as? MenuTableViewCell
        
        var currentMenu = menus[indexPath.row] as Dictionary
        cell!.menuCellTitle.text = currentMenu["Title"] as String!
        cell!.menuCellSubtitle.text = currentMenu["Subtitle"]
        cell!.menuCellImage.image  = UIImage(named: currentMenu["Icon"] as String!)!
        return cell!;
        
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            //objects.removeObjectAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    

}
