//
//  Ex+UINavigationController.swift
//  ANNavigationBar
//
//  Created by 刘栋 on 2019/3/24.
//  Copyright © 2019 anotheren.com. All rights reserved.
//

import UIKit
import ObjectiveC

extension UINavigationController {
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.statusBarStyle ?? .lightContent
    }
}

extension UINavigationController {
    
    func setNeedsNavigationBarUpdate(backgroundImage: UIImage) {
        navigationBar.setBackground(image: backgroundImage)
    }
    
    func setNeedsNavigationBarUpdate(barTintColor: UIColor) {
        navigationBar.setBackground(color: barTintColor)
    }
    
    func setNeedsNavigationBarUpdate(barBackgroundAlpha: CGFloat) {
        navigationBar.setBackground(alpha: barBackgroundAlpha)
    }
    
    func setNeedsNavigationBarUpdate(tintColor: UIColor) {
        navigationBar.tintColor = tintColor
    }
    
    func setNeedsNavigationBarUpdate(isHidedShadowImage: Bool) {
        navigationBar.shadowImage = isHidedShadowImage ? UIImage() : nil
    }

    func setNeedsNavigationBarUpdate(titleColor: UIColor) {
        navigationBar.titleTextAttributes?[.foregroundColor] = titleColor
    }
    
    func updateNavigationBar(fromVC: UIViewController?, toVC: UIViewController?, percent: CGFloat) {
        // change NavigationBar.barTintColor
        let fromBarTintColor = fromVC?.navigationBarBarTintColor ?? .clear // TODO
        let toBarTintColor = toVC?.navigationBarBarTintColor ?? .clear // TODO
        let newBarTintColor = NavigationHelper.middleColor(fromColor: fromBarTintColor, toColor: toBarTintColor, percent: percent)
        setNeedsNavigationBarUpdate(barTintColor: newBarTintColor)
        
        // change NavigationBar.tintColor
        let fromTintColor = fromVC?.navigationBarTintColor ?? .clear // TODO
        let toTintColor = toVC?.navigationBarTintColor ?? .clear // TODO
        let newTintColor = NavigationHelper.middleColor(fromColor: fromTintColor, toColor: toTintColor, percent: percent)
        setNeedsNavigationBarUpdate(tintColor: newTintColor)
        
        
        // change NavigationBar.titleColor
        let fromTitleColor = fromVC?.navigationBarTitleColor ?? .clear // TODO
        let toTitleColor = toVC?.navigationBarTitleColor ?? .clear // TODO
        let newTitleColor = NavigationHelper.middleColor(fromColor: fromTitleColor, toColor: toTitleColor, percent: percent)
        setNeedsNavigationBarUpdate(titleColor: newTitleColor)
        
        // change NavigationBar._UIBarBackground.alpha
        let fromBarBackgroundAlpha = fromVC?.navigationBarBackgroundAlpha ?? 1.0 // TODO
        let toBarBackgroundAlpha = toVC?.navigationBarBackgroundAlpha ?? 1.0 // TODO
        let newBarBackgroundAlpha = NavigationHelper.middleValue(fromValue: fromBarBackgroundAlpha, toValue: toBarBackgroundAlpha, percent: percent)
        setNeedsNavigationBarUpdate(barBackgroundAlpha: newBarBackgroundAlpha)
    }
}

// MARK: - Swizzle

extension UINavigationController {
    
    
    // swizzling system method: popToViewController
    @objc func swizzledPopToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        setNeedsNavigationBarUpdate(titleColor: viewController.navigationBarTitleColor)
        let displayLink = CADisplayLink(target: self, selector: #selector(popNeedDisplay))
        // NSRunLoopCommonModes contains kCFRunLoopDefaultMode and UITrackingRunLoopMode
        displayLink.add(to: RunLoop.main, forMode: .common)
        CATransaction.setCompletionBlock {
            displayLink.invalidate()
            PopAnimation.displayCount = 0
        }
        CATransaction.setAnimationDuration(PopAnimation.duration)
        CATransaction.begin()
        let vcs = swizzledPopToViewController(viewController, animated: animated)
        CATransaction.commit()
        return vcs
    }
    
    @objc private func popNeedDisplay() {
//        guard let topViewController = topViewController, let coordinator = topViewController.transitionCoordinator else {
//            return
//        }
//        popProperties.displayCount += 1
//        let progress = popProperties.popProgress
//        // print("第\(popProperties.displayCount)次pop的进度：\(popProgress)")
//        let fromVC = coordinator.viewController(forKey: .from)
//        let toVC = coordinator.viewController(forKey: .to)
//        updateNavigationBar(fromVC: fromVC, toVC: toVC, progress: progress)
    }

}

extension UINavigationController {
    
    struct PopAnimation {
        
        static let duration = 0.15
        static var displayCount = 0
        static var progress: CGFloat {
            let all = CGFloat(60.0 * duration)
            let current = min(all, CGFloat(displayCount))
            return current / all
        }
    }
}
