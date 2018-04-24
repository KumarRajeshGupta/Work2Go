//
//  MyClassifiedJobTableViewCell.swift
//  Work2go
//
//  Created by Rajesh Gupta on 4/2/18.
//  Copyright © 2018 Rajesh Gupta. All rights reserved.
//

import UIKit

class MyClassifiedJobTableViewCell: UITableViewCell {

    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var location: UILabel!
    
    
    var contents : ClassifiedModel?{
        didSet{
            configureCell()
        }
    }
    
    func configureCell() {
        guard let content = contents else {
            return
        }
        
        self.name.text = content.name ?? ""
        self.companyName.text = content.company_name ?? ""
        self.location.text = "\(content.city ?? ""), \(content.country ?? "")"
        
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
