//
//  PostNewJobViewController.swift
//  Work2go
//
//  Created by Rajesh Gupta on 2/25/18.
//  Copyright © 2018 Rajesh Gupta. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class PostNewJobViewController: UIViewController , UIPickerViewDelegate , UIPickerViewDataSource {
    @IBOutlet weak var descView: UIView!
    @IBOutlet weak var textView: IQTextView!
    
    
    
    @IBOutlet weak var jobTitle: UITextField!
    @IBOutlet weak var industry: UITextField!
    @IBOutlet weak var functionalArea: UITextField!
    @IBOutlet weak var jobType: UITextField!
    @IBOutlet weak var exp: UITextField!
    @IBOutlet weak var country: UITextField!
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var skills: UITextField!
    @IBOutlet weak var salary: UITextField!
    
    let service = ServerHandler()
    
    var industriesData = [AnyObject]()
    var industryPickerView: UIPickerView!
    var industry_id = ""
    
    var functionalAreaData = [AnyObject]()
    var functionalAreaPickerView: UIPickerView!
    var functionalArea_id = ""
    
    
    var jobTypeData = [AnyObject]()
    var jobTypePickerView: UIPickerView!
    var jobType_id = ""
    
    var experienceData = ["Fresher","<1","2","3","4","5","6","7","8","9","10"]
    var experiencePickerView: UIPickerView!
    var experience_id = ""
    
    
    var country_id : String = ""
    var state_id : String = ""
    var city_id : String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       Helper.border(descView)
        
        
        service.getResponseFromServer(parametrs: "select_category.php") { (results) in
            
            let status = results["success"] as? String ?? ""
            
            if status == "1" {
                self.industriesData = results["category_list"] as!  [AnyObject]
            }
            else{
                Helper.showSnackBar(with: results["message"] as? String ?? "")
            }
        }
        
        industryPickerView = UIPickerView()
        industryPickerView.dataSource = self
        industryPickerView.delegate = self
        industry.inputView = industryPickerView
        
        
        functionalAreaPickerView = UIPickerView()
        functionalAreaPickerView.dataSource = self
        functionalAreaPickerView.delegate = self
        functionalArea.inputView = functionalAreaPickerView
        
        
        DispatchQueue.main.async {
            self.getjoTypeData()
            
            self.jobTypePickerView = UIPickerView()
            self.jobTypePickerView.dataSource = self
            self.jobTypePickerView.delegate = self
            self.jobType.inputView = self.jobTypePickerView
        }
        
        DispatchQueue.main.async {
            
            self.experiencePickerView = UIPickerView()
            self.experiencePickerView.dataSource = self
            self.experiencePickerView.delegate = self
            self.exp.inputView = self.experiencePickerView
            
        }
        
        

    }
    
    func getjoTypeData()  {
        
        service.getResponseFromServer(parametrs: "select_type.php") { (results) in
            
            let status = results["success"] as? String ?? ""
            if status == "1"{
                self.jobTypeData = results["type_list"] as! [AnyObject]
            }else{
               Helper.showSnackBar(with: results["message"] as? String ?? "")
            }
        }
        
    }
    
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func postBtnAction(_ sender: Any) {
        
        if (jobTitle.text?.isEmpty)! {
             Helper.showSnackBar(with: "Please fill the job title")
            return
        }
        else if (industry.text?.isEmpty)! {
            Helper.showSnackBar(with: "Please select the industry")
            return
        }
        else if (jobType.text?.isEmpty)! {
            Helper.showSnackBar(with: "Please select job type")
            return
        }
        else if (exp.text?.isEmpty)! {
            Helper.showSnackBar(with: "Please select experience")
            return
        }
        else if (country.text?.isEmpty)! {
            Helper.showSnackBar(with: "Please select country")
            return
        }
        else if (state.text?.isEmpty)! {
            Helper.showSnackBar(with: "Please select state")
            return
        }
        else if (city.text?.isEmpty)! {
            Helper.showSnackBar(with: "Please select city")
            return
        }
        else if (skills.text?.isEmpty)! {
            Helper.showSnackBar(with: "Please fill the skills")
            return
        }
        else if (salary.text?.isEmpty)! {
            Helper.showSnackBar(with: "Please fill the salary")
            return
        }
        else if (textView.text?.isEmpty)! {
            Helper.showSnackBar(with: "Please fill the descriptions")
            return
        }
        
        
        let user_data = Helper.setUserDetailsInUsermodel(details: UserDefaults.standard.getUserDetails())
        let params: [String:Any] = [
            "user_id":user_data.user_id!,
            "job_type":jobType_id,
            "category_id":industry_id,
            "subcategory_id":functionalArea_id,
            "title":jobTitle.text!,
            "description":textView.text!,
            "skill_need":skills.text!,
            "country":country_id,
            "state":state_id,
            "city":city_id,
            "salary":salary.text!,
            "experience":exp.text!]
        
        service.getResponseFromServerByPostMethod(parametrs: params, url: "post_new_requirement.php") { (results) in
            
            let status = results["status"] as? String ?? ""
            if status == "1"{
                AJAlertController.initialization().showAlertWithOkButton(aStrMessage: results["message"] as? String ?? "") { (index, title) in
                    print(index,title)
                    let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
                    self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
                }
            }else{
                Helper.showSnackBar(with: results["message"] as? String ?? "")
            }
            
        }
        //        Key:
        //        user_id,job_type,category_id,subcategory_id,title,description,skill_need,salary,country,state,city,experience

        
        
    }
    
   
    @IBAction func countryBtnAction(_ sender: Any) {
        
        let login = self.storyboard?.instantiateViewController(withIdentifier: "searchitem") as! SearchItemViewController
        login.api_name = select_country as String
        login.isFrom = "COUNTRY"
        present(login, animated: true, completion: nil)
        login.onCompletion = {(id: String , data: String) -> Void in
            
            self.country_id = id as String
            self.country.text = data as String
            
            self.state.text = ""
            self.state_id = ""
            self.city.text = ""
            self.city_id = ""
        }
    }
    @IBAction func stateBtnAction(_ sender: Any) {
        
        if (country.text?.isEmpty)! {
            Helper.showSnackBar(with: "Select your country")
            return
        }
        
        let login = self.storyboard?.instantiateViewController(withIdentifier: "searchitem") as! SearchItemViewController
        login.api_name = (select_state as String) + "?country_id=" + self.country_id
        login.isFrom = "STATE"
        present(login, animated: true, completion: nil)
        login.onCompletion = {(id: String , data: String) -> Void in
            
            self.state_id = id as String
            self.state.text = data as String
            
            self.city.text = ""
            self.city_id = ""
        }
    }
    @IBAction func cityBtnAction(_ sender: Any) {
        
        if (country.text?.isEmpty)! {
            Helper.showSnackBar(with: "Select your country")
            return
        }
        else if (state.text?.isEmpty)! {
            Helper.showSnackBar(with: "Select your state")
            return
        }
        
        let login = self.storyboard?.instantiateViewController(withIdentifier: "searchitem") as! SearchItemViewController
        login.api_name = (select_city as String) + "?state_id=" + self.state_id
        login.isFrom = "CITY"
        present(login, animated: true, completion: nil)
        login.onCompletion = {(id: String , data: String) -> Void in
            
            self.city_id = id as String
            self.city.text = data as String
            
        }
    }
    
    
    
    
    
    
    
    //MARK:
    //MARK: - -----------UIPickerViewDelegate & UIPickerViewDataSource-----------
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        if pickerView == self.industryPickerView {
            return industriesData.count
        }
        else if pickerView == self.functionalAreaPickerView {
            return functionalAreaData.count
        }
        else if pickerView == self.jobTypePickerView {
            return jobTypeData.count
        }
        else if pickerView == self.experiencePickerView {
            return experienceData.count
        }
        
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == self.industryPickerView {
            return industriesData[row]["name"] as? String ?? ""
        }
         else if pickerView == self.functionalAreaPickerView {
            return functionalAreaData[row]["name"] as? String ?? ""
        }
        else if pickerView == self.jobTypePickerView {
            return jobTypeData[row]["name"] as? String ?? ""
        }
        else if pickerView == self.experiencePickerView {
            return experienceData[row]
        }
        
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
       
        if pickerView == self.industryPickerView {
            
            industry.text = industriesData[row]["name"] as? String ?? ""
            industry_id = industriesData[row]["id"] as? String ?? ""
            
            service.getResponseFromServer(parametrs: "select_sub_category.php?cat_id=\(industry_id)") { (results) in
                
                let status = results["success"] as? String ?? ""
                
                if status == "1" {
                    self.functionalAreaData = results["sub_category"] as!  [AnyObject]
                    self.functionalAreaPickerView.reloadAllComponents()
                }
                else{
                    Helper.showSnackBar(with: results["message"] as? String ?? "")
                }
            }
        }
        
        else if pickerView == self.functionalAreaPickerView {
            
            functionalArea.text = functionalAreaData[row]["name"] as? String ?? ""
            functionalArea_id = functionalAreaData[row]["id"] as? String ?? ""
        }
        
        else if pickerView == self.jobTypePickerView {
            
            jobType.text = jobTypeData[row]["name"] as? String ?? ""
            jobType_id = jobTypeData[row]["id"] as? String ?? ""
        }
        else if pickerView == self.experiencePickerView {
            
            exp.text = experienceData[row]
            experience_id = experienceData[row]
        }
        
        
    }
    
    
    

}
