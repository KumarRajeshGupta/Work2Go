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
    
    var isApplied = ""
    
    var isFrom = ""
    
    var jobID = ""
    var receiverID = ""
    
    
    
    @IBOutlet weak var applyBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.applyBtn.isHidden = true
        postedUserView.isHidden = true
        
        service.getResponseFromServer(parametrs: "applied_person_list.php?user_id=\(user_id)&&job_id=\(job_id)") { (results) in
            
            let status = results["status"] as? String ?? ""
            if status == "1"{
               
                let dictData = results["job_list"] as! [String : Any]
                
                self.jobName.text = dictData["name"] as? String ?? ""
                self.companyName.text = "\(dictData["company_name"] as? String ?? ""), \(dictData["country"] as? String ?? "")"
                self.address.text = "\(dictData["city"] as? String ?? ""), \(dictData["state"] as? String ?? "")"
                self.date.text = dictData["posted_date"] as? String ?? ""
                
                
                self.jobDesc.text = dictData["description"] as? String ?? ""
                self.skills.text = dictData["skill_need"] as? String ?? ""
                self.jobType.text = dictData["job_type"] as? String ?? ""
                
                self.postedUserName.text = dictData["company_name"] as? String ?? ""
                self.userImg.sd_setImage(with: URL(string: dictData["sender_image"] as? String ?? ""), placeholderImage: UIImage(named: "placeholder"))
                
                
                self.jobID = dictData["id"] as? String ?? ""
                self.receiverID = dictData["sender_id"] as? String ?? ""
                
                self.isApplied = dictData["applied"] as? String ?? ""
                
                self.applyBtn.backgroundColor = Helper.hexStringToUIColor(hex: "fda567")
                self.applyBtn.setTitle("Apply", for: .normal)
                
                if self.isApplied == "1"{
                    
                    self.applyBtn.backgroundColor = Helper.hexStringToUIColor(hex: "980202")
                    self.applyBtn.setTitle("Already Applied", for: .normal)
                }
                
                let postedBy = dictData["sender_id"] as? String ?? ""
                if postedBy == self.user_id {
                    self.applyBtn.isHidden = true
                    self.postedUserView.isHidden = true
                }else{
                    self.applyBtn.isHidden = false
                    self.postedUserView.isHidden = false
                }
                
                
                if self.isFrom == "classified" {
                   self.applyBtn.isHidden = true
                   self.postedUserView.isHidden = true
                }
                
                
            }else{
                Helper.showSnackBar(with: results["message"] as? String ?? "")
            }
        }

    }

    @IBAction func chatBtnAction(_ sender: Any) {
        if UserDefaults.standard.isLoggedIn() {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "chathistory") as! ChatHistoryViewController
            vc.jobID = self.jobID
            vc.postedByID = self.receiverID
            vc.nameee = self.companyName.text!
            vc.companyNameeee = self.jobName.text!
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
            
            if self.isApplied != "1"{
                
                let params : [String :Any] = ["user_id":user_id,
                                              "job_id":job_id]
                
                service.getResponseFromServerByPostMethod(parametrs: params, url: "apply_job.php", completion: { (results) in
                    
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
                    
                })
            }
        }else{
            let root = self.storyboard?.instantiateViewController(withIdentifier: "signin") as? SignInViewController
            self.navigationController?.pushViewController(root ?? UIViewController(), animated: true)
        }
    }

}
