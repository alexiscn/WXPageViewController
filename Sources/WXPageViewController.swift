//
//  WXPageViewController.swift
//  WXPageViewController
//
//  Created by xu.shuifeng on 2020/7/31.
//  Copyright © 2020 alexiscn. All rights reserved.
//

import UIKit

@objc public protocol WXPageViewControllerDataSource: class {
    
    func numberOfPages(in pageViewController: WXPageViewController) -> Int
    
    func pageViewController(_ pageViewController: WXPageViewController, viewControllerAt index: Int) -> UIViewController
    
}

@objc public protocol WXPageViewControllerDelegate: class {
    
    @objc optional func pageViewController(_ pageViewController: WXPageViewController,
                                           didEnterViewController viewController: UIViewController?,
                                           atIndex index: Int)
    
}

public class WXPageViewController: UIViewController {
    
    public weak var delegate: WXPageViewControllerDelegate?
    
    /// The object that acts as the data source of the page view controller.
    public weak var dataSource: WXPageViewControllerDataSource?
    
    /// A Boolean value that controls whether the page view bounces past the edge of content and back again.
    public var bounces: Bool = false {
        didSet {
            contentSrollView?.bounces = bounces
        }
    }
    
    public var selectedIndex: Int = 0 {
        didSet {
            
        }
    }
    
    private var viewHasLaidOut = false
    private var contentView: UIView!
    private var contentSrollView: WXPageScrollView!
    private var pages: [Int: Page] = [:]
    
    var numberOfPages: Int {
        return dataSource?.numberOfPages(in: self) ?? 1
    }
    
    var pageSize: CGSize {
        return contentSrollView.bounds.size
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
        configureLayout()
        addInitialViewController()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        configureLayout()
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
        contentView.addSubview(contentSrollView)
        
        if let interactivePopGR = navigationController?.interactivePopGestureRecognizer {
            contentSrollView.panGestureRecognizer.require(toFail: interactivePopGR)
        }
    }
    
    private func configureLayout() {
        contentView.frame = view.bounds
        contentSrollView.frame = view.bounds
        contentSrollView.contentSize = CGSize(width: CGFloat(numberOfPages) * view.bounds.width,
                                              height: view.bounds.height)
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
