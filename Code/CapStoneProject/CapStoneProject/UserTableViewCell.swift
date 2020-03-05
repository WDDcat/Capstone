//
//  UserTableViewCell.swift
//  
//
//  Created by Shiyu Wang on 2020/3/5.
//

import UIKit
import TableKit

class StringTableViewCell: UITableViewCell, ConfigurableCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
     func configure(with string: String) {
           textLabel?.text = string
       }
}
