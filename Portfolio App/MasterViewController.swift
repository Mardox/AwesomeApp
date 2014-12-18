//
//  MasterViewController.swift
//  Portfolio App
//
//  Created by Hooman Mardokhi on 14/11/2014.
//  Copyright (c) 2014 Hooman Mardokhi. All rights reserved.
//

import UIKit
import iAd

class MasterViewController: UITableViewController, GADBannerViewDelegate, GADInterstitialDelegate, ADBannerViewDelegate {
    
    
    var iAdSupported = false
    var iAdView:ADBannerView?
    var bannerView:GADBannerView?
    var interstitial:GADInterstitial?
    var timer:NSTimer?
    var loadRequestAllowed = true
    var bannerDisplayed = false
    let statusbarHeight:CGFloat = 20.0
    
    
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
            self.performSegueWithIdentifier("Video", sender: indexPath)
        }else if currentPlaylist["Type"] == "Website" {
            self.performSegueWithIdentifier("Website", sender: indexPath)
        }else if currentPlaylist["Type"] == "Gallery" {
            self.performSegueWithIdentifier("Flickr", sender: indexPath)
        }else if currentPlaylist["Type"] == "Social" {
            self.performSegueWithIdentifier("Social", sender: indexPath)
        }else if currentPlaylist["Type"] == "Radio" {
            self.performSegueWithIdentifier("Radio", sender: indexPath)
        }

        let admobActive: Bool = self.dict.objectForKey("Activate Admob") as Bool!
        if admobActive{
            interstitial = createAndLoadInterstitial()
        }
        
        
    }
    
    
    
    
    
    
    //Interstitial func
    func createAndLoadInterstitial()->GADInterstitial {
        println("createAndLoadInterstitial")
        var interstitial = GADInterstitial()
        interstitial.delegate = self
        interstitial.adUnitID = self.dict.objectForKey("Admob_Interstitial_ID") as String!
        interstitial.loadRequest(GADRequest())
        
        return interstitial
    }
    
    func presentInterstitial() {
        if let isReady = interstitial?.isReady {
            interstitial?.presentFromRootViewController(self)
        }
    }
    
    //Interstitial delegate
    func interstitial(ad: GADInterstitial!, didFailToReceiveAdWithError error: GADRequestError!) {
        println("interstitialDidFailToReceiveAdWithError:\(error.localizedDescription)")
        interstitial = createAndLoadInterstitial()
    }
    
    func interstitialDidReceiveAd(ad: GADInterstitial!) {
        println("interstitialDidReceiveAd")
    }
    
    func interstitialWillDismissScreen(ad: GADInterstitial!) {
        println("interstitialWillDismissScreen")
        interstitial = createAndLoadInterstitial()
    }
    
    func interstitialDidDismissScreen(ad: GADInterstitial!) {
        println("interstitialDidDismissScreen")
    }
    
    func interstitialWillLeaveApplication(ad: GADInterstitial!) {
        println("interstitialWillLeaveApplication")
    }
    
    func interstitialWillPresentScreen(ad: GADInterstitial!) {
        println("interstitialWillPresentScreen")
    }
    
    
    func splitViewController(svc: UISplitViewController, shouldHideViewController vc: UIViewController, inOrientation orientation: UIInterfaceOrientation) -> Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        
        var currentMenu = self.playlists[sender.row] as Dictionary
        
        if segue.identifier == "Website" {
            
            var address : String =  currentMenu["Url"] as String!
            var controller = (segue.destinationViewController as? UINavigationController)?.topViewController as WebViewViewController
            controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
            controller.navigationItem.leftItemsSupplementBackButton = true
            controller._webAddress = address as String!
            displayAd()
            
        }else if segue.identifier == "Video" {
            
            var controller = (segue.destinationViewController as? UINavigationController)?.topViewController as VideosTableViewController
            controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
            controller.navigationItem.leftItemsSupplementBackButton = true
            controller._playlistID = currentMenu["PlaylistID"] as String!
            displayAd()
            
        }else if segue.identifier == "Flickr" {
        
            var controller = (segue.destinationViewController as? UINavigationController)?.topViewController as GalleryTableViewController
            controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
            controller.navigationItem.leftItemsSupplementBackButton = true
            controller._albumID = currentMenu["AlbumID"] as String!
            controller._flickrAPIKey = self.dict.objectForKey("Flickr API Key") as String!
            displayAd()
            
        }else if segue.identifier == "Social" {

            var controller = segue.destinationViewController as? SocialTableViewController
            controller?.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
            controller?.navigationItem.leftItemsSupplementBackButton = true
           
        }else if segue.identifier == "Radio" {
            
            var controller = (segue.destinationViewController as? UINavigationController)?.topViewController as RadioViewController
            controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
            controller.navigationItem.leftItemsSupplementBackButton = true
            controller._radioUrl = currentMenu["Url"] as String!
            controller._radioTitle = currentMenu["Title"] as String!
            displayAd()
            
        }
        
        
        
    }

    
    func displayAd(){
        if AppDelegate.probabilityCalculator(){
            presentInterstitial()
        }
    }
    
    
    // MARK: - Table View
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var currentMenu = self.playlists[indexPath.row] as Dictionary
        if currentMenu["Type"] == "Video" {
            self.performSegueWithIdentifier("Video", sender: indexPath)
        }else if currentMenu["Type"] == "Website" {
                
            var address : String =  currentMenu["Url"] as String!
            
            var browser = self.dict.objectForKey("Internal WebView") as Bool!
            if (browser == true){
                self.performSegueWithIdentifier("Website", sender: indexPath)
            }else{
                var url : NSURL
                url = NSURL(string: address)!
                UIApplication.sharedApplication().openURL(url)
            }
            
        }else if currentMenu["Type"] == "Gallery" {
            self.performSegueWithIdentifier("Flickr", sender: indexPath)
        }else if currentMenu["Type"] == "Social" {
            self.performSegueWithIdentifier("Social", sender: indexPath)
        }else if currentMenu["Type"] == "Radio" {
            self.performSegueWithIdentifier("Radio", sender: indexPath)
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
        cell!.menuCellTitle.text = currentPlaylist["Title"] as String!
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
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    


}

