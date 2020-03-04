//
//  ManagerInfoCell.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/3/4.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import UIKit

class ManagerInfoDetailCell: UITableViewCell {

    @IBOutlet weak var label_managerName: UILabel!
    @IBOutlet weak var label_position: UILabel!
    @IBOutlet weak var label_introductionInfo: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
