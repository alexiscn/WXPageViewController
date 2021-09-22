//
//  TwitterTimelineTableViewCell.swift
//  PageViewControllerExample
//
//  Created by xu.shuifeng on 2020/10/31.
//  Copyright © 2020 alexiscn. All rights reserved.
//

import UIKit

class TwitterTimelineTableViewCell: UITableViewCell {
    
    private let avatarImageView: UIImageView
    
    private let nicknameLabel: UILabel
    
    private let contentLabel: UILabel
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        avatarImageView = UIImageView()
        
        nicknameLabel = UILabel()
        
        contentLabel = UILabel()
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(avatarImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(_ status: TwitterStatus) {
        
    }
}
