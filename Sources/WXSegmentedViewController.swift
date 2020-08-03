//
//  WXSegmentedViewController.swift
//  WXPageViewController
//
//  Created by xu.shuifeng on 2020/8/3.
//  Copyright © 2020 alexiscn. All rights reserved.
//

import UIKit

@objc public protocol WXSegmentedViewControllerDataSource: class {
    
}

@objc public protocol WXSegmentedViewControllerDelegate: class {
    
}

public class WXSegmentedViewController: UIViewController {
    
    public var selectedIndex: Int = 0
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}
