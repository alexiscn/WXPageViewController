//
//  WXBadgeView.swift
//  WXPageViewController
//
//  Created by alexiscn on 2020/10/28.
//

import UIKit

@objc public class WXBadge: NSObject {
    
    /// The text content of the badge.
    public var text: String? = nil
    
    public var textColor: UIColor = .white
    
    /// The size for the badge. By default is 18x18.
    public var size: CGSize = CGSize(width: 18, height: 18)
    
    /// The font size for the badge text.
    public var font: UIFont = UIFont.systemFont(ofSize: 9)
    
    /// The background color of the badge.
    public var backgroundColor: UIColor = .red
    
    public var cornerRadius: CGFloat? = 9.0
    
    public static let none = WXBadge()
    
    public override init() {
        super.init()
    }
}


public class WXBadgeView: UIView {
    
    public let textLabel: UILabel
    
    /// The background image view for badge.
    public let backgroundImageView: UIImageView
    
    /// Convience way to configure badge
    public var badgeValue: String? = nil
    
    public var badge: WXBadge = .none {
        didSet {
            updateBadge()
        }
    }
    
    public override init(frame: CGRect) {
        
        textLabel = UILabel()
        textLabel.font = badge.font
        textLabel.textColor = badge.textColor
        textLabel.textAlignment = .center
        
        backgroundImageView = UIImageView()
        backgroundImageView.backgroundColor = badge.backgroundColor
        
        super.init(frame: frame)
        
        addSubview(backgroundImageView)
        addSubview(textLabel)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundImageView.frame = bounds
        backgroundImageView.layer.cornerRadius = bounds.height/2.0
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateBadge() {
        textLabel.text = badge.text
        
    }
}
