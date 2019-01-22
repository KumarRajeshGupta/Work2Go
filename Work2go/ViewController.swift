//
//  ViewController.swift
//  Work2go
//
//  Created by Rajesh Gupta on 2/11/18.
//  Copyright © 2018 Rajesh Gupta. All rights reserved.
//

import UIKit
import CoreLocation


class ViewController: UIViewController {
 
    @IBOutlet weak var activityview: UIActivityIndicatorView!
    
    var locManager = CLLocationManager()
    var appdelegate = AppDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        appdelegate = UIApplication.shared.delegate as! AppDelegate
        
        locManager.requestWhenInUseAuthorization()

        activityview.startAnimating()
        Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false, block: {(timer: Timer) -> Void in
            self.activityview.isHidden=true
            //let login = self.storyboard?.instantiateViewController(withIdentifier: "signin")
            let login = self.storyboard?.instantiateViewController(withIdentifier: "tabbar")
            self.navigationController?.pushViewController(login!, animated: true)
            
//            if UserDefaults.standard.bool(forKey: "isLogin"){
//                let login = self.storyboard?.instantiateViewController(withIdentifier: "tabbar")
//                self.navigationController?.pushViewController(login!, animated: true)
//            }else{
//                let root = self.storyboard?.instantiateViewController(withIdentifier: "root") as? RootViewController
//                self.navigationController?.pushViewController(root ?? UIViewController(), animated: true)
//            }
        })
    }

}

