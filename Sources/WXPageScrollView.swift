//
//  WXPageScrollView.swift
//  WXPageViewController
//
//  Created by xu.shuifeng on 2020/7/31.
//  Copyright © 2020 alexiscn. All rights reserved.
//

import UIKit

@objc public protocol WXScrollViewDelegate: class {
    
    @objc optional func wx_scrollViewDidScroll(_ scrollView: UIScrollView)
    
    @objc optional func wx_scrollViewWillBeginDragging(_ scrollView: UIScrollView)
    
    @objc optional func wx_scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                                     withVelocity velocity: CGPoint,
                                                     targetContentOffset: UnsafeMutablePointer<CGPoint>)
    
    @objc optional func wx_scrollViewDidEndDragging(_ scrollView: UIScrollView,
                                                    willDecelerate decelerate: Bool)

    @objc optional func wx_scrollViewWillBeginDecelerating(_ scrollView: UIScrollView)
    
    @objc optional func wx_scrollViewDidEndDecelerating(_ scrollView: UIScrollView)

    @objc optional func wx_scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView)
    
}

public class WXPageScrollView: UIScrollView, UIGestureRecognizerDelegate {
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return otherGestureRecognizer is UIScreenEdgePanGestureRecognizer
    }
}
