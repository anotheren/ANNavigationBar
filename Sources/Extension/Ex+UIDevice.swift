//
//  Ex+UIDevice.swift
//  ANNavigationBar
//
//  Created by 刘栋 on 2019/3/23.
//  Copyright © 2019 anotheren.com. All rights reserved.
//

import UIKit

extension UIDevice {
    
    static var isModernPhone: Bool {
        switch UIScreen.main.bounds.size {
        case CGSize(width: 375, height: 812):
            return true
        case CGSize(width: 414, height: 896):
            return true
        default:
            return false
        }
    }
    
    static var navigationBarBottom: CGFloat {
        return isModernPhone ? 88 : 64
    }
    
    static var tabBarHeight: CGFloat {
        return isModernPhone ? 83 : 49
    }
}
