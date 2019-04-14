//
//  Ex+UIColor.swift
//  ANNavigationBar
//
//  Created by 刘栋 on 2019/4/14.
//  Copyright © 2019 anotheren.com. All rights reserved.
//

import UIKit

extension UIColor {
    
    /// 获取默认注册的 NavigationBar TintColor
    static var navigationBarTintColor: UIColor {
        let appearance = UINavigationBar.appearance()
        return appearance.tintColor ?? UIColor(red: 0, green: 122/255, blue: 1, alpha: 1)
    }
    
    /// 获取默认注册的 NavigationBar BarTintColor
    static var navigationBarBarTintColor: UIColor {
        let appearance = UINavigationBar.appearance()
        return appearance.barTintColor ?? UIColor.white
    }
    
    /// 获取默认注册的 NavigationBar TitleColor
    static var navigationBarTitleColor: UIColor {
        let appearance = UINavigationBar.appearance()
        return (appearance.titleTextAttributes?[.foregroundColor] as? UIColor) ?? .black
    }
    
    /// 获取默认注册的 NavigationBar LargeTitleColor
    @available(iOS 11.0, *)
    static var navigationBarLargeTitleColor: UIColor {
        let appearance = UINavigationBar.appearance()
        return (appearance.largeTitleTextAttributes?[.foregroundColor] as? UIColor) ?? .black
    }
}
