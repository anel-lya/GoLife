//
//  TabBar.swift
//  Caledary App
//
//  Created by Anel Rustamova on 03.03.2024.
//

import UIKit


var back : UIColor = .white
var front : UIColor = .black

class TabBar: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if traitCollection.userInterfaceStyle == .dark {
            back = .black
            front = .white
            print("Темная тема")
        } else {
            back = .white
            front = .black
            print("svet тема")
        }            
        tabBar.backgroundColor = .black

        
        // Do any additional setup after loading the view.
    }
    



}
