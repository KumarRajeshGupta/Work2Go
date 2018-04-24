//
//  ChatDelegates.swift
//  Demo
//
//  Created by Rajesh Gupta on 4/7/18.
//  Copyright © 2018 Ram Vinay. All rights reserved.
//

import UIKit


extension ChatHistoryViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}
