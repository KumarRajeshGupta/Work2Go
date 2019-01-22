//
//  IncomingText.swift
//  RMessage
//
//  Created by Rajesh Gupta on 5/30/18.
//  Copyright © 2018 Rajesh Gupta. All rights reserved.
//

import UIKit

class IncomingText: UITableViewCell {

    @IBOutlet weak var arrowImg: UIImageView!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var incominBubble: UIView!
    @IBOutlet weak var time: UILabel!
    
    
    var item: ChatRow? {
        didSet {
            guard let item = item else {
                return
            }
            messageLabel.text = item.text
            avatar.sd_setImage(with: URL(string: ChatType.isValidUrl(str: item.sender_img ?? "")), placeholderImage: UIImage(named: "user"))
            time.text = ChatType.timeFormate(str: item.timestamp)   
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
        incominBubble.layer.cornerRadius = 6.0
        //incominBubble.clipsToBounds = true
        avatar.backgroundColor = .gray
        
        arrowImg.isHidden = true
//        arrowImg.image = arrowImg.image!.withRenderingMode(.alwaysTemplate)
//        arrowImg.tintColor = incominBubble.backgroundColor
        incominBubble.layer.shadowColor = UIColor.lightGray.cgColor
        incominBubble.layer.shadowOpacity = 1
        incominBubble.layer.shadowOffset = CGSize.zero
        incominBubble.layer.shadowRadius = 4
        

        // Initialization code
    }
    
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
