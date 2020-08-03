//
//  WXSegmentedView.swift
//  WXPageViewController
//
//  Created by xu.shuifeng on 2020/8/3.
//  Copyright © 2020 alexiscn. All rights reserved.
//

import UIKit

protocol WXSegmentedViewDataSource {
    
}

public class WXSegmentedView: UIView {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension WXSegmentedView {
    
    public enum Style {
        case segmented
        case scrollable
    }
    
    public class TitleLabelCell: UICollectionViewCell {
        
    }
    
}
