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
        
        var index = self.tableView.indexPathForSelectedRow()
        var indexPath = index?.row
        if indexPath == 1 {
         
            let phone = "http://facebook.com/30daylabs"
            let url:NSURL = NSURL(string:phone)!
            UIApplication.sharedApplication().openURL(url)
            
        }
        
        if segue.identifier == "Gallery" {
            
            var controller = segue.destinationViewController as? GalleryTableViewController
            controller?.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
            controller?.navigationItem.leftItemsSupplementBackButton = true
            //            }
        }else if segue.identifier == "Videos" {
            //            if let indexPath = self.menuTableView.indexPathForSelectedRow() {
            
            var controller = segue.destinationViewController as? VideosTableViewController
            controller?.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
            controller?.navigationItem.leftItemsSupplementBackButton = true
            //            }
        }else if segue.identifier == "About" {
            //            if let indexPath = self.menuTableView.indexPathForSelectedRow() {
            
            var controller = segue.destinationViewController as? AboutViewController
            controller?.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
            controller?.navigationItem.leftItemsSupplementBackButton = true
            //            }
        }else if segue.identifier == "Contact" {
            //            if let indexPath = self.menuTableView.indexPathForSelectedRow() {
            
            var controller = segue.destinationViewController as? ContactViewController
            controller?.navigationItem.leftItemsSupplementBackButton = true
            //            }
        }else if segue.identifier == "Social" {
            //            if let indexPath = self.menuTableView.indexPathForSelectedRow() {
            
            var controller = segue.destinationViewController as? SocialTableViewController
            controller?.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
            controller?.navigationItem.leftItemsSupplementBackButton = true
            //            }
        }
        
        
        
    }

    
    
    
    
    // MARK: - Table view data source

    // MARK: - Table View
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
//        self.performSegueWithIdentifier(items[indexPath.item].menuName, sender: indexPath)
        
        var address = ""
        
        switch indexPath.row {
        case 0:
            address = "http://facebook.com/30daylabs"
        case 1:
            address = "http://twitter.com/30daylabs"
        case 2:
            address = "http://google.com/30daylabs"
        case 3:
            address = "http://instagram.com/30daylabs"
        case 4:
            address = "http://linkedin.com/30daylabs"
        default:
            println("This is not a valid menu")
        }
        
        let url:NSURL = NSURL(string:address)!
        UIApplication.sharedApplication().openURL(url)
        
        
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
