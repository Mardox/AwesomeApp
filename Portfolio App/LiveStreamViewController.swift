//
//  LiveStreamViewController.swift
//  Portfolio App
//
//  Created by Hooman Mardokhi on 8/01/2015.
//  Copyright (c) 2015 Hooman Mardokhi. All rights reserved.
//

import UIKit
import MediaPlayer

class LiveStreamViewController: UIViewController {
    
    var moviePlayerController:MPMoviePlayerViewController!
    var player:MPMoviePlayerController!
    
    var _streamUrl: AnyObject? {
        didSet {
            // Update the view.
        }
    }
    
    var _streamTitle: AnyObject? {
        didSet {
            // Update the view.
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //"http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8"
        var url:NSURL = NSURL(string: self._streamUrl as String)!
        player = MPMoviePlayerController()
        self.player.view.frame  = self.view.bounds
        self.view.addSubview(self.player.view)

        self.player.fullscreen = true
        self.player.contentURL = url
        self.player.prepareToPlay()
        self.player.play()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "doneButtonClick:", name: MPMoviePlayerWillExitFullscreenNotification, object: nil)
        

        
//        let screenSize: CGRect = UIScreen.mainScreen().bounds

//        let screenWidth = screenSize.width;
//        let screenHeight = screenSize.height;
//        player.view.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
//        self.player.contentURL = MPMoviePlayerViewController(contentURL: url)
//        self.player.scalingMode = .AspectFill
//        self.player.controlStyle = .Fullscreen;
//        self.player.setFullscreen(true, animated: true)
//        self.player.repeatMode = .One
//        moviePlayer = MPMoviePlayerController(contentURL: url)

//        moviePlayerController = MPMoviePlayerViewController(contentURL: url)
//        
//        presentMoviePlayerViewControllerAnimated(moviePlayerController)
//        moviePlayerController.moviePlayer.prepareToPlay()
//        moviePlayerController.moviePlayer.repeatMode = MPMovieRepeatMode.One
//        moviePlayerController.moviePlayer.shouldAutoplay = true
//        moviePlayerController.moviePlayer.fullscreen = true
//        self.view.addSubview(moviePlayerController.view)
//        moviePlayerController.moviePlayer.play()
//        moviePlayerControls.play()
//        moviePlayer = MPMoviePlayerController

//        moviePlayer.view.frame = CGRect(x: 0, y: 0, width: 200, height: 150)
//
//        self.view.addSubview(moviePlayer.view)
//
//        moviePlayer.fullscreen = true
//
//        moviePlayer.controlStyle = MPMovieControlStyle.Embedded
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func doneButtonClick(sender:NSNotification?){
        println("finishPreload");
    }

    override func viewDidDisappear(animated: Bool) {
        self.player = nil
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
