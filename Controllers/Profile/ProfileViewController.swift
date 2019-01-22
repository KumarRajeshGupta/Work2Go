//
//  ProfileViewController.swift
//  Work2go
//
//  Created by Rajesh Gupta on 2/20/18.
//  Copyright © 2018 Rajesh Gupta. All rights reserved.
//

import UIKit
import CountryList

class ProfileViewController: UIViewController , CountryListDelegate{

    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var profileName: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var countryCodeBtn: UIButton!
    @IBOutlet weak var countryField: UITextField!
    @IBOutlet weak var stateField: UITextField!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var pinField: UITextField!
    
    var countryList = CountryList()
    
    var country_id : String = ""
    var state_id : String = ""
    var city_id : String = ""
    var userData : userModel!
    
    let service = ServerHandler()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //http://demo2.mediatrenz.com/worktogo-apps/Api/edit_image.php
        //Keys:user_id,file
        
        countryList.delegate = self
        Helper.cornerCircle(profileImg)
        
        userData = Helper.setUserDetailsInUsermodel(details: UserDefaults.standard.getUserDetails())
        
        country_id = userData.country_id ?? ""
        state_id = userData.state_id ?? ""
        city_id = userData.city_id ?? ""
        profileImg.sd_setImage(with: URL(string: UserDefaults.standard.getProfileImg() ?? ""), placeholderImage: UIImage(named: "placeholder"))
        
        profileName.text = userData.user_name ?? ""
        emailField.text = userData.user_email  ?? ""
        phoneField.text = userData.user_mob ?? ""
        countryField.text = userData.country_name  ?? ""
        stateField.text = userData.state_name  ?? ""
        cityField.text = userData.city_name  ?? ""
        addressField.text = userData.user_address ?? ""
        pinField.text = userData.postal_code ?? ""
        
    }
    @IBAction func updateBtnAction(_ sender: Any) {
        
        if (profileName.text?.isEmpty)! {
            Helper.showSnackBar(with: "Name field can't be empty")
            return
        }
        else if (countryCodeBtn.titleLabel?.text?.isEmpty)! {
            Helper.showSnackBar(with: "Please select your country code")
            return
        }
        else if (phoneField.text?.isEmpty)! {
            Helper.showSnackBar(with: "Please select your phone number")
            return
        }
        else if (countryField.text?.isEmpty)! {
            Helper.showSnackBar(with: "Please select your country")
            return
        }
        else if (stateField.text?.isEmpty)! {
            Helper.showSnackBar(with: "Please select your state")
            return
        }
        else if (cityField.text?.isEmpty)! {
            Helper.showSnackBar(with: "Please select your city")
            return
        }
        else if (addressField.text?.isEmpty)! {
            Helper.showSnackBar(with: "Please select your address")
            return
        }
        else if (pinField.text?.isEmpty)! {
            Helper.showSnackBar(with: "Please select your zip code")
            return
        }
        
       
        let params : [String:Any] = ["user_id": userData.user_id ?? "",
                                     "user_name": profileName.text!,
                                     "user_mob": "\(phoneField.text!)",
                                     "user_address": addressField.text!,
                                     "user_city": city_id,
                                     "user_state": state_id,
                                     "user_country": country_id,
                                     "postal_code": pinField.text!
                                   
        ]
        
        
        service.getResponseFromServerByPostMethod(parametrs: params, url: "\(profile_edit)") { (results) in
            
            let status = results["status"] as? String ?? ""
            if status == "1"{
                print(status)
                
                UserDefaults.standard.setUserDetails(value: results["user_info"] as! [String : Any])
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
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func profileBtnAction(_ sender: Any) {
        let actionSheetController: UIAlertController = UIAlertController(title: "Work2Go", message: "Upload profile image", preferredStyle: .actionSheet)
        let photoBtn: UIAlertAction = UIAlertAction(title: "Photo", style: .default) { action -> Void in
            self.selectImageFromGallery()
        }
        let cameraBtn: UIAlertAction = UIAlertAction(title: "Camera", style: .default) { action -> Void in
            self.selectImageFromGallery()
        }
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            //Just dismiss the action sheet
        }
        actionSheetController.addAction(photoBtn)
        actionSheetController.addAction(cameraBtn)
        actionSheetController.addAction(cancelAction)
        self.present(actionSheetController, animated: true, completion: nil)
    }
    @IBAction func countryCodeBtnAction(_ sender: Any) {
        let navController = UINavigationController(rootViewController: countryList)
        self.present(navController, animated: true, completion: nil)
    }
    @IBAction func countryBtnAction(_ sender: Any) {
        
        let login = self.storyboard?.instantiateViewController(withIdentifier: "searchitem") as! SearchItemViewController
        login.api_name = select_country as String
        login.isFrom = "COUNTRY"
        present(login, animated: true, completion: nil)
        login.onCompletion = {(id: String , data: String) -> Void in
            
            self.country_id = id as String
            self.countryField.text = data as String
            
            self.stateField.text = ""
            self.state_id = ""
            self.cityField.text = ""
            self.city_id = ""
        }
    }
    @IBAction func stateBtnAction(_ sender: Any) {
        
        if (countryField.text?.isEmpty)! {
            Helper.showSnackBar(with: "Select your country")
            return
        }
        
        let login = self.storyboard?.instantiateViewController(withIdentifier: "searchitem") as! SearchItemViewController
        login.api_name = (select_state as String) + "?country_id=" + self.country_id
        login.isFrom = "STATE"
        present(login, animated: true, completion: nil)
        login.onCompletion = {(id: String , data: String) -> Void in
            
            self.state_id = id as String
            self.stateField.text = data as String
            
            self.cityField.text = ""
            self.city_id = ""
        }
    }
    @IBAction func cityBtnAction(_ sender: Any) {
        
        
        if (countryField.text?.isEmpty)! {
            Helper.showSnackBar(with: "Select your country")
            return
        }
        else if (stateField.text?.isEmpty)! {
            Helper.showSnackBar(with: "Select your state")
            return
        }
        
        let login = self.storyboard?.instantiateViewController(withIdentifier: "searchitem") as! SearchItemViewController
        login.api_name = (select_city as String) + "?state_id=" + self.state_id
        login.isFrom = "CITY"
        present(login, animated: true, completion: nil)
        login.onCompletion = {(id: String , data: String) -> Void in
            
            self.city_id = id as String
            self.cityField.text = data as String
            
        }
    }
    
    func selectedCountry(country: Country) {
        
        print("\(country.flag!) \(country.name!), \(country.countryCode), \(country.phoneExtension)")
        countryCodeBtn.setTitle("(\(country.countryCode))  +\(country.phoneExtension)", for: .normal)
        
    }
    
    

}
