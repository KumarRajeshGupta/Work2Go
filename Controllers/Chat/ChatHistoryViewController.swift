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







class ChatHistoryViewController: UIViewController , ToolbarDelegate{
   
    
    @IBOutlet weak var toolbar: Toolbar!
    open var messengerView: ChatView?
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var name: UILabel!
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let userData = Helper.setUserDetailsInUsermodel(details: UserDefaults.standard.getUserDetails())
        TotalChat.shared.userId = userData.user_id!
        name.text = UserDefaults.standard.string(forKey: "receiver_name")
        companyName.text = UserDefaults.standard.string(forKey: "job_title")
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("NotificationIdentifier"), object: nil)
        toolbar.delegate = self

        getChatHistory()
    
        
    }
    fileprivate func loadMessengerView() {
        let app = UIApplication.shared
        let height = app.statusBarFrame.size.height
        if self.messengerView != nil {
            self.messengerView?.removeFromSuperview()
        }
        self.messengerView = ChatView(frame: CGRect(x: 0, y: headerView.frame.origin.y+headerView.frame.size.height, width: self.view.frame.size.width, height: self.view.frame.size.height-headerView.frame.size.height-toolbar.frame.size.height-height))
        self.messengerView?.tableView.reloadData()
        self.messengerView?.layoutIfNeeded()
        self.view.addSubview(self.messengerView!)
    }

    
    @objc func methodOfReceivedNotification(notification: Notification){

        getChatHistory()
    }
   
    func toolbar(type: String) {
        getChatHistory()
    }
    

    @IBAction func backBtnAction(_ sender: Any) {
        if UserDefaults.standard.bool(forKey: "isBackgroundState") {
            let tab = self.storyboard?.instantiateViewController(withIdentifier: "tabbar") as! TabBarViewController
            tab.selectedIndex = 2
            self.navigationController?.pushViewController(tab, animated: false)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func getChatHistory() {
        
        let service = ServerHandler()
        let details = Helper.setUserDetailsInUsermodel(details: UserDefaults.standard.getUserDetails())
        let rec_id = UserDefaults.standard.string(forKey: "receiver_id")
        let jb_id = UserDefaults.standard.string(forKey: "job_id")
        
        service.getResponseFromServer(parametrs: "job_chat_details.php?user_id=\(details.user_id!)&&posted_by_id=\(rec_id ?? "")&&job_id=\(jb_id ?? "")") { (results) in
            let status = results["status"] as? String ?? ""
            if status == "1"{
                let list = results["chat_info"] as! [[String:Any]]
                self.updateInModel(list: list)
            }
            else{
                Helper.showSnackBar(with: results["message"] as? String ?? "")
                TotalChat.shared.chats = []
            }
        }
    }
    
    
    
    func updateInModel(list:[[String:Any]]){
        
        var final: [[String:Any]] = []
        
        var temp: [String] = []
        let dateFormate1 = DateFormatter()
        dateFormate1.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "yyyy-MM-dd"
        
        list.forEach{
            let date: Date? = dateFormate1.date(from: $0["time"] as? String ?? "")
            var dateStr: String? = nil
            if let aDate = date {
                dateStr = dateFormate.string(from: aDate)
            }
            temp.append(dateStr ?? "")
        }
        
        let orderedSet = NSOrderedSet(array: temp)
        let arrayWithoutDuplicates : [String] = orderedSet.array as! [String]
        
       
        for i in 0..<arrayWithoutDuplicates.count {
           
            var dictt: [String : Any] = [:]
            var temp1: [[String:Any]] = []
           
               list.forEach{
                let date: Date? = dateFormate1.date(from: $0["time"] as? String ?? "")
                var dateStr: String? = nil
                if let aDate = date {
                    dateStr = dateFormate.string(from: aDate)
                }
                if (dateStr == arrayWithoutDuplicates[i]) {
                    temp1.append($0)
                }
            }
            dictt["date"] = arrayWithoutDuplicates[i]
            dictt["data"] = temp1
            final.append(dictt)
        }
        
        if final.count > 0 {
            final.forEach{
                TotalChat.shared.chats.append(ChatModel(timestamp: $0["date"] as! String,
                                                        chatRow:  self.chatRow(data: $0["data"] as! [[String : Any]])))
            }
        }
        
        print(TotalChat.shared.chats)
        
        self.loadMessengerView()
    }
    
   
    func chatRow(data:[[String:Any]]) -> [ChatRow] {
        
        var chat : [ChatRow] = []
        if data.count > 0 {
            data.forEach{
                chat.append(ChatRow(type: $0["type"] as! String,
                                    id: $0["message_id"] as! String,
                                    text: $0["message"] as! String,
                                    sender_img: $0["sender_image"] as? String ?? "",
                                    senderId: $0["sender_id"] as! String,
                                    timestamp: $0["time"] as! String))
            }
            
            
        }
        return chat
    }
 
}

extension String {
    func condenseWhitespace() -> String {
        let components = self.components(separatedBy: NSCharacterSet.whitespacesAndNewlines)
        return components.filter { !$0.isEmpty }.joined(separator: "%20")
    }
}


