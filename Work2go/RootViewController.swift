//
//  RootViewController.swift
//  Work2go
//
//  Created by Rajesh Gupta on 2/11/18.
//  Copyright © 2018 Rajesh Gupta. All rights reserved.
//

import UIKit

class RootViewController: UIViewController , UIPickerViewDelegate , UIPickerViewDataSource  {

    
    
    @IBOutlet weak var countryBtn: UIButton!
    @IBOutlet weak var stateBtn: UIButton!
    @IBOutlet weak var cityBtn: UIButton!
    @IBOutlet weak var serviceBtn: UIButton!
    
    @IBOutlet weak var jobType: UITextField!
    @IBOutlet weak var countryField: UITextField!
    @IBOutlet weak var stateField: UITextField!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var serviceType: UITextField!
    
    var country_id : String = ""
    var state_id : String = ""
    var city_id : String = ""
    var service_id : String = ""
    var job_type_id : String = ""
    
    var pickerView: UIPickerView!
    var pickerData = [AnyObject]()
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.isStatusBarHidden = false
        UIApplication.shared.statusBarStyle = .lightContent
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        statusBar.backgroundColor = Helper.hexStringToUIColor(hex: "333333")
        
        
        pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        jobType.inputView = pickerView
        self.getPickerData()
        
        
    }
    
    
    //MARK:
    //MARK: - -----------UIPickerViewDelegate & UIPickerViewDataSource-----------
    func getPickerData()  {
        
        let service = ServerHandler()
        service.getResponseFromServer(parametrs: "select_type.php") { (results) in
            
            let status = results["success"] as? String ?? ""
            if status == "1"{
                self.pickerData = results["type_list"] as! [AnyObject]
            }else{
                AJAlertController.initialization().showAlertWithOkButton(aStrMessage: results["message"] as? String ?? "") { (index, title) in
                    print(index,title)
                }
            }
        }
        
    }
    

    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
         return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return pickerData[row]["name"] as? String
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        jobType.text = pickerData[row]["name"] as? String ?? ""
        job_type_id = pickerData[row]["id"] as? String ?? ""
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
    
    @IBAction func serviceTypeBtnAction(_ sender: Any) {
        
        let login = self.storyboard?.instantiateViewController(withIdentifier: "searchitem") as! SearchItemViewController
        login.api_name = select_category as String
        login.isFrom = "SERVICE"
        present(login, animated: true, completion: nil)
        login.onCompletion = {(id: String , data: String) -> Void in
            
            self.service_id = id as String
            self.serviceType.text = data as String
            
        }
        
    }
    @IBAction func SignupAction(_ sender: Any) {
        
        let login = self.storyboard?.instantiateViewController(withIdentifier: "signup")
        self.navigationController?.pushViewController(login!, animated: true)
    }
    
    @IBAction func signInAction(_ sender: Any) {
        
        let login = self.storyboard?.instantiateViewController(withIdentifier: "signin")
        self.navigationController?.pushViewController(login!, animated: true)
        
    }
    
    @IBAction func searchAction(_ sender: Any) {
        
        if (countryField.text?.isEmpty)! {
            Helper.showSnackBar(with: "Select your country")
            return
        }
        else if (stateField.text?.isEmpty)! {
            Helper.showSnackBar(with: "Select your state")
            return
        }
        else if (cityField.text?.isEmpty)! {
            Helper.showSnackBar(with: "Select your city")
            return
        }
        else if (jobType.text?.isEmpty)! {
            Helper.showSnackBar(with: "Select your job type")
            return
        }
        else if (serviceType.text?.isEmpty)! {
            Helper.showSnackBar(with: "Select your service type")
            return
        }
        
        
        let login = self.storyboard?.instantiateViewController(withIdentifier: "tabbar")
        self.navigationController?.pushViewController(login!, animated: true)
    }
    
    
    


}
