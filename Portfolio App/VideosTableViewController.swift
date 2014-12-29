//
//  VideosTableViewController.swift
//  Portfolio App
//
//  Created by Hooman Mardokhi on 15/11/2014.
//  Copyright (c) 2014 Hooman Mardokhi. All rights reserved.
//

import UIKit
import MediaPlayer



class VideosTableViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate, UISplitViewControllerDelegate, GADBannerViewDelegate, GADInterstitialDelegate {
    
    
    var bannerView:GADBannerView?
    var interstitial:GADInterstitial?
    
    var dict : NSDictionary!
  
    var _playlistID: AnyObject? {
        didSet {
            // Update the view.
        }
    }
    
    
    //Video Quality-Type
    enum VideoQualityType: Int {
        case Hd720 = 1,
        Medium,
        Low
    }
    
    var imageCache = [String : UIImage]()
    var searchYouTubeVideoUrlString : String = ""

    
    //Property
    private var videoList = NSMutableArray()
    private var currentPageNumber:Int = 0
    private var selectedRow:Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = NSBundle.mainBundle().pathForResource("Config", ofType: "plist")
        self.dict = NSDictionary(contentsOfFile: path!) as NSDictionary!

        // Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.splitViewController?.delegate = self
        
        interstitial = createAndLoadInterstitial()
        


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
        
        //play the video
        
        
    }
    
    func interstitialWillLeaveApplication(ad: GADInterstitial!) {
        println("interstitialWillLeaveApplication")
    }
    
    func interstitialWillPresentScreen(ad: GADInterstitial!) {
        println("interstitialWillPresentScreen")
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let playlistID = _playlistID as String!
        self.searchYouTubeVideoUrlString = "https://gdata.youtube.com/feeds/api/playlists/\(playlistID)"
        currentPageNumber=0
        videoList = NSMutableArray()
        startFetching()
    }
    
    
    func startFetching(){
        
        if AppDelegate.isConnectedToNetwork(){
            //fetch the data
            self.fetchVideoDetails()
        }else{
            AppDelegate.displayInternetError(self)
        }
        
    }
    
//    func splitViewController(svc: UISplitViewController, shouldHideViewController vc: UIViewController, inOrientation orientation: UIInterfaceOrientation) -> Bool {
//        return true
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        var totalRows : Int!
        if (videoList.count == 0) {
            totalRows = videoList.count
        }else {
            totalRows = videoList.count+1
        }
        
        //Uncomment the following for the endless scroll
//        return totalRows
        
        return videoList.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as VideoTableViewCell

        var cell : VideoTableViewCell!
        
