//
//  RSSTableViewController.swift
//  Portfolio App
//
//  Created by Hooman Mardokhi on 18/12/2014.
//  Copyright (c) 2014 Hooman Mardokhi. All rights reserved.
//

import UIKit

class RSSTableViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate, NSXMLParserDelegate {
    
    var myFeed : NSArray = []
    var url: NSURL = NSURL()
    var dict : NSDictionary!
    var _RSSUrl : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Cell height.
        self.tableView.rowHeight = 70
        self.tableView.dataSource = self
        self.tableView.delegate = self
       
        
        //Load up the social
        let path = NSBundle.mainBundle().pathForResource("Config", ofType: "plist")
        self.dict = NSDictionary(contentsOfFile: path!) as NSDictionary!
        
        // Set feed url. http://www.formula1.com/rss/news/latest.rss
        url = NSURL(string: _RSSUrl)!
        // Call custom function.
        
       startFetching()
        
    }
    
    
    //Start fetching the rss feed and do the internet connection test
    func startFetching(){
        
        if AppDelegate.isConnectedToNetwork(){
            //fetch the data
            loadRss(url);
        }else{
            AppDelegate.displayInternetError(self)
        }
        
    }
    
    
    
    func loadRss(data: NSURL) {
        // XmlParserManager instance/object/variable
        var myParser : XmlParserManager = XmlParserManager.alloc().initWithURL(data) as XmlParserManager
        // Put feed in array
        myFeed = myParser.feeds
        tableView.reloadData()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        var index = self.tableView.indexPathForSelectedRow()
        var indexPath = index?.row
        
        if segue.identifier == "Webpage" {
            
            var address = myFeed.objectAtIndex(indexPath!).objectForKey("link") as String!
            
            var browser = self.dict.objectForKey("Internal WebView") as Bool!
            
            if (browser == true){
                
                
                var controller = (segue.destinationViewController as? UINavigationController)?.topViewController as WebViewViewController
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
                controller._webAddress = address as String!
                
                
            }else{
            
                
                var url : NSURL
                url = NSURL(string: address)!
                UIApplication.sharedApplication().openURL(url)
            
            
            }
            
        }
        

    }
    
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.performSegueWithIdentifier("Webpage", sender: indexPath)
//        
//        var currentMenu = self.menus[indexPath.row] as Dictionary
//        
//        var address : String =  currentMenu["Url"] as String!
//        var browser = self.dict.objectForKey("Internal WebView") as Bool!
//        
//        if (browser == true){
//            self.performSegueWithIdentifier("Social", sender: indexPath)
//        }else{
//            var url : NSURL
//            url = NSURL(string: address)!
//            UIApplication.sharedApplication().openURL(url)
//        }
        
        
    }

    
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myFeed.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        var title : String = myFeed.objectAtIndex(indexPath.row).objectForKey("title") as String
        
        var cell:RSSTableViewCell? = tableView.dequeueReusableCellWithIdentifier("Cell") as? RSSTableViewCell
        
        cell!.rssCellTitle.text = myFeed.objectAtIndex(indexPath.row).objectForKey("title") as? String
        cell!.rssCellSubTitle.text = myFeed.objectAtIndex(indexPath.row).objectForKey("pubDate") as? String
        
        cell!.rssCellFirstLetter.textColor = getRandomColor()
        cell!.rssCellFirstLetter.text = title.substringToIndex(advance(title.startIndex, 1))
//            substringToIndex(advance(title.startIndex, 1))
        
        cell!.rssCellImage.contentMode = UIViewContentMode.ScaleAspectFill
        cell!.rssCellImage.clipsToBounds = true
//        cell!.rssCellImage.image  = UIImage(named: currentMenu["Icon"] as String!)!
        return cell!;
        
//        
//        let cell = tableView.dequeueReusableCellWithIdentifier("Standard", forIndexPath: indexPath) as UITableViewCell
//    
//        var dict : NSDictionary! = myFeed.objectAtIndex(indexPath.row) as NSDictionary
//        cell.textLabel?.text = myFeed.objectAtIndex(indexPath.row).objectForKey("title") as? String
//        cell.detailTextLabel?.text = myFeed.objectAtIndex(indexPath.row).objectForKey("pubDate") as? String
//        return cell
//        
    }
    
    
    func getRandomColor() -> UIColor{
        
        var randomRed:CGFloat = CGFloat(drand48())
        
        var randomGreen:CGFloat = CGFloat(drand48())
        
        var randomBlue:CGFloat = CGFloat(drand48())
        
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
        
    }
    
    
    
    
    
    
}
