//
//  ChatHistoryViewController.swift
//  Work2go
//
//  Created by Rajesh Gupta on 4/3/18.
//  Copyright © 2018 Rajesh Gupta. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import SDLoader



class ChatHistoryViewController: UIViewController{

    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var textview: IQTextView!
    
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var name: UILabel!
    var messages : [Messages] = []
    
    var postedByID = ""
    var jobID = ""
    
    var nameee = ""
    var companyNameeee = ""
    
     let sdLoder = SDLoader()
    
    var userID = ""
    
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let userData = Helper.setUserDetailsInUsermodel(details: UserDefaults.standard.getUserDetails())
        userID = userData.user_id!
        
        self.tableview.rowHeight = UITableViewAutomaticDimension
        self.tableview.estimatedRowHeight = 80
        
        self.tableview.register(UINib(nibName: "IncomingCell", bundle: nil), forCellReuseIdentifier: IncomingCell.reuseID)
        self.tableview.register(UINib(nibName: "OutgoingCell", bundle: nil), forCellReuseIdentifier: OutgoingCell.reuseID)
        
        name.text = nameee
        companyName.text = companyNameeee
        
        
      
        
        
        
        getChatHistory()
    
        
    }

    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getChatHistory() {
        
        let service = ServerHandler()
        let details = Helper.setUserDetailsInUsermodel(details: UserDefaults.standard.getUserDetails())
        
        service.getResponseFromServer(parametrs: "job_chat_details.php?user_id=\(details.user_id!)&&posted_by_id=\(postedByID)&&job_id=\(jobID)") { (results) in
            let status = results["status"] as? String ?? ""
            if status == "1"{
                let list = results["chat_info"] as! [[String:Any]]
                self.updateInModel(list: list)
            }
            else{
                Helper.showSnackBar(with: results["message"] as? String ?? "")
                self.messages = []
                self.tableview.reloadData()
                
            }
        }
    }
    func updateInModel(list:[[String:Any]]){
        
        self.messages = []
        if list.count > 0{
            list.forEach{
                self.messages.append(Messages(
                    message:  $0["message"] as? String,
                    sender_id:   $0["sender_id"] as? String,
                    sender_name : $0["sender_name"] as? String,
                    sender_image:  $0["sender_image"] as? String,
                    time:  $0["time"] as? String,
                    type:  $0["type"] as? String
                    
                ))
            }
            print(self.messages.count)
            self.tableview.reloadData()
            if self.messages.count > 0{
                DispatchQueue.main.async {
                    self.tableview.scrollToLastCall(animated: true)
                }
            }
            
        }
        
    }
    @IBAction func attachBtnAction(_ sender: Any) {
        Helper.showSnackBar(with: "Comming Soon")
        
    }
    
    @IBAction func sendBtnAction(_ sender: Any) {
        if textview.text == "Type a message..." || textview.text.isEmpty {
        }else{
            
           
            self.sdLoder.startAnimating(atView: (UIApplication.shared.keyWindow?.rootViewController?.view)!)
            DispatchQueue.main.async(execute: {
                
                let details = Helper.setUserDetailsInUsermodel(details: UserDefaults.standard.getUserDetails())
                
                let str = "\(baseURL)job_chat.php?sender_id=\(details.user_id!)&&reciver_id=\(self.postedByID)&&job_id=\(self.jobID)&&type=text&&message=\(self.textview.text!)".condenseWhitespace()
                print(str)
                
                let urlString = str.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                
                let url = URL(string: urlString!)
                
                URLSession.shared.dataTask(with: url!, completionHandler: {
                    (data, response, error) in
                    if(error != nil){
                        print("error")
                    }else{
                        do{
                            let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String : AnyObject]
                            print(json)
                            DispatchQueue.main.async {
                                self.sdLoder.stopAnimation()
                                 self.getChatHistory()
                                 self.textview.text = ""
                            }
                            
                        }catch let error as NSError{
                           self.sdLoder.stopAnimation()
                            print(error)
                        }
                    }
                }).resume()
                
                
            })
            
            
            
        }
    }
    
    
    
}

extension String {
    func condenseWhitespace() -> String {
        let components = self.components(separatedBy: NSCharacterSet.whitespacesAndNewlines)
        return components.filter { !$0.isEmpty }.joined(separator: "%20")
    }
}

extension UITableView {
    func scrollToLastCall(animated : Bool) {
        let lastSectionIndex = self.numberOfSections - 1 // last section
        let lastRowIndex = self.numberOfRows(inSection: lastSectionIndex) - 1 // last row
        self.scrollToRow(at: IndexPath(row: lastRowIndex, section: lastSectionIndex), at: .bottom, animated: animated)
    }
}
