//
//  ProfileViewController.swift
//  twitterfly
//
//  Created by Deepak Agarwal on 10/3/14.
//  Copyright (c) 2014 Deepak Agarwal. All rights reserved.
//

import UIKit

let userProfileDownloaded = "userProfileDownloaded"
let userTweetsDownloaded = "userTweetsDownloaded"
class ProfileViewController: UIViewController, UITableViewDelegate,  UITableViewDataSource, ProfileViewControllerDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    var refreshControl:UIRefreshControl!
    var tweetDetailDelegate: TweetDetailViewControllerDelegate!
    var segueDelegate: UserViewControllerDelegate!
    
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    var userId: Int!
    
    var userProfile: UserProfile!
    var tweets: [Tweet]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("viewDidload called on ProfileViewController")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.whiteColor()
        tableView.tintColor = UIColor.lightGrayColor()
        tableView.separatorColor = UIColor.darkGrayColor()
        tableView.estimatedRowHeight = 100
        
        tableView.rowHeight = UITableViewAutomaticDimension
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateTable", name: userProfileDownloaded, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateTable", name: userTweetsDownloaded, object: nil)
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refersh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
        
        var parameterInt:NSDictionary = ["user_id":userId]
        
        TweetsieClient.sharedInstance.userProfileWithParams(parameterInt, completion: { (userProfile, error) -> () in
            self.userProfile = userProfile
        })
        
        TweetsieClient.sharedInstance.userTimelineWithParams(parameterInt, completion: { (tweets, error) -> () in
            self.tweets = tweets
        })
        // Do any additional setup after loading the view.
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refresh(sender:AnyObject)
    {
        println(" reloading from refresh ")
        println("refresh calling  TweetsieClient userProfileWithParams and userTimelineWithParams")
        var parameterInt:NSDictionary = ["user_id":userId]
        TweetsieClient.sharedInstance.userProfileWithParams(parameterInt, completion: { (userProfile, error) -> () in
            self.userProfile = userProfile
        })
        
        TweetsieClient.sharedInstance.userTimelineWithParams(parameterInt, completion: { (tweets, error) -> () in
            self.tweets = tweets
        })
        
        
    }
    
    
    func updateTable() {
        println("updateTable called")
        self.refreshControl.endRefreshing()
        self.tableView.reloadData()
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int
    {
        if(section == 0)
        {
            if(userProfile == nil)
            {
                println(userProfile == nil)
                return 0
            }
            else
            {
                println(userProfile != nil)
                return 1
            }
        }
        else if (section == 1)
        {
            if (tweets?.count == nil)
            {
                return 0;
            }
            else
            {
                // return 0
                return tweets!.count
            }
            
        }
        else
        {
            return 0
        }
    }
    
    
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        if (indexPath.section == 0 ) {
            var cellProfile = tableView.dequeueReusableCellWithIdentifier("UserProfileCell") as UserProfileCell
            
            
            println(" after dequeueReusableCellWithIdentifier ProfileView" )
            println(" after dequeueReusableCellWithIdentifier userProfile = \(userProfile)" )
            if(userProfile != nil)
            {
                cellProfile.tweetUser.text = userProfile.name
                cellProfile.tweetUserSN.text = userProfile.screenname
                cellProfile.profileUserImage.setImageWithURL(NSURL(string: (userProfile.profileImageUrl)!))
                var totalTweets = userProfile.statuses_count!
                var totalFollowing = userProfile.friends_count!
                var totalFriends = userProfile.followers_count!
                cellProfile.totalTweets.text = "\(totalTweets)"
                cellProfile.totalFollowing.text = "\(totalFollowing)"
                cellProfile.totalFollowers.text = "\(totalFriends)"
                
                if(userProfile?.following == true)
                {
                    cellProfile.followButton.setAttributedTitle(NSAttributedString(string: "Following"), forState: .Normal)
                }
                else
                {
                    cellProfile.followButton.setAttributedTitle(NSAttributedString(string: "Follow"), forState: .Normal)
                }
                
            }
            return cellProfile;
            
        }
        else {
            
            var cell = tableView.dequeueReusableCellWithIdentifier("TweetCell") as TweetCell
            var cellTweet = tweets?[indexPath.row]
            
            
            var retLabel = "\((cellTweet?.user?.name)!) retweeted"
            
            //   if(retLabel != nil)
            // {
            // cell.topRetweetUser.text = "\(retLabel!) retweeted"
            // }
            
            
            
            var tweetUrl = cellTweet?.user?.profileImageUrl
            if(tweetUrl != nil)
            {
                cell.tweetUserImage.setImageWithURL(NSURL(string: tweetUrl!))
            }
            
            cell.tweetUser.text = cellTweet?.user?.name
            
            var sn = cellTweet?.user?.screenname
            cell.tweetUserSN.text =   "@" + sn!
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
        
    }
    
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        var indexRow = indexPath.row
        var indexSection = indexPath.section
        println("didSelectRowAtIndexPath indexSection = \(indexSection) indexRow = \(indexRow)")
        if(indexSection == 1)
        {
            println("didSelectRowAtIndexPath caling segue to TweetDetailViewController")
            println("didSelectRowAtIndexPath tweets.count = \(tweets?.count)")
            
            var mytweets: [Tweet] = tweets!
            println(" count of mytweets = \(mytweets.count)")
            println(" mytweets is = \(mytweets)")
            var tweetItem = self.tweets?[indexRow]
            println(" mytweetItem is = \(tweetItem!)")
            tweetDetailDelegate.copyTweetItem(tweetItem!, index: indexRow, requestFrom: "Profile")
            segueDelegate.RequestSegueToViewController("TweetDetailViewController")
            return
            
        }
        
    }
    
    
    @IBAction func onHomePressed(sender: AnyObject) {
        println("onTapBack received")
        segueDelegate.RequestSegueToViewController("HometimelineViewController")
    }
    
    
    
    func profileSelected (profileId:Int) {
        self.userId = profileId
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
