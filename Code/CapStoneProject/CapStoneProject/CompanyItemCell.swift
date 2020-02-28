//
//  CompanyItemCell.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/2/27.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import UIKit

class CompanyItemCell: UITableViewCell {

    @IBOutlet var label_companyName: UILabel!
    @IBOutlet var label_address: UILabel!
    @IBOutlet var label_legalPerson: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
