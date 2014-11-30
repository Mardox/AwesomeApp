//
//  GalleryItemViewController.swift
//  Portfolio App
//
//  Created by Hooman Mardokhi on 15/11/2014.
//  Copyright (c) 2014 Hooman Mardokhi. All rights reserved.
//

import UIKit

class GalleryItemViewController: UIViewController, UIScrollViewDelegate {
    
    var _imageUrl: AnyObject? {
        didSet {
            // Update the view.
        }
    }
    @IBOutlet weak var scrollView: UIScrollView!
    
    var currentScale: CGFloat!
    var imageCache = [String : UIImage]()
    
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        var demoImageName = "\(_imageName! as String)"
//        imageView.image  = UIImage(named: demoImageName)!
        
        var urlString = _imageUrl as String!
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
                        self.imageView.image = image
                    })
                }
                else {
                    println("Error: \(error.localizedDescription)")
                }
            })
            
        }else {
            dispatch_async(dispatch_get_main_queue(), {
                    self.imageView.image = image
            })
        }

        
        
        
        
        
//        imageView.contentMode = UIViewContentMode.ScaleAspectFill
//        imageView.clipsToBounds = true
        
         view.backgroundColor = UIColor.whiteColor()
        
        
        self.scrollView.minimumZoomScale=1;
        self.scrollView.maximumZoomScale=4.0;
//        self.scrollView.contentSize=CGSizeMake(1280, 960);
        self.scrollView.delegate=self;

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
