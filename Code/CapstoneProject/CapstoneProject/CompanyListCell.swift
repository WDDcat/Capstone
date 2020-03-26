//
//  CompanyItemCell.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/2/27.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import UIKit

class CompanyListCell: UITableViewCell {

    var mPresenter:CompanyCellModel?
    
    @IBOutlet var label_companyName: UILabel!
    @IBOutlet var label_address: UILabel!
    @IBOutlet var label_legalPerson: UILabel!
    @IBOutlet weak var btn_star: UIButton!
    var c_id:String = ""
    
    @IBAction func starOnClick(_ sender: UIButton) {
        if btn_star.image(for: .normal) == UIImage(systemName: "star") {
            mPresenter?.postAddCollect(c_id: c_id, name: label_companyName.text!, recordName: "ANDROID", button: btn_star)
        }
        else {
            mPresenter?.postCancelCollect(c_id: c_id, name: label_companyName.text!, recordName: "ANDROID", button: btn_star)
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
