//
//  OutGoingText.swift
//  RMessage
//
//  Created by Rajesh Gupta on 5/30/18.
//  Copyright © 2018 Rajesh Gupta. All rights reserved.
//

import UIKit

class OutGoingText: UITableViewCell {

    @IBOutlet weak var bubblewidth: NSLayoutConstraint!
    @IBOutlet weak var textLeading: NSLayoutConstraint!
    
    @IBOutlet weak var outgoingBubble: UIView!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var time: UILabel!
    
    
    var item: ChatRow? {
        didSet {
            guard let item = item else {
                return
            }
            messageLabel.text = item.text
            time.text = ChatType.timeFormate(str: item.timestamp) 
            avatar.sd_setImage(with: URL(string: ChatType.isValidUrl(str: item.sender_img ?? "")), placeholderImage: UIImage(named: "user"))
            
        }
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    static var identifier: String {
        return String(describing: self)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        avatar.layer.cornerRadius = avatar.bounds.height/2
        avatar.clipsToBounds = true
        
        avatar.backgroundColor = .gray
        
        outgoingBubble.layer.cornerRadius = 6.0
        //incominBubble.clipsToBounds = true
        avatar.backgroundColor = .gray
        
        outgoingBubble.layer.shadowColor = UIColor.lightGray.cgColor
        outgoingBubble.layer.shadowOpacity = 1
        outgoingBubble.layer.shadowOffset = CGSize.zero
        outgoingBubble.layer.shadowRadius = 4
        
        
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
