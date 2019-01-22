//
//  ChatTableViewCell.swift
//  Work2go
//
//  Created by Rajesh Gupta on 3/30/18.
//  Copyright © 2018 Rajesh Gupta. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {

    @IBOutlet weak var userImg: UIImageView!
    
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var messageTitle: UILabel!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var contentview: UIView!
    
    public var listContent: chatModel? {
        didSet{
            configureCell()
        }
    }
    
    private func configureCell(){
        guard let data = listContent else { return }
        
        self.contentview.backgroundColor = .white
        
        self.companyName.text = data.receiver_name
        self.messageTitle.text = data.job_title
        self.message.text = data.message
        self.userImg.sd_setImage(with: URL(string: data.sender_image ?? ""), placeholderImage: UIImage(named: "placeholder"))
        
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd,yyyy hh:mm"
        
        let datee: Date? = dateFormatterGet.date(from: data.time!)
        
        date.text = dateFormatterPrint.string(from: datee!)
      
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
