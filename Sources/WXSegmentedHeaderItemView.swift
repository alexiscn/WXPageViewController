//
//  WXSegmentedHeaderItemView.swift
//  WXPageViewController
//
//  Created by alexiscn on 2020/10/28.
//

import UIKit

public class WXSegmentedHeaderItemView: UIView {
    
    public let titleButton: UIButton
    
    public let badgeView: WXBadgeView
    
    public var badge: WXBadge = .none {
        didSet {
            badgeView.badge = badge
        }
    }
    
    /// Text that is displayed in the upper-right corner of the item with a surrounding red oval.
    public var badgValue: String? = nil {
        didSet {
            badge.text = badgValue
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    /// The background color to apply to the badge.
    public var badgeColor: UIColor? = nil
    
    public var title: String? = nil {
        didSet {
            
        }
    }
    
    public var rate: CGFloat = 0.0 {
        didSet {
            
        }
    }
    
    public override init(frame: CGRect) {
        
        titleButton = UIButton(type: .custom)
        
        badgeView = WXBadgeView(frame: .zero)
        
        super.init(frame: frame)
        
        addSubview(titleButton)
        addSubview(badgeView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        titleButton.frame = bounds
    }
    
    public func reloadData() {
        
    }
}

extension UIColor {
    
    var components: (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        let components = self.cgColor.components!

        switch components.count == 2 {
        case true : return (r: components[0], g: components[0], b: components[0], a: components[1])
        case false: return (r: components[0], g: components[1], b: components[2], a: components[3])
        }
    }
    
    static func interpolate(from fromColor: UIColor, to toColor: UIColor, with progress: CGFloat) -> UIColor {
        let fromComponents = fromColor.components
        let toComponents = toColor.components

        let r = (1 - progress) * fromComponents.r + progress * toComponents.r
        let g = (1 - progress) * fromComponents.g + progress * toComponents.g
        let b = (1 - progress) * fromComponents.b + progress * toComponents.b
        let a = (1 - progress) * fromComponents.a + progress * toComponents.a

        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}
