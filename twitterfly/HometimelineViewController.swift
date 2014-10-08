//
//  hometimelineViewController.swift
//  twitterfly
//
//  Created by Deepak Agarwal on 10/3/14.
//  Copyright (c) 2014 Deepak Agarwal. All rights reserved.
//

import UIKit

protocol ProfileViewControllerDelegate {
    func profileSelected (profileId:Int)
    func tweetFavorated (tweetIndex:Int)
    func tweetRetweeted(tweetIndex: Int)
}
protocol UserViewControllerDelegate {
    func RequestSegueToViewController (viewControllerName:String)
}
protocol HometimelineViewControllerDelegate {
    func tweetFavorated (tweetIndex:Int)
    func tweetRetweeted(tweetIndex: Int)
}
protocol TweetDetailViewControllerDelegate {
    func copyTweetArray (tweets: [Tweet]?, index: Int)
    func copyTweetItem (tweet: Tweet, index: Int, requestFrom: String)
}
protocol ComposeViewControllerDelegate {
    func composeTweet (screenID: String)
}

let tweetsDownloaded = "tweetsDownloaded"
class HometimelineViewController: UIViewController, UITableViewDelegate,  UITableViewDataSource, UIGestureRecognizerDelegate, HometimelineViewControllerDelegate  {
    
    
    @IBOutlet weak var tableView: UITableView!
    var refreshControl:UIRefreshControl!
    var profileDelegate: ProfileViewControllerDelegate!
    var tweetDetailDelegate: TweetDetailViewControllerDelegate!
    var segueDelegate: UserViewControllerDelegate!
    var homeOrMentionTimelineUrl: String = "1.1/statuses/home_timeline.json"
    var headerText: String = "Home"
    var reloadViews: Bool = false
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    var tweets: [Tweet]?
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        println("viewDidAppear called on HometimelineViewController")
        if(reloadViews == true)
        {
            println("viewDidAppear calling  TweetsieClient homeTimeWithParams reloadViews = \(reloadViews)")
            TweetsieClient.sharedInstance.homeTimeWithParams(homeOrMentionTimelineUrl, params: nil, completion: { (tweets, error) -> () in
                self.tweets = tweets
            })
            
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("viewDidload called on HometimelineViewController reloadViews = \(reloadViews)")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.whiteColor()
        tableView.tintColor = UIColor.lightGrayColor()
        tableView.separatorColor = UIColor.darkGrayColor()
        tableView.estimatedRowHeight = 150
        
        tableView.rowHeight = UITableViewAutomaticDimension
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateTable", name: tweetsDownloaded, object: nil)
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refersh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
        
        TweetsieClient.sharedInstance.homeTimeWithParams(homeOrMentionTimelineUrl, params: nil, completion: { (tweets, error) -> () in
            self.tweets = tweets
        })
        // Do any additional setup after loading the view.
        
        
        
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTweetPressed(sender: AnyObject) {
        println("on New Tweet Pressed")
        segueDelegate.RequestSegueToViewController("ComposeViewController")
    }
    
    func refresh(sender:AnyObject)
    {
        println(" reloading from refresh ")
        println("refresh calling  TweetsieClient homeTimeWithParams")
        TweetsieClient.sharedInstance.homeTimeWithParams(homeOrMentionTimelineUrl, params: nil, completion: { (tweets, error) -> () in
            self.tweets = tweets
        })
        
    }
    
    @IBAction func onLogout(sender: AnyObject) {
        User.currentUser?.logout()
    }
    
    
    func updateTable() {
        println("updateTable called on ")
        self.refreshControl.endRefreshing()
        self.tableView.reloadData()
    }
    
    func gestureRecognizer(UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWithGestureRecognizer:UIGestureRecognizer) -> Bool {
            return true
    }
    
    func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int
    {
        if (tweets?.count == nil)
        {
            return 0;
        }
        else
        {
            return tweets!.count
        }
    }
    
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("TweetCell") as TweetCell
        var cellTweet = tweets?[indexPath.row]
        
        
        var retLabel = "\((cellTweet?.user?.name)!) retweeted"
        
        /*   if(retLabel != nil)
        {
        cell.topRetweetUser.text = "\(retLabel!) retweeted"
        } */
        
        
        
        var tweetUrl = cellTweet?.user?.profileImageUrl
        if(tweetUrl != nil)
        {
            cell.tweetUserImage.setImageWithURL(NSURL(string: tweetUrl!))
        }
        
        var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
        cell.tweetUserImage.tag = indexPath.row
        tapGestureRecognizer.delegate = self
        cell.tweetUserImage.addGestureRecognizer(tapGestureRecognizer)
        cell.tweetUserImage.userInteractionEnabled = true
        
        
        
        cell.tweetUser.text = cellTweet?.user?.name
        
        var sn = cellTweet?.user?.screenname
        cell.tweetUserSN.text =   "@" + sn!
        // cell.tweetCreatedTime.text = cellTweet?.createdAtString
        var timedelay = cellTweet?.delayedTime
        cell.tweetCreatedTime.text = timedelay!
        cell.tweetText.text = cellTweet?.text
        
        
        if(cellTweet?.favorited == true)
        {
            println(" for row = \(indexPath.row) favorite_on.png")
            cell.favButton.setImage(UIImage(named: "favorite_on.png"),forState: .Normal)
            cell.favButton.tintColor = UIColor.orangeColor()
            
        }
        else
        {
            println(" for row = \(indexPath.row) favorite.png")
            cell.favButton.setImage(UIImage(named: "favorite.png"),forState: .Normal)
            cell.favButton.setImage(UIImage(named: "favorite_hover.png"),forState: .Highlighted)
        }
        cell.replyButton.setImage(UIImage(named: "reply.png"), forState: .Normal)
        
        if(cellTweet?.retweeted == true)
        {
            cell.retweetButton.setImage(UIImage(named: "retweet_on.png"), forState: .Normal)
            cell.retweetButton.tintColor = UIColor.orangeColor()
        }
        else
        {
            cell.retweetButton.setImage(UIImage(named: "retweet.png"), forState: .Normal)
            cell.retweetButton.setImage(UIImage(named: "retweet_hover.png"), forState: .Highlighted)
        }
        
        
        return cell
        
    }
    
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        var indexRow = indexPath.row
        var indexSection = indexPath.section
        println("didSelectRowAtIndexPath indexSection = \(indexSection) indexRow = \(indexRow)")
        var mytweets: [Tweet] = tweets!
        println(" count of mytweets = \(mytweets.count)")
        println(" mytweets is = \(mytweets)")
        var tweetItem = self.tweets?[indexRow]
        println(" mytweetItem is = \(tweetItem!)")
        tweetDetailDelegate.copyTweetItem(tweetItem!, index: indexRow, requestFrom: "Home")
        segueDelegate.RequestSegueToViewController("TweetDetailViewController")
        return
        
    }
    
    
    
    func handleTap(recognizer: UITapGestureRecognizer) {
        
        var indexRow = (recognizer.view as UIImageView).tag
        println("onTapGesture handleTap  indexRow = \(indexRow)")
        var tweetItem = self.tweets?[indexRow]
        var userId = tweetItem?.user?.userId
        println("onTapGesture didSelectRowAtIndexPath handleTap userId = \(userId)")
        profileDelegate.profileSelected(userId!)
        segueDelegate.RequestSegueToViewController("ProfileViewController")
        return
        
        
    }
    
    func tweetFavorated(tweetIndex: Int)
    {
        var tweetItem = (self.tweets?[tweetIndex])!
        tweetItem.favorited = true
        tweetItem.favoriteCount = tweetItem.favoriteCount! + 1
        self.refreshControl.endRefreshing()
        updateTable()
    }
    func tweetRetweeted(tweetIndex: Int)
    {
        var tweetItem = (self.tweets?[tweetIndex])!
        tweetItem.retweeted = true
        tweetItem.retweetCount = tweetItem.retweetCount! + 1
        
        self.refreshControl.endRefreshing()
        updateTable()
    }
}
