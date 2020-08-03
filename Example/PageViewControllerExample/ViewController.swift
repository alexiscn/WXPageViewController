//
//  ViewController.swift
//  PageViewControllerExample
//
//  Created by xu.shuifeng on 2020/8/3.
//  Copyright © 2020 alexiscn. All rights reserved.
//

import UIKit
import WXPageViewController

class ViewController: UIViewController {

    var contentViewController: WXPageViewController!
    
    var viewControllers: [ColorViewController] = [
        ColorViewController(color: .systemRed),
        ColorViewController(color: .systemBlue),
        ColorViewController(color: .systemGreen)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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

extension ViewController: WXPageViewControllerDataSource {
    
    func numberOfPages(in pageViewController: WXPageViewController) -> Int {
        return viewControllers.count
    }
    
    func pageViewController(_ pageViewController: WXPageViewController, viewControllerAt index: Int) -> UIViewController {
        return viewControllers[index]
    }
    
    
}

class ColorViewController: UIViewController {
    
    private let color: UIColor
    
    init(color: UIColor) {
        self.color = color
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = color
    }
}
