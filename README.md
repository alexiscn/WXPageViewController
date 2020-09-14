# WXPageViewController
A replacement for UIPageViewController

| Name | Description |
| -- | -- |
| WXPageViewController | A replacement view controller of UIPageViewController |
| WXSegmentedViewController | |
| WXPinnedSegmentedViewController | |


## WXPageViewController

```swift
@objc public protocol WXPageViewControllerDataSource: class {
    
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
```

You can use `WXPageViewController` as child view controller of your view controller.

```swift
pageViewController = WXPageViewController(dataSource: self)
addChild(pageViewController)
view.addSubview(pageViewController.view)
pageViewController.view.frame = view.bounds
pageViewController.didMove(toParent: self)
```

OR, you can subclass `WXPageViewController`.

## WXSegmentedViewController

// TODO

## WXPinnedSegmentedViewController

// TODO
