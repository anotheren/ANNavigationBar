//
//  NavigationBase+UIViewController.swift
//  ANNavigationBar
//
//  Created by 刘栋 on 2019/3/24.
//  Copyright © 2019 anotheren.com. All rights reserved.
//

import UIKit

private let swizzleMethod: () = {
    UIViewController.swizzleUIViewController
    UINavigationController.swizzleUINavigationController
    UINavigationBar.swizzleUINavigationBar
}()

extension UIViewController: NavigationCompatible { }

extension NavigationBase where Base: UIViewController {
    
    public var barBackgroundImage: UIImage? {
        get {
            swizzleMethod
            return base.navigationBarBackgroundImage
        }
        nonmutating set {
            swizzleMethod
            base.navigationBarBackgroundImage = newValue
        }
    }
    
    public var barBackgroundAplha: CGFloat {
        get {
            swizzleMethod
            return base.navigationBarBackgroundAlpha
        }
        nonmutating set {
            swizzleMethod
            base.navigationBarBackgroundAlpha = newValue
        }
    }
    
    public var tintColor: UIColor {
        get {
            swizzleMethod
            return base.navigationBarTintColor
        }
        nonmutating set {
            swizzleMethod
            base.navigationBarTintColor = newValue
        }
    }
    
    public var barTintColor: UIColor {
        get {
            swizzleMethod
            return base.navigationBarBarTintColor
        }
        nonmutating set {
            swizzleMethod
            base.navigationBarBarTintColor = newValue
        }
    }
    
    public var barTitleColor: UIColor {
        get {
            swizzleMethod
            return base.navigationBarTitleColor
        }
        nonmutating set {
            swizzleMethod
            base.navigationBarTitleColor = newValue
        }
    }
    
    @available(iOS 11.0, *)
    public var barLargeTitleColor: UIColor {
        get {
            swizzleMethod
            return base.navigationBarLargeTitleColor
        }
        nonmutating set {
            swizzleMethod
            base.navigationBarLargeTitleColor = newValue
        }
    }
    
    public var statusBarStyle: UIStatusBarStyle {
        get {
            swizzleMethod
            return base.statusBarStyle
        }
        nonmutating set {
            swizzleMethod
            base.statusBarStyle = newValue
        }
    }
    
    public var isShadowImageHidden: Bool {
        get {
            swizzleMethod
            return base.isNavigationBarShadowImageHidden
        }
        nonmutating set {
            swizzleMethod
            base.isNavigationBarShadowImageHidden = newValue
        }
    }
}
