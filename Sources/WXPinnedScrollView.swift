//
//  WXPinnedScrollView.swift
//  WXPageViewController
//
//  Created by xushuifeng on 2020/9/14.
//

import UIKit

@objc public protocol WXPinnedScrollViewDelegate: UIScrollViewDelegate {
 
    @objc optional func pinnedScrollView(_ scrollView: WXPinnedScrollView,
                                         shouldScrollWithSubview subview: UIScrollView) -> Bool
    
    @objc optional func pinnedScrollView(_ scrollView: WXPinnedScrollView, scrollingProgressChanged progress: CGFloat)
    
    @objc optional func pinnedScrollViewDidScroll(_ scrollView: WXPinnedScrollView)
}

// Pinned Scroll
// https://github.com/maxep/MXParallaxHeader/blob/master/Sources/MXScrollView.m
public class WXPinnedScrollView: UIScrollView, UIGestureRecognizerDelegate, UIScrollViewDelegate {
    
    public var minimumHeaderViewHeight: CGFloat = 0.0
    
    public var maximumHeaderViewHeight: CGFloat = 0.0
    
    private var forwarder: WXScrollViewForwarder!
    private var observedViews: [UIScrollView] = []
    private var isObserving = false
    private var lock: Bool = false
    private static var KScrollViewKVOContext = 0
    private let contentOffsetKeyPath = "contentOffset"
    
    public override var delegate: UIScrollViewDelegate? {
        get { return self.forwarder.delegate }
        set {
            if let delegate = newValue as? WXPinnedScrollViewDelegate {
                self.forwarder.delegate = delegate
                super.delegate = nil
                super.delegate = self.forwarder
            }
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    deinit {
        removeObservedViews()
        removeObserver(self, forKeyPath: contentOffsetKeyPath, context: &WXPinnedScrollView.KScrollViewKVOContext)
    }
    
    private func commonInit() {
        forwarder = WXScrollViewForwarder()
        super.delegate = forwarder
        
        showsVerticalScrollIndicator = false
        isDirectionalLockEnabled = true
        bounces = true
        contentInsetAdjustmentBehavior = .never
        panGestureRecognizer.cancelsTouchesInView = false
        scrollsToTop = false
        addObserver(self, forKeyPath: "contentOffset", options: [.new, .old], context: &WXPinnedScrollView.KScrollViewKVOContext)
        isObserving = true
    }
    
    // MARK: - UIGestureRecognizerDelegate
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if otherGestureRecognizer.view == self {
            return false
        }
        
        // Ignore other gesture than pan
        guard let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer else {
            return false
        }
        
        // Lock horizontal pan gesture.
        let velocity = panGestureRecognizer.velocity(in: self)
        if abs(velocity.x) > abs(velocity.y) {
            return false
        }
        
        // Consider scroll view pan only
        guard let scrollView = otherGestureRecognizer.view as? UIScrollView else {
            return false
        }
        
        // Tricky case: UITableViewWrapperView
        if scrollView.superview is UITableView {
            return false
        }
        
        var shouldScroll = true
        if let delegate = delegate as? WXPinnedScrollViewDelegate {
             shouldScroll = delegate.pinnedScrollView?(self, shouldScrollWithSubview: scrollView) ?? false
        }
        
        if shouldScroll {
            addObservedView(scrollView)
        }
        
        return true
    }
    
    // MARK: - KVO
    
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard context == &WXPinnedScrollView.KScrollViewKVOContext && keyPath == contentOffsetKeyPath else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        
        guard let new = change?[.newKey] as? CGPoint, let old = change?[.oldKey] as? CGPoint else {
            return
        }
        let diff = old.y - new.y
        if diff == 0.0 || !isObserving {
            return
        }
        let maximumContentOffsetY = maximumHeaderViewHeight - minimumHeaderViewHeight
        if let obj = object as? WXPinnedScrollView, obj == self {
            if diff > 0 && lock {
                updateScrollView(self, contentOffset: old)
            } else if self.contentOffset.y < -self.contentInset.top && !self.bounces {
                let offset = CGPoint(x: self.contentOffset.x, y: -self.contentInset.top)
                updateScrollView(self, contentOffset: offset)
            } else if self.contentOffset.y > maximumContentOffsetY {
                let offset = CGPoint(x: self.contentOffset.x, y: maximumContentOffsetY)
                updateScrollView(self, contentOffset: offset)
            } else {
                
            }
            (delegate as? WXPinnedScrollViewDelegate)?.pinnedScrollViewDidScroll?(self)
            let contentOffsetY = max(0, self.contentOffset.y)
            let progress = min(1, contentOffsetY / maximumContentOffsetY)
            (delegate as? WXPinnedScrollViewDelegate)?.pinnedScrollView?(self, scrollingProgressChanged: progress)
            
        } else if let scrollView = object as? UIScrollView {
            // Adjust the observed scrollview's content offset
            lock = scrollView.contentOffset.y > -scrollView.contentInset.top
            
            // Manage scroll up
            if self.contentOffset.y < maximumContentOffsetY - 1 && lock && diff < 0 {
                updateScrollView(scrollView, contentOffset: old)
            }
            
            // Disable bouncing when scroll down
            if !lock && ((self.contentOffset.y > -self.contentInset.top) || self.bounces) {
                let offset = CGPoint(x: scrollView.contentOffset.x, y: -scrollView.contentInset.top)
                updateScrollView(scrollView, contentOffset: offset)
            }
        }
    }
    
    private func updateScrollView(_ scrollView: UIScrollView, contentOffset: CGPoint) {
        isObserving = true
        scrollView.contentOffset = contentOffset
        isObserving = false
    }
    
    private func addObservedView(_ scrollView: UIScrollView) {
        if !observedViews.contains(scrollView) {
            observedViews.append(scrollView)
            addObserverToView(scrollView)
        }
    }
    
    private func addObserverToView(_ scrollView: UIScrollView) {
        lock = scrollView.contentOffset.y > -scrollView.contentInset.top
        scrollView.addObserver(self, forKeyPath: contentOffsetKeyPath, options: [.old, .new], context: &WXPinnedScrollView.KScrollViewKVOContext)
    }
    
    private func removeObservedViews() {
        for scrollView in observedViews {
            removeObserverFromView(scrollView)
        }
        observedViews.removeAll()
    }
    
    private func removeObserverFromView(_ scrollView: UIScrollView) {
        scrollView.removeObserver(self, forKeyPath: contentOffsetKeyPath, context: &WXPinnedScrollView.KScrollViewKVOContext)
    }
    
    // ScrollView
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        lock = false
        removeObservedViews()
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            lock = false
            removeObservedViews()
        }
    }
}

fileprivate class WXScrollViewForwarder: NSObject, UIScrollViewDelegate {
    
    weak var delegate: WXPinnedScrollViewDelegate?
    
    override func responds(to aSelector: Selector!) -> Bool {
        return (delegate?.responds(to: aSelector) ?? false) || super.responds(to: aSelector)
    }
    
    override func forwardingTarget(for aSelector: Selector!) -> Any? {
        return delegate
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        (scrollView as? WXPinnedScrollView)?.scrollViewDidEndDecelerating(scrollView)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        (scrollView as? WXPinnedScrollView)?.scrollViewDidEndDragging(scrollView, willDecelerate: decelerate)
        delegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
    }
}
