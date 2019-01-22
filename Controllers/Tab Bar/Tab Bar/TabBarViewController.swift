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
    var userData : userModel!
    
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
        
        DispatchQueue.main.async {
            self.getBadgeCount()
        }
    }

    
    // UITabBarDelegate
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
      
         let tabBarIndex = tabBarController.selectedIndex
         isHomeContentBy = "searchWithoutContent"
      
        if (UserDefaults.standard.isLoggedIn() == false) {
            
            if tabBarIndex == 1 || tabBarIndex == 2 || tabBarIndex == 3{
                
                let root = self.storyboard?.instantiateViewController(withIdentifier: "signin") as? SignInViewController
                self.navigationController?.pushViewController(root ?? UIViewController(), animated: true)
            }
        }
        DispatchQueue.main.async {
            self.getBadgeCount()
        }
    }
    
    func getBadgeCount() {
        if UserDefaults.standard.isLoggedIn() {
            userData = Helper.setUserDetailsInUsermodel(details: UserDefaults.standard.getUserDetails())
            ServerHandler().getResponseFromServer(parametrs: "read_chat_count.php?user_id=\(userData.user_id!)", completion: { (results) in
                let chat_count = results["chat_count"] as? String ?? ""
                
                if chat_count != "0" {
                    self.tabBar.items?[2].badgeValue = chat_count
                }else{
                    self.tabBar.items?[2].badgeValue = nil
                }
            })
        }
    }
    
    
}
