//
//  SignInViewController.swift
//  Work2go
//
//  Created by Rajesh Gupta on 2/11/18.
//  Copyright © 2018 Rajesh Gupta. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    let service = ServerHandler()
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        emailField.text = "rajeshgupta2060@gmail.com"
//        passField.text = "12345678"

    }

     
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func signupAction(_ sender: Any) {
        let login = self.storyboard?.instantiateViewController(withIdentifier: "signup")
        self.navigationController?.pushViewController(login!, animated: true)
    }
    @IBAction func loginAction(_ sender: Any) {
        if (emailField.text?.isEmpty)! {
            Helper.showSnackBar(with: "Email field can't be empty")
            return
        }
        else if (Helper.validateEmail(with: emailField.text!) == false) {
            Helper.showSnackBar(with: "Invalid email address")
            return
        }
        else if (passField.text?.isEmpty)! {
            Helper.showSnackBar(with: "Password field can't be empty")
            return
        }
        
        service.getResponseFromServer(parametrs: "log.php?email=\(emailField.text!)&&password=\(passField.text!)") { (results) in
            let status = results["status"] as? String ?? ""
            if status == "1"{
                
                let data = results["user_info"] as! [String:Any]
                UserDefaults.standard.setUserDetails(value: data)
               
                let userData = Helper.setUserDetailsInUsermodel(details: UserDefaults.standard.getUserDetails())
                print(userData)
             
                UserDefaults.standard.setLoggedIn(value: true)
                
                let login = self.storyboard?.instantiateViewController(withIdentifier: "tabbar")
                self.navigationController?.pushViewController(login!, animated: true)
            }else{
                AJAlertController.initialization().showAlertWithOkButton(aStrMessage: results["message"] as? String ?? "") { (index, title) in
                    print(index,title)
                }
            }
        }
        
    }
    
    @IBAction func forgotPasswordAction(_ sender: Any) {
        let forgot = self.storyboard?.instantiateViewController(withIdentifier: "forgotpassword")
        self.navigationController?.pushViewController(forgot!, animated: true)
        
    }
    

}
