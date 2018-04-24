//
//  ForgotPasswordViewController.swift
//  Work2go
//
//  Created by Rajesh Gupta on 2/11/18.
//  Copyright © 2018 Rajesh Gupta. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {

    let service = ServerHandler()
    
    @IBOutlet weak var emailField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    
    
    @IBAction func forgotBtnAction(_ sender: Any) {
        
        if (emailField.text?.isEmpty)! {
            Helper.showSnackBar(with: "Email field can't be empty")
            return
        }
        else if (Helper.validateEmail(with: emailField.text!) == false) {
            Helper.showSnackBar(with: "Invalid email address")
            return
        }
        
        service.getResponseFromServer(parametrs: "forgot_pass.php?email=\(emailField.text!)") { (results) in
            
            let status = results["status"] as? String ?? ""
            if status == "1"{
                AJAlertController.initialization().showAlertWithOkButton(aStrMessage: results["message"] as? String ?? "") { (index, title) in
                    let viewControllers: [UIViewController] = self.navigationController!.viewControllers
                    for aViewController in viewControllers {
                        if aViewController is SignInViewController {
                            self.navigationController!.popToViewController(aViewController, animated: true)
                        }
                    }
                }
            }else{
                AJAlertController.initialization().showAlertWithOkButton(aStrMessage: results["message"] as? String ?? "") { (index, title) in
                    print(index,title)
                }
            }
        }
    }
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
   

}
