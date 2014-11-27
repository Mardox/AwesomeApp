//
//  GalleryItemViewController.swift
//  Portfolio App
//
//  Created by Hooman Mardokhi on 15/11/2014.
//  Copyright (c) 2014 Hooman Mardokhi. All rights reserved.
//

import UIKit

class GalleryItemViewController: UIViewController, UIScrollViewDelegate {
    
    var _imageIndex: AnyObject? {
        didSet {
            // Update the view.
        }
    }
    @IBOutlet weak var scrollView: UIScrollView!
    
    var currentScale: CGFloat!
    
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var demoImageName = "demo-\(_imageIndex as Int)"
        imageView.image  = UIImage(named: demoImageName)!
        
//        imageView.contentMode = UIViewContentMode.ScaleAspectFill
//        imageView.clipsToBounds = true
        
         view.backgroundColor = UIColor.whiteColor()
        
        
        self.scrollView.minimumZoomScale=1;
        self.scrollView.maximumZoomScale=6.0;
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
