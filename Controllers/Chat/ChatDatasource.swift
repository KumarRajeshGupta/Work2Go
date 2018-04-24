//
//  ChatDatasource.swift
//  Demo
//
//  Created by Rajesh Gupta on 4/7/18.
//  Copyright © 2018 Ram Vinay. All rights reserved.
//

import UIKit


class PaddingLabel: UILabel {
    
    @IBInspectable var topInset: CGFloat = 5.0
    @IBInspectable var bottomInset: CGFloat = 5.0
    @IBInspectable var leftInset: CGFloat = 5.0
    @IBInspectable var rightInset: CGFloat = 5.0
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
    
    override var intrinsicContentSize: CGSize {
        get {
            var contentSize = super.intrinsicContentSize
            contentSize.height += topInset + bottomInset
            contentSize.width += leftInset + rightInset
            return contentSize
        }
    }
}



extension ChatHistoryViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if self.messages[indexPath.row].sender_id == userID {

            let cell2 = self.tableview.dequeueReusableCell(withIdentifier: OutgoingCell.reuseID, for: indexPath) as! OutgoingCell
            
            cell2.message(message: self.messages[indexPath.row])

            return cell2
        }
        else{
            let cell1 = self.tableview.dequeueReusableCell(withIdentifier: IncomingCell.reuseID, for: indexPath) as! IncomingCell
            
            cell1.message(message: self.messages[indexPath.row])
            return cell1
        }
    }
    
    
    
}
