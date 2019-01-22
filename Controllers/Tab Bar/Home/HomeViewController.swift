//
//  HomeViewController.swift
//  Work2go
//
//  Created by Rajesh Gupta on 2/11/18.
//  Copyright © 2018 Rajesh Gupta. All rights reserved.
//

import UIKit
import MapKit




class HomeViewController: UIViewController , UIPickerViewDelegate , UIPickerViewDataSource {

    
    //MARK:
    //MARK: - -----------Declaration-----------
    
    @IBOutlet weak var countryField: UITextField!
    @IBOutlet weak var stateField: UITextField!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var jobTypeField: UITextField!
    @IBOutlet weak var serviceTypeField: UITextField!
    
    var country_id : String = ""
    var state_id : String = ""
    var city_id : String = ""
    var service_id : String = ""
    var job_type_id : String = ""
    
    var pickerView: UIPickerView!
    var pickerData = [AnyObject]()
    
    var get_user_id = ""
    
    @IBOutlet var searchHeader: UIView!
    @IBOutlet var searchHeader1: UIView!
    
    
    let service = ServerHandler()
    
    @IBOutlet weak var homeBtn: UITabBarItem!
    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var postedJobBtn: UIView!
    
    var jobList : [jobListModel] = []
    
    
    var locManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    var currentLat : String = ""
    var currentLng : String = ""
    
    
    //MARK:
    //MARK: - ----------- Life Cycle-----------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableview.estimatedRowHeight = 80
        self.tableview.rowHeight = UITableViewAutomaticDimension
        
        postedJobBtn.isHidden = true
        if UserDefaults.standard.isLoggedIn(){
            postedJobBtn.isHidden = false
        }
        Helper.cornerCircle(postedJobBtn)
        self.tableview.bounces = false
        
        pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        jobTypeField.inputView = pickerView
        
        DispatchQueue.main.async {
            self.getPickerData()
        }
        locManager.requestWhenInUseAuthorization()
        
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            currentLocation = locManager.location
           
            if let lat = currentLocation?.coordinate.latitude{
              currentLat = "\(lat)"
            }
            
