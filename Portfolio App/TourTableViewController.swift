//
//  TourTableViewController.swift
//  Portfolio App
//
//  Created by Hooman Mardokhi on 29/11/2014.
//  Copyright (c) 2014 Hooman Mardokhi. All rights reserved.
//

import UIKit

class TourTableViewController: UITableViewController, UITableViewDataSource,UITableViewDelegate, UISplitViewControllerDelegate {

    
    
    private var itemList = NSMutableArray()
    let jsonFinalResult: NSDictionary!
    //var layoutType = LayoutType.Grid
    var imageCache = [String : UIImage]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.splitViewController?.delegate = self
        
        //fetch the data
        //flickrFetch()
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    func flickrFetch(){
        
        // Make the API Call
        // Flickr API Call:
        //"https://api.flickr.com/services/rest/?method=flickr.people.getPublicPhotos&api_key=a8c6c2f1a0a11a20d5a07f5f21e6924f&user_id=56378615%40N07&format=json&nojsoncallback=1"
        // getJSON(flickrAPI)
        
        //Photoset: https://api.flickr.com/services/rest/?method=flickr.photosets.getPhotos&api_key=9fa7363b8b8c32d240ee853a2857b844&photoset_id=72157628002777560&format=json&nojsoncallback=1
        
        //Show Loading
        AppDelegate.showProgressHudWithMessage("Loading...")
        
        
        var url : String = "https://api.flickr.com/services/rest/?method=flickr.photosets.getPhotos&api_key=66c04380d939320f757f730d84fb2f52&photoset_id=72157628002777560&format=json&nojsoncallback=1"
        var request : NSMutableURLRequest = NSMutableURLRequest()
        request.URL = NSURL(string: url)
        request.HTTPMethod = "GET"
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue(), completionHandler:{ (response:NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            var error: AutoreleasingUnsafeMutablePointer<NSError?> = nil
            let jsonResult: NSDictionary! = NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.MutableContainers, error: error) as? NSDictionary
            
            if (jsonResult != nil) {
                // process jsonResult
                //                println(jsonResult.objectForKey("photos")?.objectForKey("photo")?.count)
                
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
                
                self.tableView.reloadData()
                
                //Update UI in main-thread
                dispatch_async(dispatch_get_main_queue(), {
                    //Hide Loading
                    //                    AppDelegate.hideProgressHud()
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
        //        return self.itemList.count;
        return 5;
    }
    
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell : GalleryTableViewCell? = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as? GalleryTableViewCell
        
        //assign the cell data
        
        
        //        cell!.galleryCellTitle.text = self.items[indexPath.row].menuName as String
        var demoImageName = "tour-\(indexPath.row)"
        cell!.galleryCellImage.image  = UIImage(named: demoImageName)!
        cell!.galleryCellImage.contentMode = UIViewContentMode.ScaleAspectFill
        cell!.galleryCellImage.clipsToBounds = true
        return cell!;
        
        
        
        
        
        //build the image url
        // https://farm{farm-id}.staticflickr.com/{server-id}/{id}_{secret}.jpg
        
        let farm = itemList[indexPath.row]["farm"] as String!
        let server = itemList[indexPath.row]["server"] as String!
        let id = itemList[indexPath.row]["id"] as String!
        let secret = itemList[indexPath.row]["secret"] as String!
        
        // let imageURL = "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret).jpg"
        
        // Grab the artworkUrl60 key to get an image URL for the app's thumbnail
        let urlString = "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret).jpg"
        
        // Check our image cache for the existing key. This is just a dictionary of UIImages
        //var image: UIImage? = self.imageCache.valueForKey(urlString) as? UIImage
        var image = self.imageCache[urlString]
        
        
        if( image == nil ) {
            // If the image does not exist, we need to download it
            var imgURL: NSURL = NSURL(string: urlString)!
            
            // Download an NSData representation of the image at the URL
            let request: NSURLRequest = NSURLRequest(URL: imgURL)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
                if error == nil {
                    image = UIImage(data: data)
                    
                    // Store the image in to our cache
                    self.imageCache[urlString] = image
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) as? GalleryTableViewCell {
                            cellToUpdate.galleryCellImage.image = image
                            //cellToUpdate.galleryCellTitle.text = self.itemList[indexPath.row]["title"] as? String
                        }
                        AppDelegate.hideProgressHud()
                    })
                    
                    
                }
                else {
                    println("Error: \(error.localizedDescription)")
                }
            })
            
        }
        
        
        
        //        let url = NSURL(string: imageURL as NSString)!
        //        var err: NSError?
        ////        var imageData :NSData = NSData(contentsOfURL: url,options: NSDataReadingOptions.DataReadingMappedIfSafe, error: &err)!
        ////        var bgImage = UIImage(data:imageData)
        ////
        ////        cell.galleryCellImage.image = bgImage
        //
        //        cell.galleryCellImage.contentMode = UIViewContentMode.ScaleAspectFill
        //        cell.galleryCellImage.clipsToBounds = true
        //
        //        return cell;
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!)
    {
        if segue.identifier == "Image"
        {
            var photoViewController = segue.destinationViewController as GalleryItemViewController
            //photoViewController.photoInfo = photoCell.photoInfo
            
            var index = self.tableView.indexPathForSelectedRow()
            var indexPath = index?.row
            
            var imageName = "tour-\(indexPath!)"
            photoViewController._imageName = imageName as String!
        }
    }
    
}
