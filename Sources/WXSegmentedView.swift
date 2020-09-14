//
//  WXSegmentedView.swift
//  WXPageViewController
//
//  Created by xushuifeng on 2020/8/3.
//  Copyright © 2020 alexiscn. All rights reserved.
//

import UIKit

@objc public protocol WXSegmentedViewDataSource: class {
 
    func segmentedView(_ segmentedView: WXSegmentedView,
                       titleAtIndex index: Int) -> String
    
    @objc optional func segmentedView(_ segmentedView: WXSegmentedView,
                                      attributedTitleAtIndex index: Int) -> NSAttributedString?
    
    @objc optional func segmentedView(_ segmentedView: WXSegmentedView,
                                      badgeAtIndex index: Int) -> WXBadge
    
    @objc optional func segmentedView(_ segmentedView: WXSegmentedView,
                                      customBadgeViewAtIndex index: Int) -> UIView
}

@objc public protocol WXSegmentedViewDelegate: class {
    
}

public class WXSegmentedView: UIView {
    
    public weak var dataSource: WXSegmentedViewDataSource?
    
    public weak var delegate: WXSegmentedViewDelegate?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
    }
    
}

@objc public class WXBadge: NSObject {
    
    /// The text content of the badge.
    public var text: String = ""
    
    /// The size for the badge. By default is 18x18.
    public var size: CGSize = CGSize(width: 18, height: 18)
    
    /// The font size for the badge text.
    public var font: UIFont = UIFont.systemFont(ofSize: 9)
    
    /// The background color of the badge.
    public var color: UIColor = .red
    
    public var cornerRadius: CGFloat? = 9.0
    
    public static let none = WXBadge()
    
    public override init() {
        super.init()
    }
}

public class WXBadgeView: UIView {
    
    public let textLabel: UILabel
    
    public let backgroundImageView: UIImageView
    
    public var badge: WXBadge = .none {
        didSet {
            
        }
    }
    
    public override init(frame: CGRect) {
        
        textLabel = UILabel()
        textLabel.font = badge.font
        
        backgroundImageView = UIImageView()
        
        super.init(frame: frame)
        
        addSubview(backgroundImageView)
        addSubview(textLabel)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundImageView.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

public class WXSegmentedItemView: UIView {
    
    public let titleButton: UIButton
    
    public let badgeView: WXBadgeView
    
    public var badge: WXBadge = .none {
        didSet {
            badgeView.badge = badge
        }
    }
    
    public var title: String? = nil {
        didSet {
            
        }
    }
    
    public override init(frame: CGRect) {
        
        titleButton = UIButton(type: .custom)
        
        badgeView = WXBadgeView(frame: .zero)
        
        super.init(frame: frame)
        
        addSubview(titleButton)
        addSubview(badgeView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadData() {
        
    }
}
