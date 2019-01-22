//
//  SignUpViewController.swift
//  Work2go
//
//  Created by Rajesh Gupta on 2/11/18.
//  Copyright © 2018 Rajesh Gupta. All rights reserved.
//

import UIKit
import CountryList

class SignUpViewController: UIViewController , CountryListDelegate {

    let service = ServerHandler()
    
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
        @IBOutlet weak var employeeBtn: UIButton!
    @IBOutlet weak var employerBtn: UIButton!
    @IBOutlet weak var countryCodeBtn: UIButton!
    
    var isEmployee : String = "Employee"
    var countryList = CountryList()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countryList.delegate = self
        
        if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
            print(countryCode)
            print(Helper.getCountryPhonceCode(countryCode))
            countryCodeBtn.setTitle("(\(countryCode))  +\(Helper.getCountryPhonceCode(countryCode))", for: .normal)
        }
        
    }

   
    func selectedCountry(country: Country) {
        
        print("\(country.flag!) \(country.name!), \(country.countryCode), \(country.phoneExtension)")
        countryCodeBtn.setTitle("(\(country.countryCode))  +\(country.phoneExtension)", for: .normal)
        
    }
    
    @IBAction func employeeBtnAction(_ sender: Any) {
        employeeBtn.setImage(UIImage(named: "selected-radio"), for: .normal)
        employerBtn.setImage(UIImage(named: "unselected-radio"), for: .normal)
        
        isEmployee  = "Employee"
    }
    @IBAction func employerBtnAction(_ sender: Any) {
        employeeBtn.setImage(UIImage(named: "unselected-radio"), for: .normal)
        employerBtn.setImage(UIImage(named: "selected-radio"), for: .normal)
        
        isEmployee  = "Employer"
    }
    
    @IBAction func countryCodeBtnAction(_ sender: Any) {
        let navController = UINavigationController(rootViewController: countryList)
        self.present(navController, animated: true, completion: nil)
    }
    @IBAction func signupBtnAction(_ sender: Any) {
        
        if (nameField.text?.isEmpty)! {
            Helper.showSnackBar(with: "Name/Company name field can't be empty")
            return
        }
        else if (emailField.text?.isEmpty)! {
            Helper.showSnackBar(with: "Email field can't be empty")
            return
        }
        else if (Helper.validateEmail(with: emailField.text!) == false) {
            Helper.showSnackBar(with: "Invalid email address")
            return
        }
        else if (passwordField.text?.isEmpty)! {
            Helper.showSnackBar(with: "Password field can't be empty")
            return
        }
        else if ((passwordField.text?.count)!<8) {
            Helper.showSnackBar(with: "Password can't be less than 8 character")
            return
        }
        else if (phoneField.text?.isEmpty)! {
            Helper.showSnackBar(with: "Mobile number can't be empty")
            return
        }
        else if ((phoneField.text?.count)!<6) {
            Helper.showSnackBar(with: "Please input a valid mobile number")
            return
        }
        
        var c_code : [String] = (countryCodeBtn.titleLabel?.text!.components(separatedBy: " "))!
        let c_code1 = c_code[1]
        service.getResponseFromServer(parametrs: "register.php?user_name=\(nameField.text!)&&user_email=\(emailField.text!)&&user_pwd=\(passwordField.text!)&&user_mob=\(c_code1)\(phoneField.text!)&&user_type=\(isEmployee)") { (results) in
            
            let status = results["status"] as? String ?? ""
            if status == "1"{
                print(status)
                AJAlertController.initialization().showAlertWithOkButton(aStrMessage: results["message"] as? String ?? "") { (index, title) in
                    print(index,title)
                    
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
