//
//  WXSegmentedViewController.swift
//  WXPageViewController
//
//  Created by xushuifeng on 2020/8/3.
//  Copyright © 2020 alexiscn. All rights reserved.
//

import UIKit

/// The methods adopted by the object you use to manage data and provide view controllers for a segmented view controller.
@objc public protocol WXSegmentedViewControllerDataSource: class {
 
    /// Asks the data source to return the number of pages in the segmented  view controller.
    /// - Parameter segmentedViewController: An object representing the segmented view controller requesting this information
    func numberOfItemsFor(_ segmentedViewController: WXSegmentedViewController) -> Int
    
    func segmentedViewController(_ segmentedViewController: WXSegmentedViewController,
                                 viewControllerAt index: Int) -> UIViewController
    
    /// Ask the data source to return the title at particular index of the segmented view controller.
    /// - Parameters:
    ///   - segmentedViewController: An object representing the segmented view controller requesting this information
    ///   - index: An index locating the page in the segmented view controller.
    func segmentedViewController(_ segmentedViewController: WXSegmentedViewController,
                                 titleAtIndex index: Int) -> String
    
}

@objc public protocol WXSegmentedViewControllerDelegate: class {
    
    @objc optional func segmentedViewController(_ segmentedViewController: WXSegmentedViewController,
                                                didEnterViewController viewController: UIViewController?,
                                                atIndex index: Int)
    
}

public class WXSegmentedViewController: UIViewController {
    
    public var selectedIndex: Int = 0
    
    public weak var dataSource: WXSegmentedViewControllerDataSource?
    
    public weak var delegate: WXSegmentedViewControllerDelegate?
    
    private var headerView: WXSegmentedView!
    
    private var pageViewController: WXPageViewController!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        configurePageViewController()
        configureHeaderView()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    private func configurePageViewController() {
        pageViewController = WXPageViewController(dataSource: self)
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.view.frame = view.bounds
        pageViewController.didMove(toParent: self)
    }
    
    private func configureHeaderView() {
        
    }
    
}

// MARK: - WXPageViewControllerDataSource
extension WXSegmentedViewController: WXPageViewControllerDataSource {
    
    public func numberOfPages(in pageViewController: WXPageViewController) -> Int {
        return dataSource?.numberOfItemsFor(self) ?? 1
    }
    
    public func pageViewController(_ pageViewController: WXPageViewController, viewControllerAt index: Int) -> UIViewController {
        return dataSource?.segmentedViewController(self, viewControllerAt: index) ?? UIViewController()
    }
}

// MARK: - WXPageViewControllerDelegate
extension WXSegmentedViewController: WXPageViewControllerDelegate {
    
    public func pageViewController(_ pageViewController: WXPageViewController, didUpdatedScrollingPercent percent: CGFloat) {
        
    }
    
    public func pageViewController(_ pageViewController: WXPageViewController, didEnterViewController viewController: UIViewController?, atIndex index: Int) {
        
    }
}
