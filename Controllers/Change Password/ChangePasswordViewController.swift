//
//  ChangePasswordViewController.swift
//  Work2go
//
//  Created by Rajesh Gupta on 2/22/18.
//  Copyright © 2018 Rajesh Gupta. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController {

    
    
    @IBOutlet weak var oldPass: UITextField!
    @IBOutlet weak var newPass: UITextField!
    @IBOutlet weak var conNewPass: UITextField!
    
     let service = ServerHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }

    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func confirmBtnAction(_ sender: Any) {
        
        if (oldPass.text?.isEmpty)! {
            Helper.showSnackBar(with: "Old password field can't be empty")
            return
        }
        else if (newPass.text?.isEmpty)! {
            Helper.showSnackBar(with: "New password field can't be empty")
            return
        }
        else if (conNewPass.text?.isEmpty)! {
            Helper.showSnackBar(with: "Confirm new password field can't be empty")
            return
        }
        else if (newPass.text != conNewPass.text) {
            Helper.showSnackBar(with: "New password and confirm password does not match")
            return
        }
        
        let user_data = Helper.setUserDetailsInUsermodel(details: UserDefaults.standard.getUserDetails())
        
        service.getResponseFromServer(parametrs: "\(change_pass)?user_id=\(user_data.user_id!)&&old_pass=\(oldPass.text!)&&new_pass=\(newPass.text!)") { (results) in
            
            let status = results["status"] as? String ?? ""
            if status == "1"{
                print(status)
                AJAlertController.initialization().showAlertWithOkButton(aStrMessage: results["message"] as? String ?? "") { (index, title) in
                    print(index,title)
                    
                    let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
                    self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
                }
                
            }else{
                Helper.showSnackBar(with: results["message"] as? String ?? "")
            }
            
        }
        
    }
    

}
