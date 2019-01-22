//
//  MyClassifiedJobViewController.swift
//  Work2go
//
//  Created by Rajesh Gupta on 2/26/18.
//  Copyright © 2018 Rajesh Gupta. All rights reserved.
//

import UIKit

class MyClassifiedJobViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {

    let service = ServerHandler()
    var tableData : [ClassifiedModel] = []
    
    @IBOutlet weak var navigationTitle: UILabel!
    @IBOutlet weak var tableview: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableview.estimatedRowHeight = 80
        self.tableview.rowHeight = UITableViewAutomaticDimension
        
        let user_data = Helper.setUserDetailsInUsermodel(details: UserDefaults.standard.getUserDetails())
        
        service.getResponseFromServer(parametrs: "my_applied_job.php?user_id=\(user_data.user_id ?? "")") { (results) in
            
            let status = results["status"] as? String ?? ""
            if status == "1"{
                let list = results["job_list"] as! [[String:Any]]
                self.reloadTableDat(list: list)
            }else{
                Helper.showSnackBar(with: results["message"] as? String ?? "")
                self.tableData = []
                self.tableview.reloadData()
            }
        }

    }
    
    
    func reloadTableDat(list:[[String:Any]]){
        
        self.tableData = []
        if list.count > 0{
            list.forEach{
                self.tableData.append(ClassifiedModel(
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
            print(self.tableData)
            self.tableview.reloadData()
        }
        
    }
    
    
    
    

    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK:
    //MARK: - -----------UITableViewDelegate & UITableViewDataSource-----------
    
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData.count
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableview.dequeueReusableCell(withIdentifier: "classifiedcell") as! MyClassifiedJobTableViewCell
        cell.backgroundColor = .clear

        cell.contents = self.tableData[indexPath.row]
     
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let job = self.storyboard?.instantiateViewController(withIdentifier: "jobdetails") as! JobDetailsViewController
        job.job_id = self.tableData[indexPath.row].id!
        let details = Helper.setUserDetailsInUsermodel(details: UserDefaults.standard.getUserDetails())
        job.user_id = details.user_id!
        self.navigationController?.pushViewController(job, animated: true)
     
    }

}
