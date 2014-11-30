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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "Social"
        {
            var socialViewController = segue.destinationViewController as WebViewViewController
            
            //photoViewController.photoInfo = photoCell.photoInfo
            
            var index = self.tableView.indexPathForSelectedRow()
            var indexPath = index?.row
            
            
            let path = NSBundle.mainBundle().pathForResource("Config", ofType: "plist")
            let dict = NSDictionary(contentsOfFile: path!) as NSDictionary!
            
            var address : String = ""
            
            switch indexPath! as Int {
            case 0:
                address = dict.objectForKey("facebook") as String
            case 1:
                address = dict.objectForKey("twitter") as String
            case 2:
                address = dict.objectForKey("googlePlus") as String
            case 3:
                address = dict.objectForKey("instagram") as String
            case 4:
                address = dict.objectForKey("pinterest") as String
            case 5:
                address = dict.objectForKey("linkedin") as String
            default:
                println("This is not a valid menu")
            }

            
            socialViewController._webAddress = address as String!
        }
        
        
    }

    
    
    
    
    // MARK: - Table view data source

    // MARK: - Table View
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
//        self.performSegueWithIdentifier(items[indexPath.item].menuName, sender: indexPath)
        
       
        
        
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:MenuTableViewCell? = tableView.dequeueReusableCellWithIdentifier("Cell") as? MenuTableViewCell
        
        cell!.menuCellTitle.text = self.items[indexPath.row].menuName as String
        cell!.menuCellSubtitle.text = self.items[indexPath.row].menuSubtitle
        cell!.menuCellImage.image  = UIImage(named: items[indexPath.row].menuIcon)!
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
