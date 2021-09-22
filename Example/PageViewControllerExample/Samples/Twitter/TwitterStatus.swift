//
//  TwitterStatus.swift
//  PageViewControllerExample
//
//  Created by xu.shuifeng on 2020/10/31.
//  Copyright © 2020 alexiscn. All rights reserved.
//

import Foundation

struct TwitterStatus: Codable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case nickname
        case username
        case avatar
        case content
        case commentCount = "comment_count"
        case retweetCount = "retweet_count"
    }
    
    let id: String
    
    let nickname: String
    
    let username: String
    
    let avatar: URL?
    
    let content: String
    
    let commentCount: Int
    
    let retweetCount: Int
}
