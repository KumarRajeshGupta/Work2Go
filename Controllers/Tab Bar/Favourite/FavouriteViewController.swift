//
//  FavouriteViewController.swift
//  Work2go
//
//  Created by Rajesh Gupta on 2/12/18.
//  Copyright © 2018 Rajesh Gupta. All rights reserved.
//

import UIKit

class FavouriteViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {
    
    
    var favData :[ClassifiedModel] = []
    let service = ServerHandler()
    @IBOutlet weak var tblview: UITableView!
    
    var get_user_id = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user_data = Helper.setUserDetailsInUsermodel(details: UserDefaults.standard.getUserDetails())
        get_user_id = user_data.user_id!
        
        
        tblview.estimatedRowHeight = 80
        tblview.rowHeight = UITableViewAutomaticDimension
        
        self.getFavData()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func getFavData()  {
        
        service.getResponseFromServer(parametrs: "\(wishlist_details)?user_id=\(get_user_id)") { (results) in
            
            let status = results["status"] as? String ?? ""
            if status == "1"{
                
                let list = results["job_list"] as! [[String:Any]]
                self.reloadTableDat(list: list)
                
            }else{
                Helper.showSnackBar(with: results["message"] as? String ?? "")
                self.favData = []
                self.tblview.reloadData()
                
            }
        }
    }
    
    func reloadTableDat(list:[[String:Any]]){
        
        self.favData = []
        if list.count > 0{
            list.forEach{
                self.favData.append(ClassifiedModel(
                    city : $0["city"] as? String,
                    company_name:   $0["company_name"] as? String,
                    country:  $0["country"] as? String,
                    experience:  $0["experience"] as? String,
                    id:  $0["id"] as? String,
                    job_id:  $0["job_id"] as? String,
                    name:  $0["name"] as? String,
                    posted_date:  $0["posted_date"] as? String,
                    salary:  $0["salary"] as? String,
                    state:  $0["state"] as? String,
                    wish:  $0["wish"] as? String
                ))
            }
            print(self.favData)
            self.tblview.reloadData()
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.favData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tblview.dequeueReusableCell(withIdentifier: "classifiedcell") as! MyClassifiedJobTableViewCell
        cell.backgroundColor = .clear
        
        cell.contents = self.favData[indexPath.row]
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let user_data = Helper.setUserDetailsInUsermodel(details: UserDefaults.standard.getUserDetails())
        
        let job = self.storyboard?.instantiateViewController(withIdentifier: "jobdetails") as! JobDetailsViewController
        job.job_id = self.favData[indexPath.row].id!
        job.user_id = user_data.user_id!
        self.navigationController?.pushViewController(job, animated: true)
    }
    
    
    
}
