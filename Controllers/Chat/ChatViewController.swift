//
//  ChatViewController.swift
//  Work2go
//
//  Created by Rajesh Gupta on 3/28/18.
//  Copyright © 2018 Rajesh Gupta. All rights reserved.
//

import UIKit

struct chatModel {
    
    let job_id : String?
    let job_title : String?
    let message_id : String?
    let message : String?
    let sender_id : String?
    let sender_name : String?
    let sender_image : String?
    let receiver_id : String?
    let receiver_name : String?
    let receiver_image : String?
    let time : String?
    let type : String?
    let owner : String?
    
    
}




class ChatViewController: UIViewController, UITableViewDelegate , UITableViewDataSource {

    var chatList : [chatModel] = []
    
    
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        tableview.backgroundColor = .clear
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UserDefaults.standard.isLoggedIn() {
             getChatList()
        }
    }
   
    func updateInModel(list:[[String:Any]]){
        
        self.chatList = []
        if list.count > 0{
            list.forEach{
                self.chatList.append(chatModel(
                    job_id : $0["job_id"] as? String,
                    job_title:  $0["job_title"] as? String,
                    message_id:  $0["message_id"] as? String,
                    message:  $0["message"] as? String,
                    sender_id:   $0["sender_id"] as? String,
                    sender_name:  $0["sender_name"] as? String,
                    sender_image:  $0["sender_image"] as? String,
                    receiver_id:  $0["receiver_id"] as? String,
                    receiver_name:  $0["receiver_name"] as? String,
                    receiver_image:  $0["receiver_image"] as? String,
                    time:  $0["time"] as? String,
                    type: $0["type"] as? String,
                    owner: $0["owner"] as? String
                ))
            }
            print(self.chatList)
            self.tableview.reloadData()
        }
        
    }
    
    func getChatList() {
        
        let service = ServerHandler()
        let details = Helper.setUserDetailsInUsermodel(details: UserDefaults.standard.getUserDetails())
        
        service.getResponseFromServer(parametrs: "chat_list.php?user_id=\(details.user_id!)") { (results) in
            let status = results["status"] as? String ?? ""
            if status == "1"{
                let list = results["chat_user_info"] as! [[String:Any]]
                self.updateInModel(list: list)
            }
            else{
                Helper.showSnackBar(with: results["message"] as? String ?? "")
                self.chatList = []
                self.tableview.reloadData()
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = self.tableview.dequeueReusableCell(withIdentifier: "chatcell", for: indexPath) as! ChatTableViewCell
        cell.listContent = self.chatList[indexPath.row]
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "chathistory") as! ChatHistoryViewController
        vc.jobID = self.chatList[indexPath.row].job_id!
        vc.postedByID = self.chatList[indexPath.row].receiver_id!
        vc.nameee = self.chatList[indexPath.row].receiver_name!
        vc.companyNameeee = self.chatList[indexPath.row].job_title!
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

}
