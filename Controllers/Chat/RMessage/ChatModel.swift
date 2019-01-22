//
//  ChatModel.swift
//  RMessage
//
//  Created by Rajesh Gupta on 5/30/18.
//  Copyright © 2018 Rajesh Gupta. All rights reserved.
//

import UIKit


struct ChatModel {

    var timestamp : String
    var chatRow : [ChatRow] = []

}
struct ChatRow {
    var type : String
    var id : String
    var text : String
    var sender_img : String?
    var senderId : String
    var timestamp : String
}




