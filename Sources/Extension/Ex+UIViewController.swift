//
//  Ex+UIViewController.swift
//  ANNavigationBar
//
//  Created by 刘栋 on 2019/3/23.
//  Copyright © 2019 anotheren.com. All rights reserved.
//

import UIKit
import ObjectiveC

// MARK: - Associated Object

extension UIViewController {
    
    private struct AssociatedKey {
        
        static var isPushToCurrentViewControllerFinished: UInt8 = 0
        static var isPushToNextViewControllerFinished: UInt8 = 0
        
        static var navigationBarBackgroundImage: UInt8 = 0
        static var navigationBarBackgroundAlpha: UInt8 = 0
        static var navigationBarBarTintColor: UInt8 = 0
        static var navigationBarTintColor: UInt8 = 0
        static var navigationBarTitleColor: UInt8 = 0
        static var isNavigationBarShadowImageHidden: UInt8 = 0
        static var statusBarStyle: UInt8 = 0
    }
    
    // navigationBar barTintColor can not change by currentVC before fromVC push to currentVC finished
    var isPushToCurrentViewControllerFinished: Bool {
        get {
            guard let isFinished = objc_getAssociatedObject(self, &AssociatedKey.isPushToCurrentViewControllerFinished) as? Bool else {
                return false
            }
            return isFinished
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.isPushToCurrentViewControllerFinished, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    // navigationBar barTintColor can not change by currentVC when currentVC push to nextVC finished
    var isPushToNextViewControllerFinished: Bool {
        get {
            guard let isFinished = objc_getAssociatedObject(self, &AssociatedKey.isPushToNextViewControllerFinished) as? Bool else {
                return false
            }
            return isFinished
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.isPushToNextViewControllerFinished, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    // you can set navigationBar backgroundImage
    var navigationBarBackgroundImage: UIImage? {
        get {
            guard let backgroundImage = objc_getAssociatedObject(self, &AssociatedKey.navigationBarBackgroundImage) as? UIImage else {
                return nil
            }
            return backgroundImage
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.navigationBarBackgroundImage, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    // navigationBar barTintColor
    var navigationBarBarTintColor: UIColor {
        get {
            guard let barTintColor = objc_getAssociatedObject(self, &AssociatedKey.navigationBarBarTintColor) as? UIColor else {
                return UIColor.navigationBarBarTintColor
            }
            return barTintColor
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.navigationBarBarTintColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // navigationBar _UIBarBackground alpha
    var navigationBarBackgroundAlpha: CGFloat {
        get {
            guard let backgroundAlpha = objc_getAssociatedObject(self, &AssociatedKey.navigationBarBackgroundAlpha) as? CGFloat else {
                return 1.0
            }
            return backgroundAlpha
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.navigationBarBackgroundAlpha, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // navigationBar tintColor
    var navigationBarTintColor: UIColor {
        get {
            guard let tintColor = objc_getAssociatedObject(self, &AssociatedKey.navigationBarTintColor) as? UIColor else {
                return UIColor.navigationBarTintColor
            }
            return tintColor
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.navigationBarTintColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // navigationBar titleColor
    var navigationBarTitleColor: UIColor {
        get {
            guard let titleColor = objc_getAssociatedObject(self, &AssociatedKey.navigationBarTitleColor) as? UIColor else {
                return UIColor.navigationBarTitleColor
            }
            return titleColor
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.navigationBarTitleColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // statusBarStyle
    var statusBarStyle: UIStatusBarStyle {
        get {
            guard let style = objc_getAssociatedObject(self, &AssociatedKey.statusBarStyle) as? UIStatusBarStyle else {
                return .default
            }
            return style
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.statusBarStyle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    // if you want shadowImage hidden,you can via hideShadowImage = true
    var isNavigationBarShadowImageHidden: Bool {
        get {
            guard let isHidden = objc_getAssociatedObject(self, &AssociatedKey.isNavigationBarShadowImageHidden) as? Bool else {
                return false
            }
            return isHidden
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.isNavigationBarShadowImageHidden, newValue, .OBJC_ASSOCIATION_ASSIGN)
            navigationController?.setNeedsNavigationBarUpdate(isShadowImageHidden: newValue)
        }
    }
    
    var canUpdateNavigatiobBarBarTintColorOrBackgroundAlpha: Bool {
        let isRootViewController = navigationController?.viewControllers.first == self
        return (isPushToCurrentViewControllerFinished || isRootViewController) && !isPushToNextViewControllerFinished
    }
    
    var canUpdateNavigationBar: Bool {
        let viewFrame = view.frame
        let maxFrame = UIScreen.main.bounds
        let midFrame = CGRect(x: 0,
                              y: UIDevice.navigationBarBottom,
                              width: UIScreen.main.bounds.width,
                              height: UIScreen.main.bounds.height-UIDevice.navigationBarBottom)
        let minFrame = CGRect(x: 0,
                              y: UIDevice.navigationBarBottom,
                              width: UIScreen.main.bounds.width,
                              height: UIScreen.main.bounds.height-UIDevice.navigationBarBottom-UIDevice.tabBarHeight)
        let isBat = (viewFrame == maxFrame || viewFrame == midFrame || viewFrame == minFrame)
        let result = navigationController != nil && isBat
        return result
    }
}

// MARK: - Swizzled Method

extension UIViewController {
    
    @objc private func swizzledViewWillAppear(_ animated: Bool) {
        if canUpdateNavigationBar {
            isPushToNextViewControllerFinished = false
            navigationController?.setNeedsNavigationBarUpdate(tintColor: navigationBarTintColor)
            navigationController?.setNeedsNavigationBarUpdate(titleColor: navigationBarTitleColor)
        }
        swizzledViewWillAppear(animated)
    }
    
    @objc private func swizzledViewWillDisappear(_ animated: Bool) {
        if canUpdateNavigationBar {
            isPushToNextViewControllerFinished = true
        }
        swizzledViewWillDisappear(animated)
    }
    
    @objc private func swizzledViewDidAppear(_ animated: Bool)  {
        if navigationController?.viewControllers.first != self {
            isPushToCurrentViewControllerFinished = true
        }
        if canUpdateNavigationBar {
            if let navigationBarBackgroundImage = navigationBarBackgroundImage {
                navigationController?.setNeedsNavigationBarUpdate(backgroundImage: navigationBarBackgroundImage)
            } else {
                navigationController?.setNeedsNavigationBarUpdate(barTintColor: navigationBarBarTintColor)
            }
            navigationController?.setNeedsNavigationBarUpdate(barBackgroundAlpha: navigationBarBackgroundAlpha)
            navigationController?.setNeedsNavigationBarUpdate(tintColor: navigationBarTintColor)
            navigationController?.setNeedsNavigationBarUpdate(titleColor: navigationBarTitleColor)
            navigationController?.setNeedsNavigationBarUpdate(isShadowImageHidden: isNavigationBarShadowImageHidden)
        }
        swizzledViewDidAppear(animated)
    }
}

// MARK: - Swizzle Method

extension UIViewController {
    
    static let swizzleUIViewController: () = {
        swizzleViewWillAppear
        swizzleViewWillDisappear
        swizzleViewDidAppear
    }()
    
    private static let swizzleViewWillAppear: () = {
        let originalSelector = #selector(UIViewController.viewWillAppear)
        let swizzledSelector = #selector(UIViewController.swizzledViewWillAppear)
        SwizzleHelper.swizzleMethod(for: UIViewController.self, originalSelector: originalSelector, swizzledSelector: swizzledSelector)
    }()
    
    private static let swizzleViewWillDisappear: () = {
        let originalSelector = #selector(UIViewController.viewWillDisappear)
        let swizzledSelector = #selector(UIViewController.swizzledViewWillDisappear)
        SwizzleHelper.swizzleMethod(for: UIViewController.self, originalSelector: originalSelector, swizzledSelector: swizzledSelector)
    }()
    
    private static let swizzleViewDidAppear: () = {
        let originalSelector = #selector(UIViewController.viewDidAppear)
        let swizzledSelector = #selector(UIViewController.swizzledViewDidAppear)
        SwizzleHelper.swizzleMethod(for: UIViewController.self, originalSelector: originalSelector, swizzledSelector: swizzledSelector)
    }()
}
