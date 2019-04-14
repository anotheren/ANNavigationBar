//
//  Ex+UINavigationBar.swift
//  ANNavigationBar
//
//  Created by 刘栋 on 2019/3/23.
//  Copyright © 2019 anotheren.com. All rights reserved.
//

import UIKit
import ObjectiveC

// MARK: - Associated Object

extension UINavigationBar {
    
    private struct AssociatedKey {
        
        static var backgroundView: UInt8 = 0
        static var backgroundImageView: UInt8 = 0
    }
    
    private var backgroundView: UIView? {
        get {
            guard let backgroundView = objc_getAssociatedObject(self, &AssociatedKey.backgroundView) as? UIView else {
                return nil
            }
            return backgroundView
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.backgroundView, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private var backgroundImageView: UIImageView? {
        get {
            guard let backgroundImageView = objc_getAssociatedObject(self, &AssociatedKey.backgroundImageView) as? UIImageView else {
                return nil
            }
            return backgroundImageView
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.backgroundImageView, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

extension UINavigationBar {
    
    func setBackground(image: UIImage) {
        backgroundView?.removeFromSuperview()
        backgroundView = nil
        if let backgroundImageView = backgroundImageView {
            backgroundImageView.image = image
        } else {
            // add a image(nil color) to _UIBarBackground make it clear
            setBackgroundImage(UIImage(), for: .default)
            let backgroundImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: UIDevice.navigationBarBottom))
            backgroundImageView.autoresizingMask = .flexibleWidth
            backgroundImageView.image = image
            // _UIBarBackground is first subView for navigationBar
            subviews.first?.insertSubview(backgroundImageView, at: 0)
            self.backgroundImageView =  backgroundImageView
        }
    }
    
    func setBackground(color: UIColor) {
        backgroundImageView?.removeFromSuperview()
        backgroundImageView = nil
        if let backgroundView = backgroundView {
            backgroundView.backgroundColor = color
        } else {
            // add a image(nil color) to _UIBarBackground make it clear
            setBackgroundImage(UIImage(), for: .default)
            let backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: UIDevice.navigationBarBottom))
            backgroundView.autoresizingMask = .flexibleWidth
            backgroundView.backgroundColor = color
            // _UIBarBackground is first subView for navigationBar
            subviews.first?.insertSubview(backgroundView, at: 0)
            self.backgroundView = backgroundView
        }
    }
    
    func setBackground(alpha: CGFloat) {
        if let barBackgroundView = subviews.first {
            if #available(iOS 11.0, *) {
                // sometimes we can't change _UIBarBackground alpha
                for view in barBackgroundView.subviews {
                    view.alpha = alpha
                }
            } else {
                barBackgroundView.alpha = alpha
            }
        }
    }
    
    func setBarButtonItems(alpha: CGFloat, hasSystemBackIndicator: Bool) {
        for view in subviews {
            if hasSystemBackIndicator {
                // _UIBarBackground/_UINavigationBarBackground 对应的view是系统导航栏，不需要改变其透明度
                if let _UIBarBackground = PrivateClass._UIBarBackground, !view.isKind(of: _UIBarBackground) {
                    view.alpha = alpha
                }
                if let _UINavigationBarBackground = PrivateClass._UINavigationBarBackground, !view.isKind(of: _UINavigationBarBackground) {
                    view.alpha = alpha
                }
            } else {
                if let _UINavigationBarBackIndicatorView = PrivateClass._UINavigationBarBackIndicatorView, !view.isKind(of: _UINavigationBarBackIndicatorView) {
                    if let _UIBarBackground = PrivateClass._UIBarBackground, !view.isKind(of: _UIBarBackground) {
                        view.alpha = alpha
                    }
                    if let _UINavigationBarBackground = PrivateClass._UINavigationBarBackground, !view.isKind(of: _UINavigationBarBackground) {
                        view.alpha = alpha
                    }
                }
            }
        }
    }
}

// MARK: - Swizzled Method

extension UINavigationBar {
    
    @objc private func swizzledSetTitleTextAttributes(_ newTitleTextAttributes: [NSAttributedString.Key : Any]?) {
        guard var attributes = newTitleTextAttributes else {
            return
        }
        
        guard let originTitleTextAttributes = titleTextAttributes else {
            swizzledSetTitleTextAttributes(attributes)
            return
        }
        
        guard let originTitleColor = originTitleTextAttributes[.foregroundColor] as? UIColor else {
            swizzledSetTitleTextAttributes(attributes)
            return
        }
        
        if attributes[.foregroundColor] == nil {
            attributes.updateValue(originTitleColor, forKey: .foregroundColor)
        }
        swizzledSetTitleTextAttributes(attributes)
    }
}

// MARK: - Swizzle Method

extension UINavigationBar {
    
    static let swizzleUINavigationBar: () = {
        swizzleSetTitleTextAttributes
    }()

    private static let swizzleSetTitleTextAttributes: () = {
        let originalSelector = #selector(setter: UINavigationBar.titleTextAttributes)
        let swizzledSelector = #selector(UINavigationBar.swizzledSetTitleTextAttributes)
        SwizzleHelper.swizzleMethod(for: UINavigationBar.self, originalSelector: originalSelector, swizzledSelector: swizzledSelector)
    }()
}

// MARK: - Private Class

extension UINavigationBar {
    
    private struct PrivateClass {
        
        static var _UIBarBackground: AnyClass? {
            return NSClassFromString("_UIBarBackground")
        }
        
        static var _UINavigationBarBackground: AnyClass? {
            return NSClassFromString("_UINavigationBarBackground")
        }
        
        static var _UINavigationBarBackIndicatorView: AnyClass? {
            return NSClassFromString("_UINavigationBarBackIndicatorView")
        }
    }
}
