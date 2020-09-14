//
//  WXPinnedSegmentedViewController.swift
//  WXPageViewController
//
//  Created by xushuifeng on 2020/9/14.
//

import UIKit

public protocol WXPinnedSegmentedViewControllerDataSource: class {
    
}

public protocol WXPinnedSegmentedViewControllerDelgate: class {
    
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
        
    }
}


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
