//
//  GalleryItemViewController.swift
//  Portfolio App
//
//  Created by Hooman Mardokhi on 15/11/2014.
//  Copyright (c) 2014 Hooman Mardokhi. All rights reserved.
//

import UIKit

class GalleryItemViewController: UIViewController {

    
    
    var _imageIndex: AnyObject? {
        didSet {
            // Update the view.
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var demoImageName = "demo-\(_imageIndex as Int)"
        imageView.image  = UIImage(named: demoImageName)!
        
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.clipsToBounds = true

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
