//
//  RadioViewController.swift
//  Portfolio App
//
//  Created by Hooman Mardokhi on 13/12/2014.
//  Copyright (c) 2014 Hooman Mardokhi. All rights reserved.
//

import UIKit
import MediaPlayer

class RadioViewController: UIViewController, GADBannerViewDelegate, GADInterstitialDelegate  {

    
    var bannerView:GADBannerView?
    var interstitial:GADInterstitial?
    var timer:NSTimer?
    var loadRequestAllowed = true
    var bannerDisplayed = false
    var statusbarHeight:CGFloat = 70.0
    var url:NSURL?
    var state = "Stopped"
    @IBOutlet var playButton: UIButton!
    var moviePlayer:MPMoviePlayerController!
    
    
    
    var _radioUrl: AnyObject? {
        didSet {
            // Update the view.
        }
    }
    
    var _radioTitle: AnyObject? {
        didSet {
            // Update the view.
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = _radioTitle as String!
        url = NSURL(string: _radioUrl as String!)!
        startFetching()
    }
    
    
    
    func startFetching(){
        
        if AppDelegate.isConnectedToNetwork(){
            startRadio()
        }else{
            AppDelegate.displayInternetError(self)
        }
        
    }

    
    //Start the radio stream
    func startRadio(){
    
        moviePlayer = MPMoviePlayerController(contentURL: url)
        
        //        moviePlayer.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        //        moviePlayer.view.sizeToFit()
        
        moviePlayer.movieSourceType = MPMovieSourceType.Streaming
        
        //        self.view.addSubview(moviePlayer.view)
        //        moviePlayer.fullscreen = true
        
        moviePlayer.controlStyle = MPMovieControlStyle.Embedded
        
        changePlayState()
        
        //       loadAdmobBanner()
        
        
    }
    
    func loadAdmobBanner(){
       
        //banner
        bannerView = nil
        
        if UIDevice.currentDevice().orientation == UIDeviceOrientation.Portrait{
            bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
            self.statusbarHeight = 70.0
        }else{
            bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerLandscape)
            self.statusbarHeight = 30.0
        }

        bannerView?.adUnitID = "ca-app-pub-6938332798224330/9023870805"
        bannerView?.delegate = self
        bannerView?.rootViewController = self
        self.view.addSubview(bannerView!)
        bannerView?.loadRequest(GADRequest())
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Play/Pause button action
    @IBAction func playButton(sender: AnyObject) {

        changePlayState()
        
    }
    
    //Handle Admob on rotate
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        //reload the banner
        loadAdmobBanner()
    }
    
    
    //Change the play state between Play and Pause
    func changePlayState(){
        
        if state == "Stopped" {
            moviePlayer.prepareToPlay()
            moviePlayer.play()
            playButton.setTitle("Stop", forState: UIControlState.Normal)
            state = "Playing"
        }else if state == "Playing"{
            moviePlayer.stop()
            playButton.setTitle("Play", forState: UIControlState.Normal)
            state = "Stopped"
        }
        
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        if state == "Playing"{
            moviePlayer.stop()
            playButton.setTitle("Play", forState: UIControlState.Normal)
            state = "Stopped"
        }

    }

    
    func GoogleAdRequestTimer() {
        
        if (!loadRequestAllowed) {
            println("load request not allowed")
            return
        }
        
        println("load request")
        bannerView?.loadRequest(GADRequest())
    }
    
    
    //GADBannerViewDelegate
    func adViewDidReceiveAd(view: GADBannerView!) {
        println("adViewDidReceiveAd:\(view)");
        bannerDisplayed = true
        relayoutViews()
    }
    
    func adView(view: GADBannerView!, didFailToReceiveAdWithError error: GADRequestError!) {
        println("\(view) error:\(error)")
        bannerDisplayed = false
        relayoutViews()
    }
    
    func adViewWillPresentScreen(adView: GADBannerView!) {
        println("adViewWillPresentScreen:\(adView)")
        bannerDisplayed = false
        relayoutViews()
    }
    
    func adViewWillLeaveApplication(adView: GADBannerView!) {
        println("adViewWillLeaveApplication:\(adView)")
        bannerDisplayed = false
        relayoutViews()
    }
    
    func adViewWillDismissScreen(adView: GADBannerView!) {
        println("adViewWillDismissScreen:\(adView)")
        bannerDisplayed = false
        relayoutViews()
    }
    
    func relayoutViews() {
        if (bannerDisplayed) {
            var bannerFrame =  bannerView!.frame
            bannerFrame.origin.x = 0
            bannerFrame.origin.y = self.view.bounds.height - statusbarHeight
            bannerView!.frame = bannerFrame
            
        }
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
