//
//  NavigationHelper.swift
//  ANNavigationBar
//
//  Created by 刘栋 on 2019/3/24.
//  Copyright © 2019 anotheren.com. All rights reserved.
//

import Foundation

struct NavigationHelper {
    
    static func middleColor(fromColor: UIColor, toColor: UIColor, percent: CGFloat) -> UIColor {
        // get current color RGBA
        var fromRed: CGFloat = 0
        var fromGreen: CGFloat = 0
        var fromBlue: CGFloat = 0
        var fromAlpha: CGFloat = 0
        fromColor.getRed(&fromRed, green: &fromGreen, blue: &fromBlue, alpha: &fromAlpha)
        
        // get to color RGBA
        var toRed: CGFloat = 0
        var toGreen: CGFloat = 0
        var toBlue: CGFloat = 0
        var toAlpha: CGFloat = 0
        toColor.getRed(&toRed, green: &toGreen, blue: &toBlue, alpha: &toAlpha)
        
        // calculate middle color RGBA
        let newRed = middleValue(fromValue: fromRed, toValue: toRed, percent: percent)
        let newGreen = middleValue(fromValue: fromGreen, toValue: toGreen, percent: percent)
        let newBlue = middleValue(fromValue: fromBlue, toValue: toBlue, percent: percent)
        let newAlpha = middleValue(fromValue: fromAlpha, toValue: toAlpha, percent: percent)
        return UIColor(red: newRed, green: newGreen, blue: newBlue, alpha: newAlpha)
    }
    
    static func middleValue(fromValue: CGFloat, toValue: CGFloat, percent: CGFloat) -> CGFloat {
        return fromValue + (toValue - fromValue) * percent
    }
}
