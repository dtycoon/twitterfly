//
//  LoginViewController.swift
//  twitterfly
//
//  Created by Deepak Agarwal on 10/5/14.
//  Copyright (c) 2014 Deepak Agarwal. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor =  UIColor(red: 0.24, green:0.47, blue:0.85 , alpha:1.0)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLoginPressed(sender: AnyObject) {
        TweetsieClient.sharedInstance.loginWithCompletion() {
            (user: User?, error: NSError?) in
            if user != nil {
                println("calling loginSegue segue")
                self.performSegueWithIdentifier("loginSegue", sender: self)
                //perform segue
            } else {
                println("user is nil")
            }
        }
        
    }
}
