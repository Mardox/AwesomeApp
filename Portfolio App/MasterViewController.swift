//
//  MasterViewController.swift
//  Portfolio App
//
//  Created by Hooman Mardokhi on 14/11/2014.
//  Copyright (c) 2014 Hooman Mardokhi. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {
    
    var dict : NSDictionary!
    
    var playlists: [Dictionary<String, String>] = []
    var playlistDetails = [String: String]()


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
        
        var appName : String
        
        let path = NSBundle.mainBundle().pathForResource("Config", ofType: "plist")
        self.dict = NSDictionary(contentsOfFile: path!) as NSDictionary!
        
        let title: String = dict.objectForKey("appName") as String!
        
        self.title = title

        self.playlists = dict.objectForKey("Menu") as Array<Dictionary<String, String>>
        
        
        //Load the first detail view in the plist
        var currentPlaylist = self.playlists[0] as Dictionary
        var indexPath : NSIndexPath =  NSIndexPath(forRow: 0, inSection: 0)
        if currentPlaylist["Type"] == "Video" {
            self.performSegueWithIdentifier("Videos", sender: indexPath)
        }else if currentPlaylist["Type"] == "Website" {
            self.performSegueWithIdentifier("Website", sender: indexPath)
        }else if currentPlaylist["Type"] == "Flickr" {
            self.performSegueWithIdentifier("Gallery", sender: indexPath)
        }

        
    }
    
//    func splitViewController(svc: UISplitViewController, shouldHideViewController vc: UIViewController, inOrientation orientation: UIInterfaceOrientation) -> Bool {
//        return false
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        
        var currentMenu = self.playlists[sender.row] as Dictionary
        
        if segue.identifier == "Website" {
            
            var controller = (segue.destinationViewController as? UINavigationController)?.topViewController as WebViewViewController
            controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
            controller.navigationItem.leftItemsSupplementBackButton = true
            controller._webAddress = currentMenu["Url"] as String!
            
        }else if segue.identifier == "Videos" {
            
            var controller = (segue.destinationViewController as? UINavigationController)?.topViewController as VideosTableViewController
            controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
            controller.navigationItem.leftItemsSupplementBackButton = true
            controller._playlistID = currentMenu["PlaylistID"] as String!
            
        }else if segue.identifier == "Gallery" {
        
            var controller = (segue.destinationViewController as? UINavigationController)?.topViewController as GalleryTableViewController
            controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
            controller.navigationItem.leftItemsSupplementBackButton = true
            controller._albumID = currentMenu["AlbumID"] as String!
        
        }
        
        
//        
//        if segue.identifier == "Gallery" {
//            
//            var controller = segue.destinationViewController as? GalleryTableViewController
//            controller?.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
//            controller?.navigationItem.leftItemsSupplementBackButton = true
//
//        }else if segue.identifier == "About" {
//           
//            var controller = segue.destinationViewController as? AboutViewController
//            controller?.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
//            controller?.navigationItem.leftItemsSupplementBackButton = true
//          
//        }else if segue.identifier == "Contact" {
//            
//            var controller = segue.destinationViewController as? ContactViewController
//            controller?.navigationItem.leftItemsSupplementBackButton = true
//           
//        }else if segue.identifier == "Social" {
//           
//            var controller = segue.destinationViewController as? SocialTableViewController
//            controller?.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
//            controller?.navigationItem.leftItemsSupplementBackButton = true
//           
//        }else if segue.identifier == "Login" {
//            
//            var controller = segue.destinationViewController as? WebViewViewController
//            controller?.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
//            controller?.navigationItem.leftItemsSupplementBackButton = true
//            controller?._webAddress = dict.objectForKey("LoginAddress") as String!
//
//        }
//        
        
        
    }

    // MARK: - Table View
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var currentPlaylist = self.playlists[indexPath.row] as Dictionary
        if currentPlaylist["Type"] == "Video" {
            self.performSegueWithIdentifier("Videos", sender: indexPath)
        }else if currentPlaylist["Type"] == "Website" {
            self.performSegueWithIdentifier("Website", sender: indexPath)
        }else if currentPlaylist["Type"] == "Flickr" {
            self.performSegueWithIdentifier("Gallery", sender: indexPath)
        }
        
        
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlists.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:MenuTableViewCell? = tableView.dequeueReusableCellWithIdentifier("Cell") as? MenuTableViewCell
        
        var currentPlaylist = playlists[indexPath.row] as Dictionary
//        let menuNames = [String](playlists.keys)
        
        cell!.menuCellTitle.text = currentPlaylist["Title"] as String!
        
//        cell!.menuCellTitle.text = dict.objectForKey(self.items[indexPath.row].menuName) as? String
        cell!.menuCellSubtitle.text = currentPlaylist["Subtitle"]
        cell!.menuCellImage.image  = UIImage(named: currentPlaylist["Icon"] as String!)!
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

