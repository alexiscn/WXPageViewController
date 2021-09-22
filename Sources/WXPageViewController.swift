//
//  WXPageViewController.swift
//  WXPageViewController
//
//  Created by xushuifeng on 2020/7/31.
//  Copyright © 2020 alexiscn. All rights reserved.
//

import UIKit

/// The methods adopted by the object you use to manage data and provide view controllers for a page view controller.
@objc public protocol WXPageViewControllerDataSource: AnyObject {
    
    /// Asks the data source to return the number of pages in the page view controller.
    /// - Parameter pageViewController: An object representing the page view controller requesting this information
    func numberOfPages(in pageViewController: WXPageViewController) -> Int
    
    /// Ask the data source for a  view controller at particular page in the page view controller.
    /// - Parameters:
    ///   - pageViewController: An object representing the page view controller requesting this information
    ///   - index: An index locating the page in the page view controller.
    func pageViewController(_ pageViewController: WXPageViewController,
                            viewControllerAt index: Int) -> UIViewController
    
}

@objc public protocol WXPageViewControllerDelegate: AnyObject {
    
    @objc optional func pageViewController(_ pageViewController: WXPageViewController,
                                           didUpdatedScrollingPercent percent: CGFloat)
    
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
        didSet { pageView.bounces = bounces }
    }
    
    /// A Boolean value that
    public var isScrollEnabled: Bool = true {
        didSet { pageView.isScrollEnabled = isScrollEnabled }
    }
    
    private var _selectedIndex: Int = 0
    public var selectedIndex: Int {
        get {
            if viewHasLaidOut {
                return Int(pageView.contentOffset.x / pageView.bounds.width)
            } else {
                return _selectedIndex
            }
        }
        set {
            if viewHasLaidOut {
                let x = CGFloat(newValue) * pageView.bounds.width
                pageView.setContentOffset(CGPoint(x: x, y: 0), animated: true)
            } else {
                _selectedIndex = newValue
            }
        }
    }
    
    private var viewHasLaidOut = false
    
    private var pageView: UICollectionView!
    
    internal class PageCell: UICollectionViewCell {
        
        class var identifier: String { return "PagerCell" }
                
        weak var containerViewController: UIViewController?
        weak var viewController: UIViewController? {
            willSet {
                viewController?.willMove(toParent: nil)
                viewController?.view.removeFromSuperview()
                viewController?.removeFromParent()
            }
            didSet {
                if let viewController = viewController, let containerVC = containerViewController {
                    containerVC.addChild(viewController)
                    viewController.view.frame = contentView.bounds
                    contentView.addSubview(viewController.view)
                    viewController.didMove(toParent: containerVC)
                    containerVC.setNeedsStatusBarAppearanceUpdate()
                }
            }
        }
    }
    
    public class WXPageCollectionView: UICollectionView {
        
    }
    
    var numberOfPages: Int {
        return dataSource?.numberOfPages(in: self) ?? 1
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
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        pageView.frame = view.bounds
        if !viewHasLaidOut {
            viewHasLaidOut = true
            
            pageView.reloadData()
            
            let indexPath = IndexPath(item: _selectedIndex, section: 0)
            pageView.scrollToItem(at: indexPath, at: [], animated: false)
        }
    }
    
    public func setSelectedIndex(_ newIndex: Int, animated: Bool) {
        
    }
    
    public override var shouldAutomaticallyForwardAppearanceMethods: Bool {
        return false
    }
    
}

// MARK: - UICollectionViewDataSource & UICollectionViewDelegate
extension WXPageViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.numberOfPages(in: self) ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PageCell.identifier, for: indexPath) as! PageCell
        cell.containerViewController = self
        cell.viewController = dataSource?.pageViewController(self, viewControllerAt: indexPath.item)
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
}

// MARK: - UIScrollViewDelegate
extension WXPageViewController: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.contentSize.width != 0 else { return }
        
        let pageSize = scrollView.bounds.size
        var x = scrollView.contentOffset.x
        x = min(max(0, x), scrollView.contentSize.width - pageSize.width)
        let percent = x / pageSize.width
        delegate?.pageViewController?(self, didUpdatedScrollingPercent: percent)
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let viewController = dataSource?.pageViewController(self, viewControllerAt: selectedIndex)
        delegate?.pageViewController?(self, didEnterViewController: viewController, atIndex: selectedIndex)
    }
}

// MARK: - Private Work
extension WXPageViewController {
    
    private func configureSubviews() {
        
        if #available(iOS 13, *) {
            view.backgroundColor = UIColor.systemBackground
        } else {
            view.backgroundColor = UIColor.white
        }
        
        view.clipsToBounds = true
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        pageView = WXPageCollectionView(frame: .zero, collectionViewLayout: layout)
        pageView.backgroundColor = .clear
        pageView.showsVerticalScrollIndicator = false
        pageView.showsHorizontalScrollIndicator = false
        pageView.isPagingEnabled = true
        pageView.contentInsetAdjustmentBehavior = .never
        pageView.bounces = bounces
        pageView.isPrefetchingEnabled = false
        pageView.isDirectionalLockEnabled = true
        pageView.scrollsToTop = false
        pageView.register(PageCell.self, forCellWithReuseIdentifier: PageCell.identifier)
        pageView.dataSource = self
        pageView.delegate = self
        view.addSubview(pageView)

        if let interactivePopGR = navigationController?.interactivePopGestureRecognizer {
            pageView.panGestureRecognizer.require(toFail: interactivePopGR)
        }
    }

    private func isPageVisible(pageFrame: CGRect) -> Bool {
        return view.bounds.intersects(pageFrame)
    }
}
