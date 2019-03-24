//
//  NavigationCompatible.swift
//  ANNavigationBar
//
//  Created by 刘栋 on 2019/3/23.
//  Copyright © 2019 anotheren.com. All rights reserved.
//

import Foundation

public protocol NavigationCompatible {
    
    associatedtype NavigationObject
    
    static var navigation: NavigationBase<NavigationObject>.Type { get }
    
    var navigation: NavigationBase<NavigationObject> { get }
}

extension NavigationCompatible {
    
    public static var navigation: NavigationBase<Self>.Type {
        get {
            return NavigationBase<Self>.self
        }
    }
    
    public var navigation: NavigationBase<Self> {
        get {
            return NavigationBase(base: self)
        }
    }
}
