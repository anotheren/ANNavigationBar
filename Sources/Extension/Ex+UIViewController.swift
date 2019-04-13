//
//  Ex+UIViewController.swift
//  ANNavigationBar
//
//  Created by 刘栋 on 2019/3/23.
//  Copyright © 2019 anotheren.com. All rights reserved.
//

import UIKit
import ObjectiveC

private var isPushToCurrentViewControllerFinishedAssociatedKey: UInt8 = 0
private var isPushToNextViewControllerFinishedAssociatedKey: UInt8 = 0

private var navigationBarBackgroundImageAssociatedKey: UInt8 = 0
private var navigationBarBarTintColorAssociatedKey: UInt8 = 0
private var navigationBarBackgroundAlphaAssociatedKey: UInt8 = 0
private var navigationBarTintColorAssociatedKey: UInt8 = 0
private var navigationBarTitleColorAssociatedKey: UInt8 = 0

private var isNavigationBarShadowImageHiddenAssociatedKey: UInt8 = 0

private var statusBarStyledAssociatedKey: UInt8 = 0

private var customNavigationBarAssociatedKey: UInt8 = 0

// MARK: - Associated Object

extension UIViewController {
    
    // navigationBar barTintColor can not change by currentVC before fromVC push to currentVC finished
    var isPushToCurrentViewControllerFinished: Bool {
        get {
            guard let isFinished = objc_getAssociatedObject(self, &isPushToCurrentViewControllerFinishedAssociatedKey) as? Bool else {
                return false
            }
            return isFinished
        }
        set {
            objc_setAssociatedObject(self, &isPushToCurrentViewControllerFinishedAssociatedKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    // navigationBar barTintColor can not change by currentVC when currentVC push to nextVC finished
    var isPushToNextViewControllerFinished: Bool {
        get {
            guard let isFinished = objc_getAssociatedObject(self, &isPushToNextViewControllerFinishedAssociatedKey) as? Bool else {
                return false
            }
            return isFinished
        }
        set {
            objc_setAssociatedObject(self, &isPushToNextViewControllerFinishedAssociatedKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    // you can set navigationBar backgroundImage
    var navigationBarBackgroundImage: UIImage? {
        get {
            guard let backgroundImage = objc_getAssociatedObject(self, &navigationBarBackgroundImageAssociatedKey) as? UIImage else {
                return nil
            }
            return backgroundImage
        }
        set {
            objc_setAssociatedObject(self, &navigationBarBackgroundImageAssociatedKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        // TODO
        //        set {
        //            if customNavBar.isKind(of: UINavigationBar.self) {
        //                let navBar = customNavBar as! UINavigationBar
        //                navBar.wr_setBackgroundImage(image: newValue!)
        //            }
        //            else {
        //                objc_setAssociatedObject(self, &AssociatedKeys.navBarBackgroundImage, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        //            }
        //        }
    }
    
    // navigationBar barTintColor
    var navigationBarBarTintColor: UIColor {
        get {
            guard let barTintColor = objc_getAssociatedObject(self, &navigationBarBarTintColorAssociatedKey) as? UIColor else {
                return .clear // TODO
            }
            return barTintColor
        }
        set {
            objc_setAssociatedObject(self, &navigationBarBarTintColorAssociatedKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            // TODO
//            if customNavBar.isKind(of: UINavigationBar.self) {
//                //                let navBar = customNavBar as! UINavigationBar
//                //                navBar.wr_setBackgroundColor(color: newValue)
//            }
//            else {
//                if canUpdateNavBarBarTintColorOrBackgroundAlpha == true {
//                    navigationController?.setNeedsNavigationBarUpdate(barTintColor: newValue)
//                }
//            }
        }
    }
    
    // navigationBar _UIBarBackground alpha
    var navigationBarBackgroundAlpha: CGFloat {
        get {
            guard let backgroundAlpha = objc_getAssociatedObject(self, &navigationBarBackgroundAlphaAssociatedKey) as? CGFloat else {
                return 1.0
            }
            return backgroundAlpha
        }
        set {
            objc_setAssociatedObject(self, &navigationBarBackgroundAlphaAssociatedKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            // TODO
//            if customNavBar.isKind(of: UINavigationBar.self) {
//                //                let navBar = customNavBar as! UINavigationBar
//                //                navBar.wr_setBackgroundAlpha(alpha: newValue)
//            }
//            else {
//                if canUpdateNavBarBarTintColorOrBackgroundAlpha == true {
//                    navigationController?.setNeedsNavigationBarUpdate(barBackgroundAlpha: newValue)
//                }
//            }
        }
    }
    
    // navigationBar tintColor
    var navigationBarTintColor: UIColor {
        get {
            guard let tintColor = objc_getAssociatedObject(self, &navigationBarTintColorAssociatedKey) as? UIColor else {
                return .clear
            }
            return tintColor
        }
        set {
            objc_setAssociatedObject(self, &navigationBarTintColorAssociatedKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
//            if customNavBar.isKind(of: UINavigationBar.self) {
//                //                let navBar = customNavBar as! UINavigationBar
//                //                navBar.tintColor = newValue
//            }
//            else
//            {
//                if pushToNextVCFinished == false {
//                    navigationController?.setNeedsNavigationBarUpdate(tintColor: newValue)
//                }
//            }
        }
    }
    
    // navigationBar titleColor
    var navigationBarTitleColor: UIColor {
        get {
            guard let titleColor = objc_getAssociatedObject(self, &navigationBarTitleColorAssociatedKey) as? UIColor else {
                return .clear
            }
            return titleColor
        }
        set {
            objc_setAssociatedObject(self, &navigationBarTitleColorAssociatedKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
//            if customNavBar.isKind(of: UINavigationBar.self) {
//                //                let navBar = customNavBar as! UINavigationBar
//                //                navBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:newValue]
//            }
//            else
//            {
//                if pushToNextVCFinished == false {
//                    navigationController?.setNeedsNavigationBarUpdate(titleColor: newValue)
//                }
//            }
        }
    }
    
    // statusBarStyle
    var statusBarStyle: UIStatusBarStyle {
        get {
            guard let style = objc_getAssociatedObject(self, &statusBarStyledAssociatedKey) as? UIStatusBarStyle else {
                return .default
            }
            return style
        }
        set {
            objc_setAssociatedObject(self, &statusBarStyledAssociatedKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    // if you want shadowImage hidden,you can via hideShadowImage = true
    var isNavigationBarShadowImageHidden: Bool {
        get {
            guard let isHidden = objc_getAssociatedObject(self, &isNavigationBarShadowImageHiddenAssociatedKey) as? Bool else {
                return false
            }
            return isHidden
        }
        set {
            objc_setAssociatedObject(self, &isNavigationBarShadowImageHiddenAssociatedKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
            navigationController?.setNeedsNavigationBarUpdate(isHidedShadowImage: newValue)
        }
    }
    
    // custom navigationBar
    var customNavigationBar: UIView? {
        get {
            let navigationBar = objc_getAssociatedObject(self, &customNavigationBarAssociatedKey) as? UIView
            return navigationBar
        }
        set {
            objc_setAssociatedObject(self, &customNavigationBarAssociatedKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            // TODO
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
        return navigationController != nil && isBat
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
                navigationController?.setNeedsNavigationBarUpdate(barTintColor: navigationBarTintColor)
            }
            navigationController?.setNeedsNavigationBarUpdate(barBackgroundAlpha: navigationBarBackgroundAlpha)
            navigationController?.setNeedsNavigationBarUpdate(tintColor: navigationBarTintColor)
            navigationController?.setNeedsNavigationBarUpdate(titleColor: navigationBarTitleColor)
            navigationController?.setNeedsNavigationBarUpdate(isHidedShadowImage: isNavigationBarShadowImageHidden)
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
