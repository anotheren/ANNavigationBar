//
//  NavigationBase.swift
//  ANNavigationBar
//
//  Created by 刘栋 on 2019/3/23.
//  Copyright © 2019 anotheren.com. All rights reserved.
//

import Foundation

public struct NavigationBase<Base> {
    
    public let base: Base
    
    public init(base: Base) {
        self.base = base
    }
}
