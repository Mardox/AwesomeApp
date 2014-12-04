//
//  AboutViewController.swift
//  Portfolio App
//
//  Created by Hooman Mardokhi on 15/11/2014.
//  Copyright (c) 2014 Hooman Mardokhi. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController, UISplitViewControllerDelegate {

    @IBOutlet var titleTetView: UILabel!
    @IBOutlet var descriptionTextView: UITextView!
    var dict : NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.splitViewController?.delegate = self
        
        let path = NSBundle.mainBundle().pathForResource("Config", ofType: "plist")
        self.dict = NSDictionary(contentsOfFile: path!) as NSDictionary!
        
        self.titleTetView.text = self.dict.objectForKey("appName") as? String
        self.descriptionTextView.text = self.dict.objectForKey("description") as? String

        self.descriptionTextView.sizeToFit()
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
