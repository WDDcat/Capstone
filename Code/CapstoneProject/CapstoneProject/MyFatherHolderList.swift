//
//  MyFatherHolderList.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/4/27.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import UIKit

class MyFatherHolderList {
    
    private var curView: UIStackView
    
    init(rootView: UIStackView) {
        curView = rootView
        curView.spacing = 43
    }
    
    func add(_ text: String, _ rate: String, _ id: String) {
        let companyitem = UIView()
        
        let tagLabel = UILabel()
        tagLabel.frame = CGRect(x: 0, y: 0, width: 4.5, height: 35)
        tagLabel.backgroundColor = .systemRed
        companyitem.addSubview(tagLabel)
        
        let contentView = UIView()
        contentView.frame = CGRect(x: 4.5, y: 0, width: 200, height: 35)
        contentView.backgroundColor = .white
        
        let nameLabel = UILabel()
        nameLabel.frame = CGRect(x: 5, y: 0, width: 195, height: 20)
        nameLabel.text = text
        nameLabel.font = UIFont.systemFont(ofSize: 15)
        contentView.addSubview(nameLabel)
        
        let rateLabel = UILabel()
        rateLabel.frame = CGRect(x: 5, y: 20, width: 195, height: 15)
        rateLabel.text = rate
        rateLabel.font = UIFont.systemFont(ofSize: 12)
        rateLabel.textColor = .darkGray
        contentView.addSubview(rateLabel)
        
        companyitem.addSubview(contentView)
        curView.addArrangedSubview(companyitem)
    }
}
