//
//  AccountViewController.swift
//  Work2go
//
//  Created by Rajesh Gupta on 2/12/18.
//  Copyright © 2018 Rajesh Gupta. All rights reserved.
//

import UIKit
import SDWebImage



class TableViewCell: UITableViewCell {
   
    
    @IBOutlet weak var cellview: UIView!
    @IBOutlet weak var lbl: UILabel!
    
    
}



class AccountViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {

    @IBOutlet var headerview: UIView!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var designation: UILabel!
    
    var userData : userModel!
    

    var accountData = ["My Account","My Posted Jobs","My Applied Job","My Favourites","Change Password","Terms and Conditions","Feedback","Log Out"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Helper.cornerCircle(profileImg)
        
  
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UserDefaults.standard.isLoggedIn() {
            
            userData = Helper.setUserDetailsInUsermodel(details: UserDefaults.standard.getUserDetails())
            profileImg.sd_setImage(with: URL(string: userData.user_img ?? ""), placeholderImage: UIImage(named: "placeholder"))
            name.text = userData.user_name ?? ""
            designation.text = userData.user_type ?? ""
        }
    }
    
    //MARK:
    //MARK: - -----------UITableViewDelegate & UITableViewDataSource-----------
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{

       return headerview.frame.size.height

    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        return headerview

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 55
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.accountData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:TableViewCell = self.tableview.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell!
  
        cell.lbl.text = self.accountData[indexPath.row]

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            let profile = self.storyboard?.instantiateViewController(withIdentifier: "profile")
            self.navigationController?.pushViewController(profile!, animated: true)
            break
        case 1:
            let profile = self.storyboard?.instantiateViewController(withIdentifier: "my_classified_job") as! MyClassifiedJobViewController
            profile.isFrom = "posted-job"
            self.navigationController?.pushViewController(profile, animated: true)
            break
        case 2:
            let profile = self.storyboard?.instantiateViewController(withIdentifier: "my_classified_job") as! MyClassifiedJobViewController
            profile.isFrom = "classified-job"
            self.navigationController?.pushViewController(profile, animated: true)
            break
        case 3:
            let profile = self.storyboard?.instantiateViewController(withIdentifier: "favourite") as! FavouriteViewController
            self.navigationController?.pushViewController(profile, animated: true)
            break
        case 4:
            let profile = self.storyboard?.instantiateViewController(withIdentifier: "changepassword")
            self.navigationController?.pushViewController(profile!, animated: true)
            break
        case 5:
            Helper.showSnackBar(with: "Under Development")
            break
        case 6:
            let profile = self.storyboard?.instantiateViewController(withIdentifier: "feedback")
            self.navigationController?.pushViewController(profile!, animated: true)
            break
        case 7:
            self.logoutFunction()
            break
            
        default:
            break
        }
        
    }
    

    
    func logoutFunction() {
        
        
        AJAlertController.initialization().showAlert(aStrMessage: "Do you really want to log out ?", aCancelBtnTitle: "NO", aOtherBtnTitle: "YES") { (index, title) in
            print(index,title)
            if index == 1{
                UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.isLoggedIn.rawValue)
                UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.userdetails.rawValue)
                
                let login = self.storyboard?.instantiateViewController(withIdentifier: "tabbar")
                self.navigationController?.pushViewController(login!, animated: true)
                
            }
        }
        
    }

    
}
