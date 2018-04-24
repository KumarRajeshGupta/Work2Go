//
//  IncomingCell.swift
//  Demo
//
//  Created by Rajesh Gupta on 4/7/18.
//  Copyright © 2018 Ram Vinay. All rights reserved.
//

import UIKit

class IncomingCell: UITableViewCell {

    
    static let reuseID = "incomingcell"
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var dateandTime: UILabel!
        @IBOutlet weak var incomingBg: UIImageView!
    @IBOutlet weak var incomingView: UIView!
    
    @IBOutlet weak var txtlabel: PaddingLabel!
    
    func message(message: Messages) {
        
        
        txtlabel.text = message.message
        
        txtlabel.layer.cornerRadius = 6.0
        txtlabel.clipsToBounds = true
        
        profileImg.layer.cornerRadius = profileImg.frame.size.height/2
        profileImg.clipsToBounds = true
        
        profileImg.sd_setImage(with: URL(string: message.sender_image ?? ""), placeholderImage: UIImage(named: "placeholder"))
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd,yyyy hh:mm"
        
        let date: Date? = dateFormatterGet.date(from: message.time!)
        
        dateandTime.text = dateFormatterPrint.string(from: date!)
        
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


extension String {
    
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedStringKey.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
    
    func heightOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedStringKey.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.height
    }
}

