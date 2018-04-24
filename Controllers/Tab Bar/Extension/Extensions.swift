//
//  Extensions.swift
//  Work2go
//
//  Created by Rajesh Gupta on 3/28/18.
//  Copyright © 2018 Rajesh Gupta. All rights reserved.
//

import UIKit


extension HomeViewController : UITableViewDelegate , UITableViewDataSource{
    
    //MARK:
    //MARK: - -----------UITableViewDelegate & UITableViewDataSource-----------
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        
        if isClicked == "searchWithoutContent" {
            return searchHeader1.frame.size.height
        }
        else{
            return searchHeader.frame.size.height
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if isClicked == "searchWithoutContent" {
            
            searchHeader1.isHidden = false
            searchHeader.isHidden = true
            return searchHeader1
        }else{
            searchHeader1.isHidden = true
            searchHeader.isHidden = false
            return searchHeader
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobList.count
    }
  
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = self.tableview.dequeueReusableCell(withIdentifier: "home", for: indexPath) as! HomeTableViewCell
        
        cell.listContent = self.jobList[indexPath.row]
        
        cell.favBtn.tag = indexPath.row
        cell.favBtn.addTarget(self, action: #selector(self.fabBtnAction(_:)), for: .touchUpInside)
        
        
        return cell
    }
       func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let job = self.storyboard?.instantiateViewController(withIdentifier: "jobdetails") as! JobDetailsViewController
        job.job_id = self.jobList[indexPath.row].id
        job.user_id = get_user_id
        self.navigationController?.pushViewController(job, animated: true)
        
    }
    
    @objc func fabBtnAction(_ sender: UIButton) {
        
        
        if UserDefaults.standard.isLoggedIn() {
            var serviceType = ""
            
            if self.jobList[sender.tag].wish == "1" {
                serviceType = remove_wishlist
            }
            else{
                serviceType = add_to_wishlist
            }
            
            service.getResponseFromServer(parametrs: "\(serviceType)?user_id=\(get_user_id)&&classified_id=\(self.jobList[sender.tag].id)") { (results) in
                
                let status = results["status"] as? String ?? ""
                if status == "1"{
                    self.getHomeData()
                }else{
                    Helper.showSnackBar(with: results["message"] as? String ?? "")
                }
            }
        }else{
            let root = self.storyboard?.instantiateViewController(withIdentifier: "signin") as? SignInViewController
            self.navigationController?.pushViewController(root ?? UIViewController(), animated: true)
        }
        
    }
    
    
}
