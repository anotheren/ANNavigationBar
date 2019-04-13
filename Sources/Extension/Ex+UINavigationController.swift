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
        return topViewController?.statusBarStyle ?? .default
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
        let fromBarTintColor = fromVC?.navigationBarBarTintColor ?? .white
        let toBarTintColor = toVC?.navigationBarBarTintColor ?? .white
        let newBarTintColor = NavigationHelper.middleColor(fromColor: fromBarTintColor, toColor: toBarTintColor, percent: percent)
        setNeedsNavigationBarUpdate(barTintColor: newBarTintColor)
        
        // change NavigationBar.tintColor
        let fromTintColor = fromVC?.navigationBarTintColor ?? .black
        let toTintColor = toVC?.navigationBarTintColor ?? .black
        let newTintColor = NavigationHelper.middleColor(fromColor: fromTintColor, toColor: toTintColor, percent: percent)
        setNeedsNavigationBarUpdate(tintColor: newTintColor)
        
        // change NavigationBar.titleColor
        let fromTitleColor = fromVC?.navigationBarTitleColor ?? .black
        let toTitleColor = toVC?.navigationBarTitleColor ?? .black
        let newTitleColor = NavigationHelper.middleColor(fromColor: fromTitleColor, toColor: toTitleColor, percent: percent)
        setNeedsNavigationBarUpdate(titleColor: newTitleColor)
        
        // change NavigationBar._UIBarBackground.alpha
        let fromBarBackgroundAlpha = fromVC?.navigationBarBackgroundAlpha ?? 1.0
        let toBarBackgroundAlpha = toVC?.navigationBarBackgroundAlpha ?? 1.0
        let newBarBackgroundAlpha = NavigationHelper.middleValue(fromValue: fromBarBackgroundAlpha, toValue: toBarBackgroundAlpha, percent: percent)
        setNeedsNavigationBarUpdate(barBackgroundAlpha: newBarBackgroundAlpha)
    }
}

// MARK: - Swizzled Method + Pop

extension UINavigationController {
    
