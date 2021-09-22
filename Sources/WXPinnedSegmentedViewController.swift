//
//  WXPinnedSegmentedViewController.swift
//  WXPageViewController
//
//  Created by alexiscn on 2020/9/14.
//

import UIKit

public protocol WXPinnedSegmentedViewControllerDataSource: AnyObject {
    
    func numberOfItemsInPinnedSegmentedViewController(_ segmentedViewController: WXPinnedSegmentedViewController) -> Int
    
    func pinnedSegmentedViewController(_ segmentedViewController: WXPinnedSegmentedViewController,
                                       viewControllerAtIndex index: Int) -> UIViewController
    
    func pinnedSegmentedViewController(_ segmentedViewController: WXPinnedSegmentedViewController,
                                       titleAtIndex index: Int) -> String
}

public protocol WXPinnedSegmentedViewControllerDelgate: AnyObject {
    
}

public class WXPinnedSegmentedViewController: UIViewController {

    public var minimumHeaderViewHeight: CGFloat = 44.0 {
        didSet {
            contentView.minimumHeaderViewHeight = minimumHeaderViewHeight
        }
    }
    
    public var maximumHeaderViewHeight: CGFloat = 44.0 {
        didSet {
            contentView.maximumHeaderViewHeight = maximumHeaderViewHeight
        }
    }
    
    public weak var dataSource: WXPinnedSegmentedViewControllerDataSource?
    
    private lazy var contentView: WXPinnedScrollView = {
        let _contentView = WXPinnedScrollView()
        _contentView.delegate = self
        return _contentView
    }()
    
    private var contentViewController: WXSegmentedViewController!
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        configureContentController()
    }
    
    public override func loadView() {
        contentView.frame = UIScreen.main.bounds
        self.view = contentView
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        contentView.contentSize = CGSize(width: view.bounds.width, height: view.bounds.height + maximumHeaderViewHeight)
    }

    private func configureContentController() {
        contentViewController = WXSegmentedViewController()
        contentViewController.dataSource = self
        addChild(contentViewController)
        contentViewController.view.frame = view.bounds
        view.addSubview(contentViewController.view)
        contentViewController.didMove(toParent: self)
    }
}

// MARK: - WXPinnedScrollViewDelegate
extension WXPinnedSegmentedViewController: WXPinnedScrollViewDelegate {
    
    public func pinnedScrollView(_ scrollView: WXPinnedScrollView, shouldScrollWithSubview subview: UIScrollView) -> Bool {
        if subview is WXPageViewController.WXPageCollectionView {
            return false
        }
        return true
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
}

// MARK: - WXSegmentedViewControllerDataSource
extension WXPinnedSegmentedViewController: WXSegmentedViewControllerDataSource {
    
    public func numberOfItemsFor(_ segmentedViewController: WXSegmentedViewController) -> Int {
        return dataSource?.numberOfItemsInPinnedSegmentedViewController(self) ?? 0
    }
    
    public func segmentedViewController(_ segmentedViewController: WXSegmentedViewController, viewControllerAt index: Int) -> UIViewController {
        return dataSource?.pinnedSegmentedViewController(self, viewControllerAtIndex: index) ?? UIViewController()
    }
    
    public func segmentedViewController(_ segmentedViewController: WXSegmentedViewController, titleAtIndex index: Int) -> String {
        return dataSource?.pinnedSegmentedViewController(self, titleAtIndex: index) ?? ""
    }
}
