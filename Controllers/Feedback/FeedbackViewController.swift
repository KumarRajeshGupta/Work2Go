//
//  FeedbackViewController.swift
//  Work2go
//
//  Created by Rajesh Gupta on 2/23/18.
//  Copyright © 2018 Rajesh Gupta. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class FeedbackViewController: UIViewController {

    
    let service = ServerHandler()
    
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var subject: UITextField!
    @IBOutlet weak var messege: IQTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messege.layer.borderColor = UIColor.white.cgColor
        messege.layer.borderWidth = 1.0
        
        
        let user_data = Helper.setUserDetailsInUsermodel(details: UserDefaults.standard.getUserDetails())
        
        name.text = user_data.user_name ?? ""
        email.text = user_data.user_email ?? ""
        
        
        
    }

    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func sendBtnAction(_ sender: Any) {
        
        if (subject.text?.isEmpty)! {
            Helper.showSnackBar(with: "Please fill the subject")
            return
        }
        else if (messege.text?.isEmpty)! {
            Helper.showSnackBar(with: "Please write your messege")
            return
        }
        
        service.getResponseFromServer(parametrs: "\(feedback)?name=\(name.text!)&&email=\(email.text!)&&subject=\(subject.text!)&&message=\(messege.text!)") { (results) in
            
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
