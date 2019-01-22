//
//  JobModel.swift
//  Work2go
//
//  Created by Rajesh Gupta on 5/19/18.
//  Copyright © 2018 Rajesh Gupta. All rights reserved.
//

import UIKit


struct JobDetailModel {
    let jobName : String
    let companyname : String
    let city : String
    let state : String
    let country : String
    let postedDate : String
    let description : String?
    let skill : String
    let jobType : String
    let postedUserName : String
    let userImage : String?
    let jobId : String
    let job_filled : String
    let senderId : String
    let isApplied : String
    
}

struct EmployeeModel {
    let Name : String
    let Id : String
    let resume : String
    let email : String
    let phone : String
}


extension JobDetailsViewController{
    
    func getDetails()  {
        
        service.getResponseFromServer(parametrs: "applied_person_list.php?user_id=\(user_id)&&job_id=\(job_id)") { (results) in
            
            let status = results["status"] as? String ?? ""
            if status == "1"{
                
                let dictData = results["job_list"] as! [String : Any]
                
                self.jobDetails = JobDetailModel(jobName: dictData["name"] as! String,
                                                 companyname: dictData["company_name"] as! String,
                                                 city: dictData["city"] as! String,
                                                 state: dictData["state"] as! String,
                                                 country: dictData["country"] as! String,
                                                 postedDate: dictData["posted_date"] as! String,
                                                 description: dictData["description"] as? String,
                                                 skill: dictData["skill_need"] as! String,
                                                 jobType: dictData["job_type"] as! String,
                                                 postedUserName: dictData["company_name"] as! String,
                                                 userImage: dictData["sender_image"] as? String,
                                                 jobId: dictData["id"] as! String,
                                                 job_filled: dictData["job_filled"] as! String,
                                                 senderId: dictData["sender_id"] as! String,
                                                 isApplied: dictData["applied"] as! String)
                
                
                let list = dictData["member_list"] as! [[String:Any]]
                
                if list.count > 0{
                    list.forEach{
                        self.employeeData.append(EmployeeModel(
                            Name: $0["name"] as! String,
                            Id : $0["id"] as! String,
                            resume: $0["resume"] as! String,
                            email: $0["user_email"] as! String,
                            phone: $0["user_mob"] as! String
                            
                        ))
                    }
                }
                
                self.setContent()

                
            }else{
                Helper.showSnackBar(with: results["message"] as? String ?? "")
            }
        }
    }
    func setContent() {
        
        self.jobName.text = self.jobDetails.jobName
        self.companyName.text = "\(jobDetails.companyname), \(jobDetails.country)"
        self.address.text = "\(jobDetails.city), \(jobDetails.state)"
        self.date.text = jobDetails.postedDate
        
        self.jobDesc.text = jobDetails.description ?? ""
        self.skills.text = jobDetails.skill
        self.jobType.text = jobDetails.jobType
        
        self.postedUserName.text = jobDetails.companyname
        self.userImg.sd_setImage(with: URL(string: jobDetails.userImage ?? ""), placeholderImage: UIImage(named: "placeholder"))
        self.applyBtn.isHidden = false
        
        
        if jobDetails.isApplied == "0" && jobDetails.senderId != self.user_id{
            
            self.postedUserView.isHidden = false
            self.applyBtn.backgroundColor = Helper.hexStringToUIColor(hex: "fda567")
            self.applyBtn.setTitle("Apply", for: .normal)
            
        }
        else if jobDetails.isApplied == "1" && jobDetails.senderId != self.user_id{
            
            self.postedUserView.isHidden = false
            self.applyBtn.backgroundColor = Helper.hexStringToUIColor(hex: "980202")
            self.applyBtn.setTitle("Already Applied", for: .normal)
        }
        else if jobDetails.senderId == self.user_id && jobDetails.job_filled == "0"{
            self.deleteBtn.isHidden = false
            self.appliedEmpView.isHidden = false
            self.applyBtn.backgroundColor = Helper.hexStringToUIColor(hex: "fda567")
            self.applyBtn.setTitle("Job Field", for: .normal)
        }
        else if jobDetails.senderId == self.user_id && jobDetails.job_filled == "1"{
            self.deleteBtn.isHidden = false
            self.appliedEmpView.isHidden = false
            self.applyBtn.backgroundColor = Helper.hexStringToUIColor(hex: "980202")
            self.applyBtn.setTitle("This job already filled", for: .normal)
        }
        
        if self.employeeData.count == 0 {
             self.appliedEmpView.isHidden = true
        }
        
        self.appliedEmpTable.reloadData()
            
        
        if self.isFrom == "classified" {
            self.applyBtn.isHidden = true
            self.postedUserView.isHidden = true
        }
        
        
    }
    
    func deleteJob() {
       
        service.getResponseFromServer(parametrs: "delete_job.php?user_id=\(user_id)&&job_id=\(job_id)") { (results) in
            let status = results["status"] as? String ?? ""
            if status == "1"{
                self.navigationController?.popViewController(animated: true)
            }else{
                Helper.showSnackBar(with: results["message"] as? String ?? "")
            }
        }
    }
    
    func filledJob()  {
      
        service.getResponseFromServer(parametrs: "job_action.php?user_id=\(user_id)&&job_id=\(job_id)&&action=filled") { (results) in
            let status = results["status"] as? String ?? ""
            if status == "1"{
                self.getDetails()
            }else{
                Helper.showSnackBar(with: results["message"] as? String ?? "")
            }
        }
    }
    
    func applyJob()  {
        let params : [String :Any] = ["user_id":user_id,
                                      "job_id":job_id]
        
        service.getResponseFromServerByPostMethod(parametrs: params, url: "apply_job.php", completion: { (results) in
            
            let status = results["status"] as? String ?? ""
            if status == "1"{
               self.getDetails()
            }else{
                Helper.showSnackBar(with: results["message"] as? String ?? "")
            }
        })
    }
}


extension JobDetailsViewController : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return self.employeeData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.appliedEmpTable.dequeueReusableCell(withIdentifier: AppliedEmployeeTableViewCell.reuseId, for: indexPath) as! AppliedEmployeeTableViewCell
        
        cell.contents = self.employeeData[indexPath.row]
        
        return cell
    }
}

