//
//  ViewController.swift
//  twitterfly
//
//  Created by Deepak Agarwal on 10/3/14.
//  Copyright (c) 2014 Deepak Agarwal. All rights reserved.
//

import UIKit


class UserViewController: UIViewController, UserViewControllerDelegate {
    
    
    @IBOutlet weak var userSN: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var profileButton: UIButton!
    
    @IBOutlet weak var homeButton: UIButton!
    
    @IBOutlet weak var mentionsButton: UIButton!
    
    @IBOutlet weak var composeButton: UIButton!
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var onLogoutButton: UIButton!
    
    var viewContollerDict:[String:UIViewController] = [:]
    
    
    @IBOutlet weak var logoutButton: UIButton!
    
    var profileViewController: ProfileViewController!
    var timelineViewController: HometimelineViewController!
    var tweetDetailViewController: TweetDetailViewController!
    var composeViewController: ComposeViewController!
    
    @IBOutlet weak var contentViewCenterXConstraint: NSLayoutConstraint!
    
    var activeViewController: UIViewController? {
        didSet(oldViewControllerOrNil) {
            if let oldVC = oldViewControllerOrNil {
                oldVC.willMoveToParentViewController(nil)
                oldVC.view.removeFromSuperview()
                oldVC.removeFromParentViewController()
            }
            if let newVC = activeViewController {
                self.addChildViewController(newVC)
                newVC.view.autoresizingMask = .FlexibleWidth | .FlexibleHeight
                newVC.view.frame = self.contentView.bounds
                self.contentView.addSubview(newVC.view)
                newVC.didMoveToParentViewController(self)
            }
            
        }
    }
    
