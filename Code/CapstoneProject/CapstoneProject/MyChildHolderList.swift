//
//  MyChildHolderList.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/4/27.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import UIKit

class MyChildHolderList {
    
    private var curView: UIStackView
    
    init(rootView: UIStackView) {
        curView = rootView
        curView.spacing = 42
    }
    
    func add(_ text: String, _ rate: String, _ id: String) {
        let companyitem = UIView()
        companyitem.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 30, height: 42)
        
        let line1 = UILabel()
        line1.frame = CGRect(x: 0, y: 0, width: 2, height: 42)
        line1.backgroundColor = .systemRed
        companyitem.addSubview(line1)
        
        let line2 = UILabel()
        line2.frame = CGRect(x: 2, y: 16, width: 15, height: 2)
        line2.backgroundColor = .systemRed
        companyitem.addSubview(line2)
        
        let tagLabel = UILabel()
        tagLabel.frame = CGRect(x: 17, y: 0, width: 4.5, height: 35)
        tagLabel.backgroundColor = .systemRed
        companyitem.addSubview(tagLabel)
        
        let contentView = UIView()
        contentView.frame = CGRect(x: 21.5, y: 0, width: UIScreen.main.bounds.width - 51.5, height: 35)
        contentView.backgroundColor = .white
        
        let nameLabel = UILabel()
        nameLabel.frame = CGRect(x: 5, y: 0, width: UIScreen.main.bounds.width - 51.5, height: 20)
        nameLabel.text = text
        nameLabel.font = UIFont.systemFont(ofSize: 15)
        contentView.addSubview(nameLabel)
        
        let rateLabel = UILabel()
        rateLabel.frame = CGRect(x: 5, y: 20, width: UIScreen.main.bounds.width - 51.5, height: 15)
        rateLabel.text = rate
        rateLabel.font = UIFont.systemFont(ofSize: 13)
        rateLabel.textColor = .darkGray
        contentView.addSubview(rateLabel)
        
        companyitem.addSubview(contentView)
        curView.addArrangedSubview(companyitem)
    }
    
    func addLast(_ text: String, _ rate: String, _ id: String) {
        let companyitem = UIView()
        companyitem.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 30, height: 42)
        
        let line1 = UILabel()
        line1.frame = CGRect(x: 0, y: 0, width: 2, height: 18)
        line1.backgroundColor = .systemRed
        companyitem.addSubview(line1)
        
        let line2 = UILabel()
        line2.frame = CGRect(x: 2, y: 16, width: 15, height: 2)
        line2.backgroundColor = .systemRed
        companyitem.addSubview(line2)
        
        let tagLabel = UILabel()
        tagLabel.frame = CGRect(x: 17, y: 0, width: 4.5, height: 35)
        tagLabel.backgroundColor = .systemRed
        companyitem.addSubview(tagLabel)
        
        let contentView = UIView()
        contentView.frame = CGRect(x: 21.5, y: 0, width: UIScreen.main.bounds.width - 51.5, height: 35)
        contentView.backgroundColor = .white
        
        let nameLabel = UILabel()
        nameLabel.frame = CGRect(x: 5, y: 0, width: UIScreen.main.bounds.width - 51.5, height: 20)
        nameLabel.text = text
        nameLabel.font = UIFont.systemFont(ofSize: 15)
        contentView.addSubview(nameLabel)
        
        let rateLabel = UILabel()
        rateLabel.frame = CGRect(x: 5, y: 20, width: UIScreen.main.bounds.width - 51.5, height: 15)
        rateLabel.text = rate
        rateLabel.font = UIFont.systemFont(ofSize: 13)
        rateLabel.textColor = .darkGray
        contentView.addSubview(rateLabel)
        
        companyitem.addSubview(contentView)
        curView.addArrangedSubview(companyitem)
    }
}
