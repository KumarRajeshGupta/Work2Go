//
//  HomeTableViewCell.swift
//  Work2go
//
//  Created by Rajesh Gupta on 3/28/18.
//  Copyright © 2018 Rajesh Gupta. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    
    @IBOutlet weak var contentview: UIView!
    @IBOutlet weak var postednmae: UILabel!
    @IBOutlet weak var companyname: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var favBtn: UIButton!
    
    
    public var listContent: jobListModel? {
        didSet{
            configureCell()
        }
    }
    
    private func configureCell(){
        guard let data = listContent else { return }
        
        self.backgroundColor = .clear
        
        self.postednmae.text = data.name
        self.companyname.text = data.company_name
        self.address.text = "\(data.city ?? ""), \(data.country ?? "")"
        
        favBtn.setImage(UIImage(named: "fav-grey"), for: .normal)
        if data.wish == "1" {
            favBtn.setImage(UIImage(named: "fav-red"), for: .normal)
        }
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
