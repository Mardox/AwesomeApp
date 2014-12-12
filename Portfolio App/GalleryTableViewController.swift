//
//  GalleryTableViewController.swift
//  Portfolio App
//
//  Created by Hooman Mardokhi on 15/11/2014.
//  Copyright (c) 2014 Hooman Mardokhi. All rights reserved.
//

import UIKit

class GalleryTableViewController: UITableViewController, UITableViewDataSource,UITableViewDelegate, UISplitViewControllerDelegate  {

    
    var _albumID: AnyObject? {
        didSet {
            // Update the view.
        }
    }
    
    
    private var itemList = NSMutableArray()
    let jsonFinalResult: NSDictionary!
    //var layoutType = LayoutType.Grid
    var imageCache = [String : UIImage]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.splitViewController?.delegate = self
        
        //fetch the data
        flickrFetch()
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
//    func splitViewController(svc: UISplitViewController, shouldHideViewController vc: UIViewController, inOrientation orientation: UIInterfaceOrientation) -> Bool {
//        return false
//    }
    
    
    func flickrFetch(){
        
        // Make the API Call
        // Flickr API Call: 

        let GalleryFlickrPhotosetID: String = self._albumID as String!
        
        
        var url : String = "https://api.flickr.com/services/rest/?method=flickr.photosets.getPhotos&api_key=66c04380d939320f757f730d84fb2f52&photoset_id=\(GalleryFlickrPhotosetID)&format=json&nojsoncallback=1"
        var request : NSMutableURLRequest = NSMutableURLRequest()
        request.URL = NSURL(string: url)
        request.HTTPMethod = "GET"
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue(), completionHandler:{ (response:NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            var error: AutoreleasingUnsafeMutablePointer<NSError?> = nil
            let jsonResult: NSDictionary! = NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.MutableContainers, error: error) as? NSDictionary
            
            if (jsonResult != nil) {
                
                var dataDictionary = Dictionary<String, String>()
                
                var index: Int
                for index = 0; index < jsonResult.objectForKey("photoset")?.objectForKey("photo")?.count; ++index {
                    dataDictionary["farm"] = String(jsonResult.objectForKey("photoset")?.objectForKey("photo")?.objectAtIndex(index).objectForKey("farm") as Int)
                    dataDictionary["id"] = jsonResult.objectForKey("photoset")?.objectForKey("photo")?.objectAtIndex(index).objectForKey("id") as? String
                    dataDictionary["owner"] = jsonResult.objectForKey("photoset")?.objectForKey("photo")?.objectAtIndex(index).objectForKey("owner") as? String
                    dataDictionary["secret"] = jsonResult.objectForKey("photoset")?.objectForKey("photo")?.objectAtIndex(index).objectForKey("secret") as? String
                    dataDictionary["server"] = jsonResult.objectForKey("photoset")?.objectForKey("photo")?.objectAtIndex(index).objectForKey("server") as? String
                    dataDictionary["title"] = jsonResult.objectForKey("photoset")?.objectForKey("photo")?.objectAtIndex(index).objectForKey("title") as? String
                    self.itemList.addObject(dataDictionary)
                }
                
                //Update UI in main-thread
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                })

                
            } else {
                // couldn't load JSON, look at error
            }
            
            
        })

        // Refresh the tableview
        
    }
    
    
    func getJSON(urlToRequest: String) -> NSData{
        return NSData(contentsOfURL: NSURL(string: urlToRequest)!)!
    }
    
    func parseJSON(inputData: NSData) -> NSDictionary{
        var error: NSError?
        var boardsDictionary: NSDictionary = NSJSONSerialization.JSONObjectWithData(inputData, options: NSJSONReadingOptions.MutableContainers, error: &error) as NSDictionary
        
        return boardsDictionary
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("Image", sender: indexPath)
        
    }

    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemList.count;
//        return 10;
    }
    
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       
        let cell : GalleryTableViewCell? = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as? GalleryTableViewCell
        
        //assign the cell data

        
        cell!.galleryCellImage.image = nil
        cell!.galleryCellImage.contentMode = UIViewContentMode.ScaleAspectFill
        cell!.galleryCellImage.clipsToBounds = true
        
        
        //build the image url
        // https://farm{farm-id}.staticflickr.com/{server-id}/{id}_{secret}.jpg
        
        let farm = itemList[indexPath.row]["farm"] as String!
        let server = itemList[indexPath.row]["server"] as String!
        let id = itemList[indexPath.row]["id"] as String!
        let secret = itemList[indexPath.row]["secret"] as String!
        
        let urlString = "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret).jpg"
      
        
        
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
                        cell!.galleryCellImage.image = image
                        cell!.loadingIndicator.hidden=true
                    })
                }
                else {
                    println("Error: \(error.localizedDescription)")
                }
            })
            
        }else {
            dispatch_async(dispatch_get_main_queue(), {
                if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) as? GalleryTableViewCell{
                    cellToUpdate.galleryCellImage.image = image
                }
            })
        }
        
        return cell!;
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!)
    {
        if segue.identifier == "Image"
        {
            var photoViewController = segue.destinationViewController as GalleryItemViewController
            
            var index = self.tableView.indexPathForSelectedRow()
            var indexPath = index?.row
            
            let farm = itemList[indexPath!]["farm"] as String!
            let server = itemList[indexPath!]["server"] as String!
            let id = itemList[indexPath!]["id"] as String!
            let secret = itemList[indexPath!]["secret"] as String!
            
            let imageUrl = "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret).jpg"
            photoViewController._imageUrl = imageUrl as String!
            
        }
    }
    
    
    
    
}
