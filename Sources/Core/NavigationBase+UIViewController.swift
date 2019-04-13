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
        set {
            swizzleMethod
            base.navigationBarBackgroundImage = newValue
        }
    }
    
    public var barTintColor: UIColor {
        get {
            swizzleMethod
            return base.navigationBarTintColor
        }
        set {
            swizzleMethod
            base.navigationBarTintColor = newValue
        }
    }
    
    public var barTitleColor: UIColor {
        get {
            swizzleMethod
            return base.navigationBarTitleColor
        }
        set {
            swizzleMethod
            base.navigationBarTitleColor = newValue
        }
    }
    
    public var statusBarStyle: UIStatusBarStyle {
        get {
            swizzleMethod
            return base.statusBarStyle
        }
        set {
            swizzleMethod
            base.statusBarStyle = newValue
        }
    }
    
    public var isBarShadowImageHidden: Bool {
        get {
            swizzleMethod
            return base.isNavigationBarShadowImageHidden
        }
        set {
            swizzleMethod
            base.isNavigationBarShadowImageHidden = newValue
        }
    }
    
    public var customBar: UIView? {
        get {
            swizzleMethod
            return base.customNavigationBar
        }
        set {
            swizzleMethod
            base.customNavigationBar = newValue
        }
    }
}
