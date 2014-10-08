//
//  TweetCell.swift
//  twitterfly
//
//  Created by Deepak Agarwal on 10/5/14.
//  Copyright (c) 2014 Deepak Agarwal. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
    
    
    @IBOutlet weak var topRetweetIcon: UIImageView!
    
    @IBOutlet weak var topRetweetUser: UILabel!
    
    @IBOutlet weak var tweetUserImage: UIImageView!
    
    @IBOutlet weak var tweetUser: UILabel!
    
    
    @IBOutlet weak var tweetUserSN: UILabel!
    
    
    @IBOutlet weak var tweetCreatedTime: UILabel!
    
    
    @IBOutlet weak var tweetText: UILabel!
    
    
    
    
    @IBOutlet weak var replyButton: UIButton!
    
    
    @IBOutlet weak var retweetButton: UIButton!
    
    @IBOutlet weak var favButton: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
