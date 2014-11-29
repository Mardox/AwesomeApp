//
//  SocialWebViewViewController.swift
//  Portfolio App
//
//  Created by Hooman Mardokhi on 29/11/2014.
//  Copyright (c) 2014 Hooman Mardokhi. All rights reserved.
//

import UIKit

class SocialWebViewViewController: UIViewController, UISplitViewControllerDelegate {

    
    
    @IBOutlet var webViewElement: UIWebView!
    
    var _socialIndex: AnyObject? {
        didSet {
            // Update the view.
        }
    }

    var address = ""
    
    func loadAddressURL(){
        
        let path = NSBundle.mainBundle().pathForResource("Config", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: path!) as NSDictionary!
        
        
        
        switch _socialIndex as Int {
        case 0:
            address = dict.objectForKey("facebook") as String
        case 1:
            address = dict.objectForKey("twitter") as String
        case 2:
            address = dict.objectForKey("googlePlus") as String
        case 3:
            address = dict.objectForKey("instagram") as String
        case 4:
            address = dict.objectForKey("linkedin") as String
        default:
            println("This is not a valid menu")
        }
        
        
        
        let requesturl = NSURL(string: address)!
        let request = NSURLRequest(URL: requesturl)
        webViewElement.loadRequest(request)
        
    }
    
    @IBAction func openInBrowser(sender: AnyObject) {
        
        var url : NSURL
        url = NSURL(string: address)!
        UIApplication.sharedApplication().openURL(url)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.splitViewController?.delegate = self
        
        loadAddressURL()

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
