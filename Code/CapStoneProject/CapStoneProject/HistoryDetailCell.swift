//
//  HistoryDetailCell.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/3/3.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import UIKit

class HistoryDetailCell: UITableViewCell {

    @IBOutlet weak var label_changeDate: UILabel!
    @IBOutlet weak var label_changeType: UILabel!
    @IBOutlet weak var label_beforeChange: UILabel!
    @IBOutlet weak var label_afterChange: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
