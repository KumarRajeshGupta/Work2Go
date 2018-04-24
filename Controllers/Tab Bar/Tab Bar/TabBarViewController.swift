//
//  TabBarViewController.swift
//  Work2go
//
//  Created by Rajesh Gupta on 2/11/18.
//  Copyright © 2018 Rajesh Gupta. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController , UITabBarControllerDelegate {

    
    @IBOutlet weak var tabbar: UITabBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        UIApplication.shared.isStatusBarHidden = false
        UIApplication.shared.statusBarStyle = .lightContent
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        statusBar.backgroundColor = Helper.hexStringToUIColor(hex: "333333")
        UITabBar.appearance().tintColor = Helper.hexStringToUIColor(hex: "980202")
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
  
        if (UserDefaults.standard.isLoggedIn() == false) {
            
            self.selectedIndex = 0
        }
    }

    
    // UITabBarDelegate
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
      
         let tabBarIndex = tabBarController.selectedIndex
      
        if (UserDefaults.standard.isLoggedIn() == false) {
            
            if tabBarIndex == 1 || tabBarIndex == 2 || tabBarIndex == 3{
                
                let root = self.storyboard?.instantiateViewController(withIdentifier: "signin") as? SignInViewController
                self.navigationController?.pushViewController(root ?? UIViewController(), animated: true)
            }
            
        }
  
    }

}