    /*   var animationActiveViewController: UIViewController? {
    didSet(oldViewControllerOrNil) {
    
    if let oldVC = oldViewControllerOrNil {
    oldVC.willMoveToParentViewController(nil)
    oldVC.view.removeFromSuperview()
    oldVC.removeFromParentViewController()
    }
    if let newVC = activeViewController {
    self.addChildViewController(newVC)
    newVC.view.autoresizingMask = .FlexibleWidth | .FlexibleHeight
    if(oldVC == nil)
    {
    newVC.view.frame = self.contentView.bounds
    self.contentView.addSubview(newVC.view)
    newVC.didMoveToParentViewController(self)
    }
    }
    
    }
    }
    
    
    func transitionCustomAnimationViewController( oldVC: UIViewController?, newVC: UIViewController?) {
    
    UIApplication.sharedApplication().beginIgnoringInteractionEvents()
    if (oldVC? != nil) {
    oldVC!.willMoveToParentViewController(nil)
    }
    if (newVC? != nil) {
    self.addChildViewController(newVC!)
    newVC!.view.autoresizingMask = .FlexibleWidth | .FlexibleHeight
    if(oldVC? == nil)
    {
    newVC!.view.frame = self.contentView.bounds
    self.contentView.addSubview(newVC!.view)
    newVC!.didMoveToParentViewController(self)
    println("oldVC is nil")
    return
    }
    }
    else
    {
    println("newVC is nil")
    return
    }
    
    self.addChildViewController(newVC!)
    newVC!.view.autoresizingMask = .FlexibleWidth | .FlexibleHeight
    
    transitionFromViewController( oldVC!,
    toViewController:newVC!,
    duration:0.4,
    options:.TransitionNone,
    animations: {
    newVC!.view.frame = self.contentView.bounds
    self.contentView.addSubview(newVC!.view)
    },
    completion:{
    _ in
    newVC!.didMoveToParentViewController(self)
    oldVC!.view.removeFromSuperview()
    oldVC!.removeFromParentViewController()
    UIApplication.sharedApplication().endIgnoringInteractionEvents()
    })
    
    }
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(User.currentUser != nil)
        {
            var tweetUrl = User.currentUser?.profileImageUrl
            if(tweetUrl != nil)
            {
                self.userImage.setImageWithURL(NSURL(string: tweetUrl!))
            }
            
            var sn = "@" + (User.currentUser?.screenname)!
            self.userSN.text = sn
        }
        self.contentViewCenterXConstraint.constant = 0
        
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        profileViewController = storyboard.instantiateViewControllerWithIdentifier("ProfileViewController") as ProfileViewController
        profileViewController.segueDelegate = self
        viewContollerDict["ProfileViewController"] = profileViewController
        
        
        timelineViewController = storyboard.instantiateViewControllerWithIdentifier("HometimelineViewController") as HometimelineViewController
        viewContollerDict["HometimelineViewController"] = timelineViewController
        viewContollerDict["MentiontimelineViewController"] = timelineViewController
        timelineViewController.segueDelegate = self
        timelineViewController.profileDelegate = profileViewController
        
        
        tweetDetailViewController = storyboard.instantiateViewControllerWithIdentifier("TweetDetailViewController") as TweetDetailViewController
        viewContollerDict["TweetDetailViewController"] = tweetDetailViewController
        tweetDetailViewController.segueDelegate = self
        tweetDetailViewController.hometimelineDelegate = timelineViewController
        tweetDetailViewController.profileDelegate = profileViewController
        
        composeViewController = storyboard.instantiateViewControllerWithIdentifier("ComposeViewController") as ComposeViewController
        composeViewController.segueDelegate = self
        viewContollerDict["ComposeViewController"] = composeViewController
        
        profileViewController.tweetDetailDelegate = tweetDetailViewController
        timelineViewController.tweetDetailDelegate = tweetDetailViewController
        
        //      transitionCustomAnimationViewController(self.activeViewController, newVC: timelineViewController)
        self.activeViewController = timelineViewController
        
    }
    
    
    @IBAction func onTapSidebarButton(sender: UIButton) {
        if(sender == profileButton)
        {
            var curUser = User.currentUser?.userId
            println("Profile Menu Item")
            
            profileViewController.userId = curUser!
            println("Profile Menu Item currentUser selected = \(curUser!)")
            //           transitionCustomAnimationViewController(self.activeViewController, newVC: profileViewController)
            self.activeViewController = profileViewController
        }
        else if (sender == homeButton)
        {
            println("Home Menu Item")
            if(timelineViewController.homeOrMentionTimelineUrl != "1.1/statuses/home_timeline.json")
            {
                timelineViewController.homeOrMentionTimelineUrl = "1.1/statuses/home_timeline.json"
                timelineViewController.headerText = "Home"
                timelineViewController.reloadViews = true
            }
            //          transitionCustomAnimationViewController(self.activeViewController, newVC: timelineViewController)
            self.activeViewController = timelineViewController
        }
        else if (sender == mentionsButton)
        {
            println("Mentions Menu Item")
            if(timelineViewController.homeOrMentionTimelineUrl != "1.1/statuses/mentions_timeline.json")
            {
                timelineViewController.homeOrMentionTimelineUrl = "1.1/statuses/mentions_timeline.json"
                timelineViewController.headerText = "Mentions"
                timelineViewController.reloadViews = true
            }
            //           transitionCustomAnimationViewController(self.activeViewController, newVC: timelineViewController)
            self.activeViewController = timelineViewController
        }
        else if(sender == composeButton)
        {
            var curUser = User.currentUser?.userId
            println("Compose Menu Item")
            
            profileViewController.userId = curUser!
            println("Compose Menu Item currentUser selected = \(curUser!)")
            //         transitionCustomAnimationViewController(self.activeViewController, newVC: composeViewController)
            self.activeViewController = composeViewController
        }
        else if(sender == onLogoutButton)
        {
            User.currentUser?.logout()
        }
        else
        {
            println("Unknown Menu Item")
        }
        UIView.animateWithDuration(0.35, animations: { () -> Void in
            self.contentViewCenterXConstraint.constant = 0
            self.view.layoutIfNeeded()
        })
        
    }
    
    
    @IBAction func didSwipe(sender: UISwipeGestureRecognizer) {
        if(sender.state == .Ended)
        {
            UIView.animateWithDuration(0.35, animations: { () -> Void in
                self.contentViewCenterXConstraint.constant = -160
                self.view.layoutIfNeeded()
            })
            
        }
    }
    
    @IBAction func didSwipeBack(sender: UISwipeGestureRecognizer) {
        if(sender.state == .Ended)
        {
            UIView.animateWithDuration(0.35, animations: { () -> Void in
                self.contentViewCenterXConstraint.constant = 0
                self.view.layoutIfNeeded()
            })
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onLogout(sender: AnyObject) {
        User.currentUser?.logout()
    }
    
    func RequestSegueToViewController (viewControllerName:String)
    {
        println("RequestSegueToViewController: requesting transition to viewControllerName = \(viewControllerName)")
        //        transitionCustomAnimationViewController(self.activeViewController, newVC: self.viewContollerDict[viewControllerName])
        self.activeViewController = self.viewContollerDict[viewControllerName]
        
    }
    
    
}

