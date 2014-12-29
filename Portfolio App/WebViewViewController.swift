//
//  SocialWebViewViewController.swift
//  Portfolio App
//
//  Created by Hooman Mardokhi on 29/11/2014.
//  Copyright (c) 2014 Hooman Mardokhi. All rights reserved.
//

import UIKit

class WebViewViewController: UIViewController, UISplitViewControllerDelegate {

    
    
    @IBOutlet var webViewElement: UIWebView!
    
    var _webAddress: AnyObject? {
        didSet {
            // Update the view.
        }
    }

    var address : String = ""
    
    func loadAddressURL(){

        address = _webAddress as String!
        
        address = address.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
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

        //Looks for single or multiple taps.
        var tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        self.view.addGestureRecognizer(tap)
        
        startFetching()
        
    }
    
    
    
    func startFetching(){
        
        if AppDelegate.isConnectedToNetwork(){
            loadAddressURL()
        }else{
            AppDelegate.displayInternetError(self)
        }
        
    }
    
    
//    func splitViewController(svc: UISplitViewController, shouldHideViewController vc: UIViewController, inOrientation orientation: UIInterfaceOrientation) -> Bool {
//        return false
//    }
    
    
    //Calls this function when the tap is recognized.
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        self.view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
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
