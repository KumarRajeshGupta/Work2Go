//
//  OutgoingCell.swift
//  Demo
//
//  Created by Rajesh Gupta on 4/7/18.
//  Copyright © 2018 Ram Vinay. All rights reserved.
//

import UIKit

class OutgoingCell: UITableViewCell {

    @IBOutlet weak var outgoingview: UIView!
    
    static let reuseID = "outgoingcell"
    
    
    @IBOutlet weak var dateTime: UILabel!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var txtLabel: PaddingLabel!
    
    
    func message(message: Messages) {
        
        txtLabel.text = message.message
        
        txtLabel.layer.cornerRadius = 6.0
        txtLabel.clipsToBounds = true
        
        profileImg.layer.cornerRadius = profileImg.frame.size.height/2
        profileImg.clipsToBounds = true
        
        profileImg.sd_setImage(with: URL(string: message.sender_image ?? ""), placeholderImage: UIImage(named: "placeholder"))
       
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd,yyyy hh:mm"
        
        let date: Date? = dateFormatterGet.date(from: message.time!)
        
        dateTime.text = dateFormatterPrint.string(from: date!)
    }
    
    
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
