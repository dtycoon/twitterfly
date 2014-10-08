//
//  UserProfile.swift
//  twitterfly
//
//  Created by Deepak Agarwal on 10/5/14.
//  Copyright (c) 2014 Deepak Agarwal. All rights reserved.
//

import UIKit

class UserProfile: NSObject {
    var name: String?
    var screenname: String?
    var profileImageUrl: String?
    var tagline: String?
    var favourites_count: Int?
    var follow_request_sent:  Bool?
    var following: Bool?
    var followers_count: Int?
    var friends_count: Int?
    var user_id: Int?
    var id_str: String?
    var profile_background_color: String?
    var profile_background_image_url: String?
    var profile_text_color: String?
    var statuses_count: Int?
    
    
    init(dictionary: NSDictionary)
    {
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        profileImageUrl = dictionary["profile_image_url"] as? String
        tagline = dictionary["descripton"] as? String
        favourites_count = (dictionary["favourites_count"] as? Int)!
        following = (dictionary["following"] as? Bool)!
        followers_count = (dictionary["followers_count"] as? Int)!
        friends_count = (dictionary["friends_count"] as? Int)!
        user_id = dictionary["id"] as? Int
        id_str = dictionary["id_str"] as? String
        profile_background_color = dictionary["profile_background_color"] as? String
        profile_background_image_url = dictionary["profile_background_image_url"] as? String
        profile_text_color = dictionary["profile_text_color"] as? String
        statuses_count = (dictionary["statuses_count"] as? Int)!
        
        
    }
    
    
}
