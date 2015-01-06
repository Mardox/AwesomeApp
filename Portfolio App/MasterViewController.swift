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
    
    var menuContent: [Dictionary<String, String>]? = []
    var playlistDetails = [String: String]()

    var detailViewController: GalleryTableViewController? = nil
   // var objects = NSMutableArray()
    
    
    var fireBaseContent: FDataSnapshot?
    var firebaseMenuContent: FDataSnapshot?
    var currentM = NSArray()


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
        
        
        if self.currentM.count > 0 {
            
            //Menu values are already set - this is a sub menu
            var tempMainContent : NSDictionary = self.currentM[0] as NSDictionary
            self.currentM = tempMainContent.valueForKey("Menu") as NSArray
            //self.menuContent = tempMainContent[0].objectForKey("Menu") as? Array<Dictionary<String, String>>
            
            
        }else{
            
            //Load the menu values
            
            //from firebase
            var myRootRef = Firebase(url:"https://awesome-app.firebaseio.com/")
            
            //myRootRef.setValue("Do you have data? You'll love Firebase now.")
            // Read data and react to changes
            myRootRef.observeEventType(.Value, withBlock: {
                snapshot in
                
                self.fireBaseContent = snapshot as FDataSnapshot
                let title: String = self.fireBaseContent?.value.objectForKey("title") as String
                //println(self.fireBaseContent?.value.objectForKey("Menu"))
                self.currentM = [snapshot.value]
                self.currentM = self.currentM.valueForKey("Menu") as NSArray
                self.currentM = self.currentM[0] as NSArray
                self.menuContent = self.fireBaseContent!.value.objectForKey("Menu") as? Array<Dictionary<String, String>>
                self.title = title
                self.tableView.reloadData()
                
                self.title = title
                
                //Load the first detail view in the plist
                var currentPlaylist = self.currentM[0] as NSDictionary
                var indexPath : NSIndexPath =  NSIndexPath(forRow: 0, inSection: 0)
                if currentPlaylist.valueForKey("Type") as String == "Video" {
                    self.performSegueWithIdentifier("Video", sender: indexPath)
                }else if currentPlaylist.valueForKey("Type") as String == "Website" {
                    self.performSegueWithIdentifier("Website", sender: indexPath)
                }else if currentPlaylist.valueForKey("Type") as String == "Gallery" {
                    self.performSegueWithIdentifier("Flickr", sender: indexPath)
                }else if currentPlaylist.valueForKey("Type") as String == "Social" {
                    self.performSegueWithIdentifier("Social", sender: indexPath)
                }else if currentPlaylist.valueForKey("Type") as String == "Radio" {
                    self.performSegueWithIdentifier("Radio", sender: indexPath)
                }else if currentPlaylist.valueForKey("Type") as String == "RSS" {
                    self.performSegueWithIdentifier("RSS", sender: indexPath)
                }else if currentPlaylist.valueForKey("Type") as String == "Menu" {
                    self.performSegueWithIdentifier("Menu", sender: indexPath)
                }
                
                let admobActive: Bool = self.dict.objectForKey("Activate Admob") as Bool!
                if admobActive{
                    self.interstitial = self.createAndLoadInterstitial()
                }

                
            })
            
            //From Config
            //self.menuContent = dict.objectForKey("Menu") as? Array<Dictionary<String, String>>
        }
        
        //let title: String = dict.objectForKey("appName") as String!
        
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
        
        var currentMenu = self.currentM[sender.row] as NSDictionary
        //var currentMenu: Array = self.currentM[sender.row] as NSMutableArray
        
        if segue.identifier == "Website" {
            
            var address : String =  currentMenu.valueForKey("Url") as String!
            var controller = (segue.destinationViewController as? UINavigationController)?.topViewController as WebViewViewController
            controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
            controller.navigationItem.leftItemsSupplementBackButton = true
            controller._webAddress = address as String!
            displayAd()
            
        }else if segue.identifier == "Video" {
            
            var controller = (segue.destinationViewController as? UINavigationController)?.topViewController as VideosTableViewController
            controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
            controller.navigationItem.leftItemsSupplementBackButton = true
            controller._playlistID = currentMenu.valueForKey("PlaylistID") as String!
            displayAd()
            
        }else if segue.identifier == "Flickr" {
        
            var controller = (segue.destinationViewController as? UINavigationController)?.topViewController as GalleryTableViewController
            controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
            controller.navigationItem.leftItemsSupplementBackButton = true
            controller._albumID = currentMenu.valueForKey("AlbumID") as String!
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
            controller._radioUrl = currentMenu.valueForKey("Url") as String!
            controller._radioTitle = currentMenu.valueForKey("Title") as String!
            displayAd()
            
        }else if segue.identifier == "RSS" {
            
            var controller = (segue.destinationViewController as? UINavigationController)?.topViewController as RSSTableViewController
            controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
            controller.navigationItem.leftItemsSupplementBackButton = true
            controller._RSSUrl = currentMenu.valueForKey("Url") as String!
            displayAd()
            
        }else if segue.identifier == "Menu" {
            
            var controller = segue.destinationViewController as MasterViewController
            controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
            controller.navigationItem.leftItemsSupplementBackButton = true
            controller.currentM =  [self.currentM[sender.row]] as NSArray
        }
        
        
        
    }

    
    func displayAd(){
        if AppDelegate.probabilityCalculator(){
            presentInterstitial()
        }
    }
    
    
    // MARK: - Table View
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var currentMenu = self.currentM[indexPath.row] as NSDictionary
        
        println("IndexPath: \(indexPath.row)")
        if currentMenu.valueForKey("Type") as String == "Video" {
            self.performSegueWithIdentifier("Video", sender: indexPath)
        }else if currentMenu.valueForKey("Type") as String == "Website" {
                
            var address : String =  currentMenu.valueForKey("Url") as String!
            
            var browser = self.dict.objectForKey("Internal WebView") as Bool!
            if (browser == true){
                self.performSegueWithIdentifier("Website", sender: indexPath)
            }else{
                var url : NSURL
                url = NSURL(string: address)!
                UIApplication.sharedApplication().openURL(url)
            }
            
        }else if currentMenu.valueForKey("Type") as String == "Gallery" {
            self.performSegueWithIdentifier("Flickr", sender: indexPath)
        }else if currentMenu.valueForKey("Type") as String == "Social" {
            self.performSegueWithIdentifier("Social", sender: indexPath)
        }else if currentMenu.valueForKey("Type") as String == "Radio" {
            self.performSegueWithIdentifier("Radio", sender: indexPath)
        }else if currentMenu.valueForKey("Type") as String == "RSS" {
            self.performSegueWithIdentifier("RSS", sender: indexPath)
        }else if currentMenu.valueForKey("Type") as String == "Menu" {
            self.performSegueWithIdentifier("Menu", sender: indexPath)
        }
        
        
        
        
        
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentM.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:MenuTableViewCell? = tableView.dequeueReusableCellWithIdentifier("Cell") as? MenuTableViewCell
        
        var currentPlaylist = self.currentM[indexPath.row] as NSDictionary
        cell!.menuCellTitle.text = currentPlaylist.valueForKey("Title") as String!
        cell!.menuCellSubtitle.text = currentPlaylist.valueForKey("Subtitle") as String!
        
        
        
        
        //let decodedData = NSData(base64EncodedString: currentPlaylist.valueForKey("Icon") as String!, options: NSDataBase64DecodingOptions(rawValue: 0)!)
        var data = currentPlaylist.valueForKey("Icon") as String!
        var decodedData = NSData(base64EncodedString: data, options: NSDataBase64DecodingOptions(rawValue: 0))
        var decodedimage = UIImage(data: decodedData!)
        //println(decodedimage)
        cell!.menuCellImage.image = decodedimage as UIImage!
        
        
        
        //cell!.menuCellImage.image  = UIImage(named: currentPlaylist.valueForKey("Icon") as String!)!
        
        
        
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

