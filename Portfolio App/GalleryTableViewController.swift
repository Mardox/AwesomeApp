//
//  GalleryTableViewController.swift
//  Portfolio App
//
//  Created by Hooman Mardokhi on 15/11/2014.
//  Copyright (c) 2014 Hooman Mardokhi. All rights reserved.
//

import UIKit

class GalleryTableViewController: UITableViewController, UITableViewDataSource,UITableViewDelegate, UISplitViewControllerDelegate  {

    
    
    private var itemList = NSMutableArray()
    //var layoutType = LayoutType.Grid
    
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
    
    
    func flickrFetch(){
        
        // Make the API Call
        
        // Refresh the tableview
        
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemList.count;
    }
    
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       
        let photoCell : GalleryTableViewCell=tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as GalleryTableViewCell
        
        //assign the cell data
        
        return photoCell;
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!)
    {
        if segue.identifier == "Image"
        {
            var photoViewController = segue.destinationViewController as GalleryItemViewController
            //photoViewController.photoInfo = photoCell.photoInfo
        }
    }
    
    
    
    
}
