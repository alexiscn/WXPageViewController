//
//  WXPageViewController.swift
//  WXPageViewController
//
//  Created by xu.shuifeng on 2020/7/31.
//  Copyright © 2020 alexiscn. All rights reserved.
//

import UIKit

/// The methods adopted by the object you use to manage data and provide view controllers for a page view controller.
@objc public protocol WXPageViewControllerDataSource: class {
    
    /// Asks the data source to return the number of pages in the page view controller.
    /// - Parameter pageViewController: An object representing the page view controller requesting this information
    func numberOfPages(in pageViewController: WXPageViewController) -> Int
    
    /// Ask the data source for a  view controller at particular page in the page view controller.
    /// - Parameters:
    ///   - pageViewController: An object representing the page view controller requesting this information
    ///   - index: An index locating the page in the page view controller.
    func pageViewController(_ pageViewController: WXPageViewController, viewControllerAt index: Int) -> UIViewController
    
}

@objc public protocol WXPageViewControllerDelegate: class {
    
    @objc optional func pageViewController(_ pageViewController: WXPageViewController,
                                           didEnterViewController viewController: UIViewController?,
                                           atIndex index: Int)
    
}

public class WXPageViewController: UIViewController {
    
    /// The object that acts as the delegate of the page view controller.
    public weak var delegate: WXPageViewControllerDelegate?
    
    /// The object that acts as the data source of the page view controller.
    public weak var dataSource: WXPageViewControllerDataSource?
    
    /// A Boolean value that controls whether the page view bounces past the edge of content and back again.
    public var bounces: Bool = false {
        didSet {
            contentSrollView?.bounces = bounces
        }
    }
    
    private var _selectedIndex: Int = 0
    public var selectedIndex: Int = 0 {
        didSet {
            if viewHasLaidOut {
                
            } else {
                
            }
        }
    }
    
    private var viewHasLaidOut = false
    private var contentView: UIView!
    private var contentSrollView: WXPageScrollView!
    private var pages: [Int: Page] = [:]
    private var pageFrames: [CGRect] = [] // cache child view controller frame
    
    var numberOfPages: Int {
        return dataSource?.numberOfPages(in: self) ?? 1
    }
    
    var pageSize: CGSize {
        return contentSrollView.bounds.size
    }
    
    private var currentPage: Int {
        get {
            return Int(contentSrollView.contentOffset.x / contentView.bounds.width)
        }
    }
    
    public init(dataSource: WXPageViewControllerDataSource) {
        self.dataSource = dataSource
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSubviews()
        layoutContentViews()
        addInitialViewController()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        layoutContentViews()
        if !viewHasLaidOut {
            viewHasLaidOut = true
            
        }
    }
    
    public override var shouldAutomaticallyForwardAppearanceMethods: Bool {
        return false
    }
    
}

// MARK: - UIScrollViewDelegate
extension WXPageViewController: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        layoutChildViewControllers()
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
    }
}

extension WXPageViewController {
    
    private func configureSubviews() {
        view.clipsToBounds = true
        contentView = UIView(frame: view.bounds)
        contentView.clipsToBounds = true
        view.addSubview(contentView)
         
        contentSrollView = WXPageScrollView()
        contentSrollView.delegate = self
        contentSrollView.clipsToBounds = true
        contentSrollView.isPagingEnabled = true
        contentSrollView.showsVerticalScrollIndicator = false
        contentSrollView.showsHorizontalScrollIndicator = false
        contentSrollView.contentInsetAdjustmentBehavior = .never
        contentSrollView.isDirectionalLockEnabled = true
        contentSrollView.scrollsToTop = false
        contentView.addSubview(contentSrollView)
        
        if let interactivePopGR = navigationController?.interactivePopGestureRecognizer {
            contentSrollView.panGestureRecognizer.require(toFail: interactivePopGR)
        }
    }
    
    private func layoutContentViews() {
        let pageSize = CGSize(width: view.bounds.width, height: view.bounds.height)
        contentView.frame = view.bounds
        contentSrollView.frame = view.bounds
        contentSrollView.contentSize = CGSize(width: CGFloat(numberOfPages) * pageSize.width,
                                              height: pageSize.height)
        pageFrames.removeAll()
        for idx in 0 ..< numberOfPages {
            let frame = CGRect(x: CGFloat(idx) * pageSize.width,
                               y: 0,
                               width: pageSize.width,
                               height: pageSize.height)
            pageFrames.append(frame)
        }
    }
    
    private func layoutChildViewControllers() {
        let totalPages = numberOfPages
        for idx in 0 ..< totalPages {
//            let visible = isPageVisible(pageFrame: pageFrames[idx])
//            print("page :\(idx), visible:\(visible)")
//            if let page = pages[idx] {
//                
//            } else {
//                
//            }
        }
    }
    
    private func isPageVisible(pageFrame: CGRect) -> Bool {
        return view.bounds.intersects(pageFrame)
    }
    
    private func addInitialViewController() {
        addViewController(at: selectedIndex)
        let offset = CGPoint(x: CGFloat(selectedIndex) * pageSize.width, y: 0)
        contentSrollView.setContentOffset(offset, animated: false)
        
        let viewController = pages[selectedIndex]?.viewController
        delegate?.pageViewController?(self, didEnterViewController: viewController, atIndex: selectedIndex)
    }
    
    private func addViewController(at index: Int) {
        if pages.contains(where: { $0.key == index }) {
            return
        }
        guard let viewController = dataSource?.pageViewController(self, viewControllerAt: index) else {
            return
        }
        let page = Page(viewController: viewController, index: index)
        pages[index] = page
        
        let pageSize = contentSrollView.bounds.size
        
        addChild(viewController)
        let frame = CGRect(x: CGFloat(index) * pageSize.width, y: 0, width: pageSize.width, height: pageSize.height)
        viewController.view.frame = frame
        contentSrollView.addSubview(viewController.view)
        viewController.didMove(toParent: self)
    }
    
    private func removeViewController() {
        
    }
    
    private func renderedPercentOfViewController(_ viewController: UIViewController) -> CGFloat {
        let frame = self.view.convert(viewController.view.frame, from: contentSrollView)
        if frame.intersects(view.bounds) {
            let progress = frame.origin.x / frame.size.width
            return 1 - abs(progress)
        } else {
            return 0.0
        }
    }
    
    class Page {
        
        let viewController: UIViewController
        
        var renderedPercent: CGFloat = 0
        
        var index: Int
        
        init(viewController: UIViewController, index: Int) {
            self.viewController = viewController
            self.index = index
        }
        
    }
}