            if let lng = currentLocation?.coordinate.longitude{
               currentLng = "\(lng)"
            }

        }
        
       
   
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if UserDefaults.standard.isLoggedIn() {
            let userData = Helper.setUserDetailsInUsermodel(details: UserDefaults.standard.getUserDetails())
            get_user_id = userData.user_id!
            if userData.country_name == "" {
                let profile = self.storyboard?.instantiateViewController(withIdentifier: "profile")
                self.navigationController?.pushViewController(profile!, animated: true)
            }else{
                self.getResponseHomeData()
            }
        }else{
            self.getResponseHomeData()
        }
        
        
    }
    
    func getResponseHomeData() {
        if isHomeContentBy == "searchWithoutContent" {
            self.getHomeData()
        }
    }
    
    //MARK:
    //MARK: - -----------Private Function & UIButton Action-----------
    
    func reloadTableDat(list:[[String:Any]]){
        
        self.jobList = []
        if list.count > 0{
            list.forEach{
                self.jobList.append(jobListModel(
                    id : $0["id"] as! String,
                    sender_id:   $0["sender_id"] as? String,
                    company_name:  $0["company_name"] as? String,
                    name:  $0["name"] as? String,
                    salary:  $0["salary"] as? String,
                    experience:  $0["experience"] as? String,
                    country:  $0["country"] as? String,
                    state:  $0["state"] as? String,
                    city:  $0["city"] as? String,
                    posted_date:  $0["posted_date"] as? String,
                    wish:  $0["wish"] as? String
                ))
            }
            print(self.jobList)
            self.tableview.reloadData()
        }
        
    }
    
    
    
    
    func getHomeData()  {
        
        if isHomeContentBy == "searchWithoutContent" {
            service.getResponseFromServer(parametrs: "nearby_search.php?user_id=\(get_user_id)&&lat=\(currentLat)&&lng=\(currentLng)") { (results) in
                let status = results["status"] as? String ?? ""
                if status == "1"{
                    let list = results["job_list"] as! [[String:Any]]
                    self.reloadTableDat(list: list)
                }
                else{
                    Helper.showSnackBar(with: results["message"] as? String ?? "")
                    self.jobList = []
                    self.tableview.reloadData()
                    
                }
            }
        }else{
            
            service.getResponseFromServer(parametrs: "\(home_search)?country_id=\(country_id)&&state_id=\(state_id)&&city_id=\(city_id)&&services_id=\(service_id)&&job_type=\(job_type_id)&&user_id=\(get_user_id)") { (results) in
                
                let status = results["status"] as? String ?? ""
                if status == "1"{
                    let list = results["job_list"] as! [[String:Any]]
                    self.jobList = []
                    if list.count > 0{
                        list.forEach{
                            self.jobList.append(jobListModel(
                                id : $0["id"] as! String,
                                sender_id:   $0["sender_id"] as? String,
                                company_name:  $0["company_name"] as? String,
                                name:  $0["name"] as? String,
                                salary:  $0["salary"] as? String,
                                experience:  $0["experience"] as? String,
                                country:  $0["country"] as? String,
                                state:  $0["state"] as? String,
                                city:  $0["city"] as? String,
                                posted_date:  $0["posted_date"] as? String,
                                wish:  $0["wish"] as? String
                            ))
                        }
                        print(self.jobList)
                        self.tableview.reloadData()
                    }
                    
                }else{
                    Helper.showSnackBar(with: results["message"] as? String ?? "")
                    self.jobList = []
                    self.tableview.reloadData()
                    
                }
            }
        }
    }
    
    @IBAction func searchHeaderBtnAction1(_ sender: Any) {
        isHomeContentBy = "searchWithContent"
        self.tableview.reloadData()
        
        
    }
    @IBAction func searchHeaderBtnAction(_ sender: Any) {
        isHomeContentBy = "searchWithoutContent"
        self.tableview.reloadData()
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
    @IBAction func servieTypeBtnAction(_ sender: Any) {
        
        let login = self.storyboard?.instantiateViewController(withIdentifier: "searchitem") as! SearchItemViewController
        login.api_name = select_category as String
        login.isFrom = "SERVICE"
        present(login, animated: true, completion: nil)
        login.onCompletion = {(id: String , data: String) -> Void in
            
            self.service_id = id as String
            self.serviceTypeField.text = data as String
            
        }
    }
    @IBAction func searchBtnAction(_ sender: Any) {
        
        if (countryField.text?.isEmpty)! {
            Helper.showSnackBar(with: "Select your country")
            return
        }
//        else if (stateField.text?.isEmpty)! {
//            Helper.showSnackBar(with: "Select your state")
//            return
//        }
//        else if (cityField.text?.isEmpty)! {
//            Helper.showSnackBar(with: "Select your city")
//            return
//        }
//        else if (jobTypeField.text?.isEmpty)! {
//            Helper.showSnackBar(with: "Select your job type")
//            return
//        }
//        else if (serviceTypeField.text?.isEmpty)! {
//            Helper.showSnackBar(with: "Select your service type")
//            return
//        }
        
        self.getHomeData()
       
    }
  
    @IBAction func postedJobBtnAction(_ sender: Any) {
        
        let job = self.storyboard?.instantiateViewController(withIdentifier: "postnewjob")
        self.navigationController?.pushViewController(job!, animated: true)
        
    }
    
    
    
    
    //MARK:
    //MARK: - -----------UIPickerViewDelegate & UIPickerViewDataSource-----------
    func getPickerData()  {
        
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
        

        jobTypeField.text = pickerData[row]["name"] as? String ?? ""
        job_type_id = pickerData[row]["id"] as? String ?? ""
    }
    
  
 
}
