//
//  JobDetailsViewController.swift
//  Work2go
//
//  Created by Rajesh Gupta on 2/22/18.
//  Copyright © 2018 Rajesh Gupta. All rights reserved.
//

import UIKit

class JobDetailsViewController: UIViewController {

    let service = ServerHandler()
    
    var job_id = String()
    var user_id = String()
    
    
    @IBOutlet weak var postedUserView: UIView!
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var postedUserName: UILabel!
    
    @IBOutlet weak var jobName: UILabel!
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var jobDesc: UILabel!
    @IBOutlet weak var skills: UILabel!
    @IBOutlet weak var jobType: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!
    
    var isFrom = ""
    
    var jobDetails : JobDetailModel! = nil
    var employeeData :[EmployeeModel] = [EmployeeModel]()
    

    @IBOutlet weak var appliedEmpTable: UITableView!
    @IBOutlet weak var appliedEmpView: UIView!
    
    
    @IBOutlet weak var applyBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.applyBtn.isHidden = true
        postedUserView.isHidden = true
        deleteBtn.isHidden = true
        appliedEmpView.isHidden = true
        
        self.appliedEmpTable.register(UINib.init(nibName: "AppliedEmployeeTableViewCell", bundle: nil), forCellReuseIdentifier: AppliedEmployeeTableViewCell.reuseId)
        
        getDetails()
        

    }
    
    
    @IBAction func deleteJobBtnAction(_ sender: UIButton) {
        AJAlertController.initialization().showAlert(aStrMessage: "Are you sure you want to delete this job?", aCancelBtnTitle: "NO", aOtherBtnTitle: "YES") { (index, title) in
            print(index,title)
            if index == 1{
               self.deleteJob()
            }
        }
    }
    
    @IBAction func chatBtnAction(_ sender: Any) {
        if UserDefaults.standard.isLoggedIn() {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "chathistory") as! ChatHistoryViewController
            
            UserDefaults.standard.set(self.jobDetails.jobId, forKey: "job_id")
            UserDefaults.standard.set(self.jobDetails.senderId, forKey: "receiver_id")
            UserDefaults.standard.set(self.companyName.text!, forKey: "receiver_name")
            UserDefaults.standard.set(self.jobName.text!, forKey: "job_title")
            
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let root = self.storyboard?.instantiateViewController(withIdentifier: "signin") as? SignInViewController
            self.navigationController?.pushViewController(root ?? UIViewController(), animated: true)
        }
    }
    @IBAction func backBtnAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func applyBtnAction(_ sender: Any) {
        
        if UserDefaults.standard.isLoggedIn() {
            
            if jobDetails.isApplied == "0" && jobDetails.senderId != self.user_id{
                self.applyJob()
            }
            else if jobDetails.senderId == self.user_id && jobDetails.job_filled == "0"{
                self.filledJob()
            }
            
        }else{
            let root = self.storyboard?.instantiateViewController(withIdentifier: "signin") as? SignInViewController
            self.navigationController?.pushViewController(root ?? UIViewController(), animated: true)
        }
    }

}
