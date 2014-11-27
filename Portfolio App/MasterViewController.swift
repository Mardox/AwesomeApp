//
//  MasterViewController.swift
//  Portfolio App
//
//  Created by Hooman Mardokhi on 14/11/2014.
//  Copyright (c) 2014 Hooman Mardokhi. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController, UISplitViewControllerDelegate {
    
    
    let items = [
        MenuItem(menuName: "Gallery", menuIcon: "Gallery", menuSubtitle: "Have a look at our portfolio and get to know our work"),
        MenuItem(menuName: "Poses", menuIcon: "Gallery", menuSubtitle: "Some of the beautiful and poses we suggest"),
        MenuItem(menuName: "Videos", menuIcon: "Videos", menuSubtitle: "Check out our videos and get a taste of what we can do for you!"),
        MenuItem(menuName: "About", menuIcon: "About", menuSubtitle: "All about who we are and what we can do for you"),
        MenuItem(menuName: "Contact", menuIcon: "Contact", menuSubtitle: "Get in touch! We know that we can give you the best service"),
        MenuItem(menuName: "Social", menuIcon: "Social", menuSubtitle: "Follow us for the latest news and awesomeness"),
    ]


    var detailViewController: GalleryTableViewController? = nil
   // var objects = NSMutableArray()


    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.clearsSelectionOnViewWillAppear = false
            self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //self.navigationItem.leftBarButtonItem = self.editButtonItem()

//        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
//        self.navigationItem.rightBarButtonItem = addButton
//        if let split = self.splitViewController {
//            let controllers = split.viewControllers
//            self.detailViewController = controllers[controllers.count-1].topViewController as? GalleryTableViewController
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//    func insertNewObject(sender: AnyObject) {
//        objects.insertObject(NSDate(), atIndex: 0)
//        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
//        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
//    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "showDetail" {
//            if let indexPath = self.tableView.indexPathForSelectedRow() {
//                let object = objects[indexPath.row] as NSDate
//                let controller = (segue.destinationViewController as UINavigationController).topViewController as DetailViewController
//                controller.detailItem = object
//                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
//                controller.navigationItem.leftItemsSupplementBackButton = true
//            }
//        }
        
        
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

    // MARK: - Table View
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier(items[indexPath.item].menuName, sender: indexPath)
        
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

