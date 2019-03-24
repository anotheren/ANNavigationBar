//
//  SwizzleHelper.swift
//  ANNavigationBar
//
//  Created by 刘栋 on 2018/12/13.
//  Copyright © 2019 anotheren.com. All rights reserved.
//

import ObjectiveC

struct SwizzleHelper {
    
    static func swizzleMethod(for aClass: AnyClass, originalSelector: Selector, swizzledSelector: Selector) {
        guard
            let originalMethod = class_getInstanceMethod(aClass, originalSelector),
            let swizzledMethod = class_getInstanceMethod(aClass, swizzledSelector)
            else {
                return
        }
        
        let didAddMethod = class_addMethod(aClass, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
        
        if didAddMethod {
            class_replaceMethod(aClass, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }
}
