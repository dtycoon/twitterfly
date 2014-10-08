//
//  ComposeViewController.swift
//  twitterfly
//
//  Created by Deepak Agarwal on 10/7/14.
//  Copyright (c) 2014 Deepak Agarwal. All rights reserved.
//

import UIKit


class ComposeViewController: UIViewController, ComposeViewControllerDelegate {
    
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var screenName: UILabel!
    
    @IBOutlet weak var tweetButton: UIBarButtonItem!
    
    var composeTo: String!
    
    var segueDelegate: UserViewControllerDelegate!
    
    @IBOutlet weak var userInputView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userName.text = User.currentUser?.name
        var sn = User.currentUser?.screenname
        screenName.text = "@" + sn!
        var imageUrl = User.currentUser?.profileImageUrl
        if(imageUrl != nil)
        {
            println("  profileImageUrl = \(imageUrl!)")
            userImage.setImageWithURL(NSURL(string: imageUrl!))
        }
        userInputView.text = composeTo ?? ""
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTapCancel(sender: AnyObject) {
        println("onTapBack cancel")
        goHome()
    }
    
    func goHome()
    {
        segueDelegate.RequestSegueToViewController("HometimelineViewController")
        
    }
    @IBAction func onTweetAction(sender: AnyObject) {
        var myTweet = userInputView.text
        if(myTweet != nil)
        {
            let address = myTweet!
            println(" tweet composition = \(address)")
            var parameter = ["status":address]
            var url_post = "1.1/statuses/update.json" as String
            
            TweetsieClient.sharedInstance.tweetSelf(url_post,index: 0, params: parameter, tweetCompletionError: { (url_post, index, error) -> () in
                println("error in tweetSelf = \(error)")
                return
            })
            goHome()
        }
        
        
    }
    func composeTweet (screenID: String)
    {
        composeTo = "@" + screenID + " "
    }
}