//        if (indexPath.row < videoList.count) {
//            cell = self.youTubeListTableViewCellAtIndexPath(indexPath)
//        }else {
//            cell = self.loadMoreTableViewCellAtIndexPath(indexPath)
//        }
        
        cell = self.youTubeListTableViewCellAtIndexPath(indexPath)
        
        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    //***********************************************************************
    // YouTube ListTableViewCellAtIndexPath
    //***********************************************************************
    private func youTubeListTableViewCellAtIndexPath(indexPath:NSIndexPath) ->VideoTableViewCell
    {
        let cell : VideoTableViewCell=tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as VideoTableViewCell
        
        //Configure the cell...
        cell.videoCellImage.image = nil
        
        //detailString
        
        let detailString: NSString  = videoList[indexPath.row]["title"] as String
        cell.videoCellTitle.text = detailString
        //cell.videoCellImage.downloadImageWithUrlString(videoList[indexPath.row]["imageUrl"] as NSString)
        
        let urlString = videoList[indexPath.row]["imageUrl"] as NSString!
        var err: NSError?
        
        
        var image = self.imageCache[urlString]
        
        if( image == nil ) {
            
            // If the image does not exist, we need to download it
            var imgURL: NSURL = NSURL(string: urlString)!
            
            let request: NSURLRequest = NSURLRequest(URL: imgURL)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
                if !(error? != nil) {
                    image = UIImage(data: data)
                    // Store the image in to our cache
                    self.imageCache[urlString] = image
                    dispatch_async(dispatch_get_main_queue(), {
                        cell.videoCellImage.image = image
                        cell.loadingIndicator.hidden = true
                    })
                }
                else {
                    println("Error: \(error.localizedDescription)")
                }
            })
        
        }else {
            dispatch_async(dispatch_get_main_queue(), {
                if let cellToUpdate = self.tableView.cellForRowAtIndexPath(indexPath) as? VideoTableViewCell{
                    cellToUpdate.videoCellImage.image = image
                }
            })
        }
        
        cell.videoCellImage.contentMode = UIViewContentMode.ScaleAspectFill
        cell.videoCellImage.clipsToBounds = true
        
        return cell;
    }
    
    //***********************************************************************
    // YouTube ListTableViewCellAtIndexPath
    //***********************************************************************
    private func loadMoreTableViewCellAtIndexPath(indexPath:NSIndexPath) ->VideoTableViewCell
    {
        let cell : VideoTableViewCell=tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as VideoTableViewCell
        
        //Configure the cell...
        
        //Start-animating
//        cell.activityIndicatorView.startAnimating()
        cell.videoCellTitle.text = " Load More"
        
        //Fetch Details
        self.fetchVideoDetails()
        
        return cell;
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        var loadMoreIndex:Int = Int(videoList.count / 2)
        if indexPath.row ==  loadMoreIndex{
//            ++self.currentPageNumber
            startFetching()
        }
    }
    
    //didSelectRowAtIndexPath
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        selectedRow=indexPath.row
        
        self.playVideoWithVideoQualityType(VideoQualityType.Medium)
        
        
        //calculate the probability of the ad
        //if the ad is true then show the ad
        //if not then play the video
        
    }
    
    //***********************************************************************
    // MARK: - AlertView Action
    //***********************************************************************
    private func alertViewCancelButtonHandler(alertView: UIAlertAction!)
    {
        selectedRow = -1
    }
    private func hd720QualityButtonHandler(alertView: UIAlertAction!)
    {
        self.playVideoWithVideoQualityType(VideoQualityType.Hd720)
    }
    private func mediumQualityButtonHandler(alertView: UIAlertAction!)
    {
        self.playVideoWithVideoQualityType(VideoQualityType.Medium)
    }
    private func lowQualityButtonHandler(alertView: UIAlertAction!)
    {
        self.playVideoWithVideoQualityType(VideoQualityType.Low)
    }
    
    //***********************************************************************
    // MARK: - Play Video
    //***********************************************************************
    private func playVideoWithVideoQualityType(qualityType:VideoQualityType)
    {
        if (selectedRow >= 0) {
            let url:NSURL=NSURL(string: (videoList[selectedRow]["videoUrl"] as NSString))!
            
            HCYoutubeParser.h264videosWithYoutubeURL(url, completeBlock: { (videoFormatDictionary, error) -> Void in
                if error == nil {
                    var videoString: String?
                    var videoFormat: String!
                    switch qualityType {
                    case .Hd720:
                        videoString = videoFormatDictionary["hd720"] as AnyObject? as? String
                        videoFormat = "HD720"
                    case .Medium:
                        videoString = videoFormatDictionary["medium"] as AnyObject? as? String
                        videoFormat = "Medium"
                    case .Low:
                        videoString = videoFormatDictionary["small"] as AnyObject? as? String
                        videoFormat = "Low"
                    default:
                        println("default case excuted")
                    }
                    
                    if videoString == nil {
                        var alert = UIAlertController(title: "Error", message: "This video don't supports \(videoFormat),\n Please play the video with other formats.", preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Cancel, handler:self.alertViewCancelButtonHandler))
                        self.presentViewController(alert, animated: true, completion: nil)
                    }else {
                        //Play Video Now
                        var mediaPlayer: MPMoviePlayerViewController = MPMoviePlayerViewController(contentURL: NSURL(string: videoString!))
                        self.presentViewController(mediaPlayer, animated: true, completion: nil)
                    }
                }else {
                    var alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Cancel, handler:self.alertViewCancelButtonHandler))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            })
        }
    }
    
    
    //***********************************************************************
    // MARK: - UISearchBarDelegate
    //***********************************************************************
    
    // called when keyboard search button pressed
    func searchBarSearchButtonClicked(searchBar: UISearchBar)
    {
        currentPageNumber=0
        videoList = NSMutableArray()
        self.fetchVideoDetails()
    }
    
    
    //***********************************************************************
    // MARK: - fetchDetails For PageNumber
    //***********************************************************************
    private func fetchVideoDetails()
    {
        //Show Loading
//        AppDelegate.showProgressHudWithMessage("Loading...")
        
        var dataDictionary = Dictionary<String, AnyObject>()
        
//        dataDictionary["orderby"] = "relevance" //"published"
        dataDictionary["v"] = "2"
        dataDictionary["alt"] = "json"
        dataDictionary["max-results"] = 50 as Int
        dataDictionary["start-index"] = currentPageNumber*50+1
        //dataDictionary["q"] = "PLlPfJp10zfshCSUKAEmixkCFG7SgvY3NZ"
        
        let url:NSURL = NSURL(string: searchYouTubeVideoUrlString)!
        MR_YouTubeApiManager.sharedInstance.callWebServiceWithUrlString(url, serviceType: "GET", ServiceParameters:dataDictionary, withCompletionHandler: { (responseObject, urlResponse, error) -> Void in
            if responseObject == nil {
                //Update UI in main-thread
                dispatch_async(dispatch_get_main_queue(), {
//                    var alert = UIAlertController(title: "Error", message: "Something wrong going on.", preferredStyle: UIAlertControllerStyle.Alert)
//                    alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Cancel, handler:self.alertViewCancelButtonHandler))
//                    self.presentViewController(alert, animated: true, completion: nil)
                })
            }else {
                //Update UI in main-thread
                dispatch_async(dispatch_get_main_queue(), {
                    //Add & Reload
                    self.videoList.addObjectsFromArray(self.videoListFromJSON(responseObject as Dictionary<String, AnyObject>))
                    self.tableView.reloadData()
                })
                //+1 Page-Number
                ++self.currentPageNumber
            }
            
            //Update UI in main-thread
            dispatch_async(dispatch_get_main_queue(), {
                //Hide Loading
//                AppDelegate.hideProgressHud()
            })
        })
    }
    
    private func videoListFromJSON(json: Dictionary<String, AnyObject>) -> [Dictionary<String, String>]
    {
        var videoList = [Dictionary<String, String>]()
        
        if let feed = json["feed"] as? NSDictionary {
            if let entries = feed["entry"] as? NSArray {
                for entry in entries {
                    var dataDictionary = Dictionary<String, String>()
                    if let name = entry["title"] as? NSDictionary {
                        if let label = name["$t"] as? String {
                            dataDictionary["title"] = label
                        }
                    }
                    if let link = entry["link"] as? NSArray {
                        if let label = link[0] as? NSDictionary {
                            if let href = label["href"] as? String {
                                let videoUrl = href.stringByReplacingOccurrencesOfString("&feature=youtube_gdata", withString: "", options: nil, range: nil)
                                dataDictionary["videoUrl"] = videoUrl
                            }
                        }
                    }
                    if let mediaGroup = entry["media$group"] as? NSDictionary {
                        if let link = mediaGroup["media$thumbnail"] as? NSArray {
                            if let label = link[2] as? NSDictionary {
                                if let imageUrl = label["url"] as? String {
                                    dataDictionary["imageUrl"] = imageUrl
                                }
                            }
                        }
                    }
                    videoList.append(dataDictionary)
                }
            }
        }
        
        return videoList
    }

    
    

}
