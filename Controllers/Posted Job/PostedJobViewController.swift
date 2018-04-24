//
//  PostedJobViewController.swift
//  Work2go
//
//  Created by Rajesh Gupta on 2/25/18.
//  Copyright © 2018 Rajesh Gupta. All rights reserved.
//

import UIKit



class PostedJobViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {

    @IBOutlet weak var tableview: UITableView!
    var postedJobData :[jobListModel] = []
    @IBOutlet weak var notfound: UILabel!
    
    let service = ServerHandler()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if UserDefaults.standard.isLoggedIn() {
            getMyPostedJobList()
        }
        
    }
    
    func reloadTableData(list:[[String:Any]]){
        
        self.postedJobData = []
        if list.count > 0{
            list.forEach{
                self.postedJobData.append(jobListModel(
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
            print(self.postedJobData)
            self.tableview.reloadData()
        }
        
    }
    func getMyPostedJobList() {
        
        let details = Helper.setUserDetailsInUsermodel(details: UserDefaults.standard.getUserDetails())
        
        service.getResponseFromServer(parametrs: "my_requirement.php?user_id=\(details.user_id ?? "")") { (results) in
            let status = results["status"] as? String ?? ""
            if status == "1"{
                let list = results["my_classified"] as! [[String:Any]]
                self.reloadTableData(list: list)
            }
            else{
                Helper.showSnackBar(with: results["message"] as? String ?? "")
                self.postedJobData = []
                self.tableview.reloadData()
                
            }
        }
    }
    
    
    //MARK:
    //MARK: - -----------UITableViewDelegate & UITableViewDataSource-----------

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.postedJobData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableview.dequeueReusableCell(withIdentifier: "home", for: indexPath) as! HomeTableViewCell
        
        cell.listContent = self.postedJobData[indexPath.row]
        cell.favBtn.isHidden = true
        
 
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let job = self.storyboard?.instantiateViewController(withIdentifier: "jobdetails") as! JobDetailsViewController
        job.job_id = self.postedJobData[indexPath.row].id
        let details = Helper.setUserDetailsInUsermodel(details: UserDefaults.standard.getUserDetails())
        job.user_id = details.user_id!
        self.navigationController?.pushViewController(job, animated: true)
        
    }
   
}
