//
//  TweetDetailViewController.swift
//  twitterfly
//
//  Created by Deepak Agarwal on 10/3/14.
//  Copyright (c) 2014 Deepak Agarwal. All rights reserved.
//

import UIKit


class TweetDetailViewController: UIViewController, TweetDetailViewControllerDelegate {
    
    var tweetIndex:Int!
    var tweetsCopy: [Tweet]?
    var tweetItem: Tweet!
    var didCallFavorate:Bool = false
    var hometimelineDelegate: HometimelineViewControllerDelegate!
    var profileDelegate: ProfileViewControllerDelegate!
    var segueDelegate: UserViewControllerDelegate!
    var segueFrom: String = "Home"
    
    
    @IBOutlet weak var retweetStaticButton: UIButton!
    @IBOutlet weak var topRetweetUserLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userScreenName: UILabel!
    @IBOutlet weak var userTweetLabel: UILabel!
    
    @IBOutlet weak var tweetTimeLabel: UILabel!
    
    @IBOutlet weak var retweetTimesLabel: UILabel!
    
    @IBOutlet weak var tweetFavLabel: UILabel!
    
    
    
    @IBOutlet weak var replyButton: UIButton!
    
    @IBOutlet weak var favorateButton: UIButton!
    
    @IBOutlet weak var userTweetReply: UITextView!
    
    @IBOutlet weak var retweetButton: UIButton!
    
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //      self.retweetStaticButton.setImage(UIImage(named: "retweet.png"), forState: .Normal)
        self.populateTweet()
        backButton.title = segueFrom
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onHomePressed(sender: AnyObject) {
        println("onTapBack received")
        goBackToHome()
    }
    
    func goBackToHome()
    {
        if(self.segueFrom == "Home")
        {
            segueDelegate.RequestSegueToViewController("HometimelineViewController")
        }
        else if(self.segueFrom == "Profile")
        {
            segueDelegate.RequestSegueToViewController("ProfileViewController")
        }
        else
        {
            println("Back not called on \(self.segueFrom)")
        }
        
        
        
    }
    func populateTweet() {
        if(tweetItem != nil)
        {
            
            var retLabel = "\((tweetItem?.user?.name)!) retweeted"
            
            /*   if(retLabel != nil)
            {
            self.topRetweetUserLabel.text = "\(retLabel!) retweeted"
            } */
            
            var tweetUrl = tweetItem?.user?.profileImageUrl
            if(tweetUrl != nil)
            {
                println("  profileImageUrl = \(tweetUrl!)")
                userImage.setImageWithURL(NSURL(string: tweetUrl!))
            }
            
            userNameLabel.text = tweetItem?.user?.name
            
            var sn = tweetItem?.user?.screenname
            userScreenName.text = "@" + sn!
            userTweetLabel.text = tweetItem?.text
            tweetTimeLabel.text = tweetItem?.createdAtString
            retweetTimesLabel.text = "\((tweetItem?.retweetCount)!) RETWEETS"
            tweetFavLabel.text = "\((tweetItem?.favoriteCount)!) FAVORITES"
            
            if(tweetItem?.favorited == true)
            {
                favorateButton.tintColor = nil
                favorateButton.setImage(UIImage(named: "favorite_on.png"),forState: .Normal)
                favorateButton.tintColor = UIColor.orangeColor()
            }
            else
            {
                favorateButton.tintColor = nil
                favorateButton.setImage(UIImage(named: "favorite.png"),forState: .Normal)
//                favorateButton.setImage(UIImage(named: "favorite_hover.png"),forState: .Highlighted)
                favorateButton.tintColor = UIColor.blackColor()
            }
            replyButton.setImage(UIImage(named: "reply.png"), forState: .Normal)
            
            if(tweetItem?.retweeted == true)
            {
                retweetButton.tintColor = nil
                retweetButton.setImage(UIImage(named: "retweet_on.png"), forState: .Normal)
                retweetButton.tintColor = UIColor.orangeColor()
            }
            else
            {
                retweetButton.tintColor = nil
                retweetButton.setImage(UIImage(named: "retweet.png"), forState: .Normal)
                retweetButton.tintColor = UIColor.blackColor()
            }
            
            
        }
        
        
    }
    
    @IBAction func onReplyPressed(sender: AnyObject) {
        println("onReplyPressed")
        var myTweet = userTweetReply.text
        if(myTweet != nil || myTweet != "")
        {
            let reply = myTweet!
            var author = (tweetItem.user?.screenname)!
            var response = "@\(author) \(reply)"
            println(" reply = \(reply) response = \(response)")
            let par:Int = tweetItem!.id_int!
            println(" in_reply_to_status_id = \(par)")
            var parameterInt:NSDictionary = ["in_reply_to_status_id":par, "status":response]
            
            var url_post = "1.1/statuses/update.json" as String
            TweetsieClient.sharedInstance.tweetSelf(url_post, index: tweetIndex, params: parameterInt,    tweetCompletionError: { (url_post, index, error) -> () in
                println("error replying to the post")
            })
        }
        goBackToHome()
    }
    
    @IBAction func onRetweetPressed(sender: AnyObject) {
        println("onRetweetPressed")
        var previousState = tweetItem?.retweeted
        tweetItem?.retweeted = true
        let par:Int = tweetItem!.id_int!
        var parameterInt:NSDictionary = ["id":par]
        
        var id_str = tweetItem?.id_str
        
        var url_post = "1.1/statuses/retweet/\(par).json" as String
        
        TweetsieClient.sharedInstance.retweet(url_post, index: tweetIndex, params: nil, retweetCompletionError: { (url_post, index, error) -> () in
            self.tweetItem.retweeted = previousState
            self.populateTweet()
        })
        
        self.populateTweet()
        if(self.segueFrom == "Home")
        {
            hometimelineDelegate.tweetRetweeted(tweetIndex)
        }
        else if(self.segueFrom == "Profile")
        {
            profileDelegate.tweetRetweeted(tweetIndex)
        }
        else
        {
            println("TweetRetweeted not called on \(self.segueFrom)")
        }
    }
    
    @IBAction func onFavPressed(sender: AnyObject) {
        println("onFavPressed")
        
        var previousState = tweetItem?.favorited
        tweetItem?.favorited = true
        
        
        let par:Int = tweetItem!.id_int!
        println("onFavPressed id  = \(par) ")
        var parameterInt:NSDictionary = ["id":par]
        
        
        var url_post = "1.1/favorites/create.json" as String
        TweetsieClient.sharedInstance.tweetSelf(url_post, index: tweetIndex, params: parameterInt,    tweetCompletionError: { (url_post, index, error) -> () in
            println("error replying to the post error = \(error)")
            self.tweetItem.favorited = previousState
            self.populateTweet()
        })
        
        populateTweet()
        if(self.segueFrom == "Home")
        {
            hometimelineDelegate.tweetFavorated(tweetIndex)
        }
        else if(self.segueFrom == "Profile")
        {
            profileDelegate.tweetFavorated(tweetIndex)
        }
        else
        {
            println("TweetFavorated not called on \(self.segueFrom)")
        }
        
    }
    
    func copyTweetArray (tweets: [Tweet]?, index: Int) {
        self.tweetsCopy = tweets
        self.tweetIndex = index
        self.tweetItem = self.tweetsCopy?[self.tweetIndex]
        
    }
    func copyTweetItem (tweet: Tweet, index: Int, requestFrom: String) {
        self.tweetItem = tweet
        self.tweetIndex = index
        self.segueFrom = requestFrom
        
    }
}
