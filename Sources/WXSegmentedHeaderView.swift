//
//  WXSegmentedHeaderView.swift
//  WXPageViewController
//
//  Created by alexiscn on 2020/8/3.
//  Copyright © 2020 alexiscn. All rights reserved.
//

import UIKit

@objc public protocol WXSegmentedHeaderViewDataSource: AnyObject {
 
    func numberOfItemsOfSegmentedHeaderView(_ segmentedView: WXSegmentedHeaderView) -> Int
    
    func segmentedHeaderView(_ segmentedView: WXSegmentedHeaderView,
                             titleAtIndex index: Int) -> String
    
    @objc optional func segmentedHeaderView(_ segmentedView: WXSegmentedHeaderView,
                                            attributedTitleAtIndex index: Int) -> NSAttributedString?
    
    @objc optional func segmentedHeaderView(_ segmentedView: WXSegmentedHeaderView,
                                            badgeAtIndex index: Int) -> WXBadge
    
    @objc optional func segmentedHeaderView(_ segmentedView: WXSegmentedHeaderView,
                                            customBadgeViewAtIndex index: Int) -> UIView
}

@objc public protocol WXSegmentedHeaderViewDelegate: AnyObject {
    
    func segmentedView(_ headerView: WXSegmentedHeaderView, didSelectedIndex index: Int)
    
}

public class WXSegmentedHeaderView: UIView {
    
    public weak var dataSource: WXSegmentedHeaderViewDataSource?
    
    public weak var delegate: WXSegmentedHeaderViewDelegate?
    
    private var collectionView: UICollectionView!
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    public func reloadData() {
        subviews.forEach { $0.removeFromSuperview() }
        
        guard let numberOfItems = dataSource?.numberOfItemsOfSegmentedHeaderView(self) else {
            return
        }
        
    }
    
    public func pageScrollViewDidUpdateScrollingPercent(_ percent: CGFloat) {
        
    }
}

