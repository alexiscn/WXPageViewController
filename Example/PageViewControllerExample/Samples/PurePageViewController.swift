//
//  PurePageViewController.swift
//  PageViewControllerExample
//
//  Created by xu.shuifeng on 2020/8/7.
//  Copyright © 2020 alexiscn. All rights reserved.
//

import UIKit
import WXPageViewController

class PurePageViewController: UIViewController {

    var contentViewController: WXPageViewController!
    
    var viewControllers: [ColorViewController] = [
        ColorViewController(color: .systemRed),
        ColorViewController(color: .systemBlue),
        ColorViewController(color: .systemGreen)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureContentViewController()
    }
    
    private func configureContentViewController() {
        contentViewController = WXPageViewController(dataSource: self)
        contentViewController.selectedIndex = 2
        addChild(contentViewController)
        contentViewController.view.frame = view.bounds
        view.addSubview(contentViewController.view)
        contentViewController.didMove(toParent: self)
    }

}

extension PurePageViewController: WXPageViewControllerDataSource {
    
    func numberOfPages(in pageViewController: WXPageViewController) -> Int {
        return viewControllers.count
    }
    
    func pageViewController(_ pageViewController: WXPageViewController, viewControllerAt index: Int) -> UIViewController {
        return viewControllers[index]
    }
    
    
}
