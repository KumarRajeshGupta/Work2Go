//
//  AppliedEmployeeTableViewCell.swift
//  Work2go
//
//  Created by Rajesh Gupta on 5/19/18.
//  Copyright © 2018 Rajesh Gupta. All rights reserved.
//

import UIKit

class AppliedEmployeeTableViewCell: UITableViewCell {

    static let reuseId = "appliedEmployeeCell"
    
    
    @IBOutlet weak var contentview: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneNo: UILabel!
    
    public var contents : EmployeeModel?{
        didSet{
           configureCell()
        }
    }
    
    
    func configureCell() {
        guard let data = contents else {
            return
        }
        
        self.nameLabel.text = data.Name
        self.emailLabel.text = data.email
        self.phoneNo.text = data.phone
        
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
