//
//  UserProfileCell.swift
//  twitterfly
//
//  Created by Deepak Agarwal on 10/6/14.
//  Copyright (c) 2014 Deepak Agarwal. All rights reserved.
//

import UIKit

class UserProfileCell: UITableViewCell {
    
    @IBOutlet weak var profileUserImage: UIImageView!
    @IBOutlet weak var profileUserBackground: UIView!
    
    @IBOutlet weak var userBannerImageView: UIImageView!
    @IBOutlet weak var tweetUser: UILabel!
    @IBOutlet weak var tweetUserSN: UILabel!
    @IBOutlet weak var totalTweets: UILabel!
    @IBOutlet weak var totalFollowing: UILabel!
    @IBOutlet weak var totalFollowers: UILabel!
    @IBOutlet weak var favUser: UIButton!
    @IBOutlet weak var followButton: UIButton!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
