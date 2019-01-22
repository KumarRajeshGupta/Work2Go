//
//  Chat.swift
//  RMessage
//
//  Created by Rajesh Gupta on 5/30/18.
//  Copyright © 2018 Rajesh Gupta. All rights reserved.
//

import Foundation
import UIKit


enum Chat {
    case incominText
    case incomingMedia
    case outgoingText
    case outgoingMedia
    case none
}

class ChatType {
    
    class func type(data:ChatRow) -> Chat {
        if data.type == "text" && data.senderId != TotalChat.shared.userId {
            return .incominText
        }
        else if data.type == "text" && data.senderId == TotalChat.shared.userId {
            return .outgoingText
        }
        else if (data.type == "attachment" || data.type == "video" || data.type == "file") && data.senderId != TotalChat.shared.userId {
            return .incomingMedia
        }
        else if (data.type == "attachment" || data.type == "video" || data.type == "file") && data.senderId == TotalChat.shared.userId {
            return .outgoingMedia
        }
        return .none
    }
    
    class func timeFormate(str:String) -> String {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = df.date(from: str)
        let df1 = DateFormatter()
        df1.dateFormat = "hh:mm a"
        let str1 = df1.string(from: date!)
        return str1
    }
    class func sectionDateFormate(str:String) -> String {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        let date = df.date(from: str)
        let df1 = DateFormatter()
        df1.dateFormat = "MMM dd, yyyy"
        let str1 = df1.string(from: date!)
        return str1
    }
    
   class func isValidUrl(str:String) -> String {
        return str.replacingOccurrences(of: " ", with: "%20")
    }
    
    class func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
}



class ChatView: UIView {
    
    let tableView = UITableView()
    var items : [ChatModel] = []
    
    
    //MARK: Initializers
    public init() {
        super.init(frame: CGRect.zero)
        setupView()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setupView() {
        
        tableView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        items = TotalChat.shared.chats
        self.addSubview(tableView)
        
        tableView.register(IncomingText.nib, forCellReuseIdentifier: IncomingText.identifier)
        tableView.register(IncomingMedia.nib, forCellReuseIdentifier: IncomingMedia.identifier)
        tableView.register(OutGoingText.nib, forCellReuseIdentifier: OutGoingText.identifier)
        tableView.register(OutGoingMedia.nib, forCellReuseIdentifier: OutGoingMedia.identifier)
        
        if items.count > 0 {
            DispatchQueue.main.async {
                self.tableView.scrollToLastCall(animated: true)
            }
        }
        
    }
    
    func scrollToBottom()  {
        if items.count > 0 {
            DispatchQueue.main.async {
                self.tableView.scrollToLastCall(animated: true)
            }
        }
    }
   
    
    func heightForRow(data:ChatRow) -> CGFloat {
        let type = ChatType.type(data: data)
        switch type {
        case .incominText:
            return UITableViewAutomaticDimension
        case .incomingMedia:
            return 120
        case .outgoingText:
            return UITableViewAutomaticDimension
        case .outgoingMedia:
            return 120
        case .none:
            return 0
        }
    }
}





extension ChatView: UITableViewDataSource , UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return heightForRow(data: items[indexPath.section].chatRow[indexPath.row])
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        let headerLabel = UILabel(frame: CGRect(x: tableView.frame.size.width/2-65, y: 10, width:130, height: 20))
        headerLabel.font = UIFont.boldSystemFont(ofSize: 13)
        headerLabel.textColor = .white
        headerLabel.text = self.tableView(self.tableView, titleForHeaderInSection: section)
        headerLabel.textAlignment = .center
        headerLabel.layer.cornerRadius = 10
        headerLabel.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        headerLabel.clipsToBounds = true
        headerView.addSubview(headerLabel)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ChatType.sectionDateFormate(str: items[section].timestamp)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].chatRow.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let type = ChatType.type(data: items[indexPath.section].chatRow[indexPath.row])
        switch type {
        case .incominText:
            do {
                let cell = tableView.dequeueReusableCell(withIdentifier: IncomingText.identifier, for: indexPath) as! IncomingText
                cell.item = items[indexPath.section].chatRow[indexPath.row]
                return cell
            }
            
        case .outgoingText:
            do {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: OutGoingText.identifier, for: indexPath) as! OutGoingText
                cell.item = items[indexPath.section].chatRow[indexPath.row]
                return cell
            }
            
        case .outgoingMedia:
            do {
                let cell = tableView.dequeueReusableCell(withIdentifier: OutGoingMedia.identifier, for: indexPath) as! OutGoingMedia
                cell.item = items[indexPath.section].chatRow[indexPath.row]
                return cell
            }
        case .incomingMedia:
            do {
                let cell = tableView.dequeueReusableCell(withIdentifier: IncomingMedia.identifier, for: indexPath) as! IncomingMedia
                cell.item = items[indexPath.section].chatRow[indexPath.row]
                return cell
            }
        case .none:
             return UITableViewCell()
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let type = ChatType.type(data: items[indexPath.section].chatRow[indexPath.row])
        switch type {
        case .incomingMedia:
            getUrl(str: items[indexPath.section].chatRow[indexPath.row].text, of: type)
            break
        case .outgoingMedia:
            getUrl( str: items[indexPath.section].chatRow[indexPath.row].text, of: type)
        break
        default:
            break
        }
        
    }
    
    private func getUrl(str:String,of type:Chat){
        if type == .incomingMedia || type == .outgoingMedia {
            guard let url = URL(string: str) else {
                return //be safe
            }
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }

}

