//
//  Tweet.swift
//  twitterfly
//
//  Created by Deepak Agarwal on 10/5/14.
//  Copyright (c) 2014 Deepak Agarwal. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var delayedTime: String?
    var retweeted: Bool?
    var retweetCount: Int?
    var favorited: Bool?
    var favoriteCount: Int?
    var id_str: String?
    var id_int: Int?
    init(dictionary: NSDictionary)
    {
        user = User(dictionary: dictionary["user"] as NSDictionary)
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        retweeted = dictionary["retweeted"] as? Bool
        retweetCount = dictionary["retweet_count"] as? Int
        favorited = dictionary["favorited"] as? Bool
        favoriteCount = dictionary["favorite_count"] as? Int
        id_str = dictionary["id_str"] as? String
        id_int = dictionary["id"] as? Int
        var formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM dd HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)
        delayedTime = Tweet.formatCreatedTimeToUserReadableTime(self.createdAt!)
        
    }
    
    class func formatCreatedTimeToUserReadableTime(createdAt: NSDate) -> String {
        var timeSinceCreation = createdAt.timeIntervalSinceNow
        var timeSinceCreationInt =  Int(timeSinceCreation) * -1
        var timeSinceCreationMins = timeSinceCreationInt/60 as Int
        if (timeSinceCreationMins == 0) {
            return "now"
        } else if (timeSinceCreationMins >= 1 && timeSinceCreationMins < 60) {
            return "\(timeSinceCreationMins)m"
        } else if (timeSinceCreationMins < 1440) {
            return "\(timeSinceCreationMins/60)h"
        } else if (timeSinceCreationMins >= 1440) {
            return "\(timeSinceCreationMins/1440)d"
        }
        return ""
    }
    
    class func tweetsWithArray (array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        println("total number of tweets = \(tweets.count) ")
        
        return tweets
    }
    
}
