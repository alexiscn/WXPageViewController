//
//  WXSegmentedViewController.swift
//  WXPageViewController
//
//  Created by xu.shuifeng on 2020/8/3.
//  Copyright © 2020 alexiscn. All rights reserved.
//

import UIKit

/// The methods adopted by the object you use to manage data and provide view controllers for a segmented view controller.
@objc public protocol WXSegmentedViewControllerDataSource: class {
 
    /// Asks the data source to return the number of pages in the segmented  view controller.
    /// - Parameter segmentedViewController: An object representing the segmented view controller requesting this information
    func numberOfItemsForSegmentedViewController(_ segmentedViewController: WXSegmentedViewController) -> Int
    
    /// Ask the data source to return the title at particular index of the segmented view controller.
    /// - Parameters:
    ///   - segmentedViewController: An object representing the segmented view controller requesting this information
    ///   - index: An index locating the page in the segmented view controller.
    func segmentedViewController(_ segmentedViewController: WXSegmentedViewController, titleAtIndex index: Int) -> String
    
}

@objc public protocol WXSegmentedViewControllerDelegate: class {
    
}

public class WXSegmentedViewController: UIViewController {
    
    public var selectedIndex: Int = 0
    
    private var pageViewController: WXPageViewController!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
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
}

// MARK: - WXPageViewControllerDataSource
extension WXSegmentedViewController: WXPageViewControllerDataSource {
    
    public func numberOfPages(in pageViewController: WXPageViewController) -> Int {
        return 0
    }
    
    public func pageViewController(_ pageViewController: WXPageViewController, viewControllerAt index: Int) -> UIViewController {
        return UIViewController()
    }
}
