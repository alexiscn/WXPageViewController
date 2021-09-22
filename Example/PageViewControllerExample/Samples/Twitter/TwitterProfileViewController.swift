//
//  TwitterProfileViewController.swift
//  PageViewControllerExample
//
//  Created by xu.shuifeng on 2020/9/14.
//  Copyright © 2020 alexiscn. All rights reserved.
//

import UIKit
import WXPageViewController

class TwitterProfileHeaderView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class TwitterProfileViewController: UIViewController {

    private var contentViewController: WXPageViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
    }

}
