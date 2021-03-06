//
//  ViewController.swift
//  Example
//
//  Created by 刘栋 on 2019/4/13.
//  Copyright © 2019 anotheren.com. All rights reserved.
//

import UIKit
import ANNavigationBar

class ViewController: UIViewController {
    
    var index = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        navigation.barTintColor = .white
        navigation.tintColor = .black
        navigation.barTitleColor = .white
        navigationItem.title = "No.\(index) Controller"
    }

    @IBAction func redButtonTapped(_ sender: UIButton) {
        let controller = ViewController()
        controller.index = index+1
        controller.navigation.barTintColor = .red
        controller.navigation.tintColor = .black
        controller.navigation.statusBarStyle = .default
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func blackButtonTapped(_ sender: UIButton) {
        let controller = ViewController()
        controller.index = index+1
        controller.navigation.barTintColor = .black
        controller.navigation.tintColor = .black
        controller.navigation.statusBarStyle = .default
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func greenButtonTapped(_ sender: UIButton) {
        let controller = ViewController()
        controller.index = index+1
        controller.navigation.barTintColor = .green
        controller.navigation.tintColor = .black
        controller.navigation.statusBarStyle = .default
        navigationController?.pushViewController(controller, animated: true)
    }
}

