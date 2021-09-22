//
//  TwitterTimelineViewController.swift
//  PageViewControllerExample
//
//  Created by xu.shuifeng on 2020/10/31.
//  Copyright © 2020 alexiscn. All rights reserved.
//

import UIKit

class TwitterTimelineViewController: UIViewController {

    private var tableView: UITableView!
    
    private var dataSource: [TwitterStatus] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: view.bounds)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 0
        tableView.register(TwitterTimelineTableViewCell.self,
                           forCellReuseIdentifier: NSStringFromClass(TwitterTimelineTableViewCell.self))
        view.addSubview(tableView)
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension TwitterTimelineViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(TwitterTimelineTableViewCell.self),
                                                 for: indexPath) as! TwitterTimelineTableViewCell
        let status = dataSource[indexPath.item]
        cell.update(status)
        return cell
    }
}