    // swizzling system method: popToViewController
    @objc func swizzledPopToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        setNeedsNavigationBarUpdate(titleColor: viewController.navigationBarTitleColor)
        let displayLink = CADisplayLink(target: self, selector: #selector(popNeedDisplay))
        // NSRunLoopCommonModes contains kCFRunLoopDefaultMode and UITrackingRunLoopMode
        displayLink.add(to: .main, forMode: .common)
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
    
    // swizzling system method: popToRootViewControllerAnimated
    @objc private func swizzledPopToRootViewController(_ animated: Bool) -> [UIViewController]? {
        let displayLink = CADisplayLink(target: self, selector: #selector(popNeedDisplay))
        displayLink.add(to: .main, forMode: .common)
        CATransaction.setCompletionBlock {
            displayLink.invalidate()
            PopAnimation.displayCount = 0
        }
        CATransaction.setAnimationDuration(PopAnimation.duration)
        CATransaction.begin()
        let vcs = swizzledPopToRootViewController(animated)
        CATransaction.commit()
        return vcs
    }
    
    @objc private func popNeedDisplay() {
        guard let coordinator = topViewController?.transitionCoordinator else {
            return
        }
        PopAnimation.displayCount += 1
        let progress = PopAnimation.progress
        let fromVC = coordinator.viewController(forKey: .from)
        let toVC = coordinator.viewController(forKey: .to)
        updateNavigationBar(fromVC: fromVC, toVC: toVC, percent: progress)
    }
    
    private struct PopAnimation {
        
        static let duration = 0.15
        static var displayCount = 0
        
        static var progress: CGFloat {
            let all = CGFloat(60.0 * duration)
            let current = min(all, CGFloat(displayCount))
            return current / all
        }
    }
}

// MARK: - Swizzled Method + Push

extension UINavigationController {
    
    @objc private func swizzledPushViewController(_ viewController: UIViewController, animated: Bool) {
        let displayLink = CADisplayLink(target: self, selector: #selector(pushNeedDisplay))
        displayLink.add(to: .main, forMode: .common)
        CATransaction.setCompletionBlock {
            displayLink.invalidate()
            PushAnimation.displayCount = 0
            viewController.isPushToCurrentViewControllerFinished = true
        }
        CATransaction.setAnimationDuration(PushAnimation.duration)
        CATransaction.begin()
        swizzledPushViewController(viewController, animated: animated)
        CATransaction.commit()
    }
    
    @objc private func pushNeedDisplay() {
        guard let coordinator = topViewController?.transitionCoordinator else {
            return
        }
        PushAnimation.displayCount += 1
        let progress = PushAnimation.progress
        let fromVC = coordinator.viewController(forKey: .from)
        let toVC = coordinator.viewController(forKey: .to)
        updateNavigationBar(fromVC: fromVC, toVC: toVC, percent: progress)
    }
    
    private struct PushAnimation {
        
        static let duration = 0.13
        static var displayCount = 0
        
        static var progress: CGFloat {
            let all = CGFloat(60.0 * duration)
            let current = min(all, CGFloat(displayCount))
            return current / all
        }
    }
}

// MARK: UINavigationBarDelegate

extension UINavigationController: UINavigationBarDelegate {
    
    public func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
        if let coordinator = topViewController?.transitionCoordinator, coordinator.initiallyInteractive {
            coordinator.notifyWhenInteractionChanges { context in
                self.dealInteractionChanges(context)
            }
            return true
        } else {
            let itemCount = navigationBar.items?.count ?? 0
            let n = viewControllers.count >= itemCount ? 2 : 1
            let targetVC = viewControllers[viewControllers.count - n]
            popToViewController(targetVC, animated: true)
            return true
        }
    }
    
    private func dealInteractionChanges(_ context: UIViewControllerTransitionCoordinatorContext) {
        
        func animations(for key: UITransitionContextViewControllerKey) {
            let currentColor = context.viewController(forKey: key)?.navigationBarTintColor ?? .clear // TODO
            let currentAlpha = context.viewController(forKey: key)?.navigationBarBackgroundAlpha ?? 1
            setNeedsNavigationBarUpdate(barTintColor: currentColor)
            setNeedsNavigationBarUpdate(barBackgroundAlpha: currentAlpha)
        }
        
        if context.isCancelled {
            // after that, cancel the gesture of return
            let cancelDuration: TimeInterval = context.transitionDuration * Double(context.percentComplete)
            UIView.animate(withDuration: cancelDuration) {
                animations(for: .from)
            }
        } else {
            // after that, finish the gesture of return
            let finishDuration: TimeInterval = context.transitionDuration * Double(1 - context.percentComplete)
            UIView.animate(withDuration: finishDuration) {
                animations(for: .to)
            }
        }
    }
    
    // swizzling system method: _updateInteractiveTransition
    @objc private func swizzledUpdateInteractiveTransition(_ percentComplete: CGFloat) {
        guard let coordinator = topViewController?.transitionCoordinator else {
            swizzledUpdateInteractiveTransition(percentComplete)
            return
        }
        let fromVC = coordinator.viewController(forKey: .from)
        let toVC = coordinator.viewController(forKey: .to)
        updateNavigationBar(fromVC: fromVC, toVC: toVC, percent: percentComplete)
        swizzledUpdateInteractiveTransition(percentComplete)
    }
}

// MARK: - Swizzle Method

extension UINavigationController {
    
    static let swizzleUINavigationController: () = {
        swizzlePopToViewController
        swizzlePopToRootViewController
        swizzlePushViewController
        swizzleUpdateInteractiveTransition
    }()
    
    private static let swizzlePopToViewController: () = {
        let originalSelector = #selector(UINavigationController.popToViewController)
        let swizzledSelector = #selector(UINavigationController.swizzledPopToViewController)
        SwizzleHelper.swizzleMethod(for: UINavigationController.self, originalSelector: originalSelector, swizzledSelector: swizzledSelector)
    }()
    
    private static let swizzlePopToRootViewController: () = {
        let originalSelector = #selector(UINavigationController.popToRootViewController)
        let swizzledSelector = #selector(UINavigationController.swizzledPopToRootViewController)
        SwizzleHelper.swizzleMethod(for: UINavigationController.self, originalSelector: originalSelector, swizzledSelector: swizzledSelector)
    }()
    
    private static let swizzlePushViewController: () = {
        let originalSelector = #selector(UINavigationController.pushViewController)
        let swizzledSelector = #selector(UINavigationController.swizzledPushViewController)
        SwizzleHelper.swizzleMethod(for: UINavigationController.self, originalSelector: originalSelector, swizzledSelector: swizzledSelector)
    }()
    
    private static let swizzleUpdateInteractiveTransition: () = {
        let originalSelector = NSSelectorFromString("_updateInteractiveTransition:")
        let swizzledSelector = #selector(UINavigationController.swizzledUpdateInteractiveTransition)
        SwizzleHelper.swizzleMethod(for: UINavigationController.self, originalSelector: originalSelector, swizzledSelector: swizzledSelector)
    }()
}
