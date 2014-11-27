//
//  ContactViewController.swift
//  Portfolio App
//
//  Created by Hooman Mardokhi on 15/11/2014.
//  Copyright (c) 2014 Hooman Mardokhi. All rights reserved.
//

import UIKit
import MapKit;

class ContactViewController: UIViewController, UISplitViewControllerDelegate {


    var dict : NSDictionary!
    
    
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.splitViewController?.delegate = self
        
        let path = NSBundle.mainBundle().pathForResource("Config", ofType: "plist")
        self.dict = NSDictionary(contentsOfFile: path!) as NSDictionary!
        

        // 1
        let location = CLLocationCoordinate2D(
            latitude: -33.867487,
            longitude: 151.206990
        )
        // 2
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        
        //3
        let annotation = MKPointAnnotation()
        annotation.setCoordinate(location)
        annotation.title = dict.objectForKey("appName") as String
        annotation.subtitle = dict.objectForKey("city") as String
        mapView.addAnnotation(annotation)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func callButton(sender: AnyObject) {
        
        let phonenumber = dict.objectForKey("phone") as String
        let phone = "tel://\(phonenumber)"
        let url:NSURL = NSURL(string:phone)!
        UIApplication.sharedApplication().openURL(url)
        
    }

    @IBAction func emailButton(sender: AnyObject) {
        
        let email = dict.objectForKey("email") as String
        let url = NSURL(string: "mailto:\(email)")
        UIApplication.sharedApplication().openURL(url!)
        
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
