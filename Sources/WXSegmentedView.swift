//
//  WXSegmentedView.swift
//  WXPageViewController
//
//  Created by xu.shuifeng on 2020/8/3.
//  Copyright © 2020 alexiscn. All rights reserved.
//

import UIKit

@objc protocol WXSegmentedViewDataSource: class {
 
    func segmentedView(_ segmentedView: WXSegmentedView,
                       titleAtIndex index: Int) -> String
    
    @objc optional func segmentedView(_ segmentedView: WXSegmentedView,
                                      attributedTitleAtIndex index: Int) -> NSAttributedString?
}

public class WXSegmentedView: UIView {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension WXSegmentedView {
    
    public enum Style {
        case segmented
        case scrollable
    }
    
    public class TitleLabelCell: UICollectionViewCell {
        
        public override init(frame: CGRect) {
            super.init(frame: frame)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    public class BadgeView: UIView {
        
        public override init(frame: CGRect) {
            super.init(frame: frame)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    @objc public class Badge: NSObject {
        
        /// The text content of the badge.
        public var text: String = ""
        
        /// The size for the badge. By default is 18x18.
        public var size: CGSize = CGSize(width: 18, height: 18)
        
        /// The font size for the badge text.
        public var font: UIFont = UIFont.systemFont(ofSize: 9)
        
        /// The background color of the badge.
        public var color: UIColor = .red
        
        public var cornerRadius: CGFloat? = 9.0
        
        public override init() {
            super.init()
        }
    }
    
}
