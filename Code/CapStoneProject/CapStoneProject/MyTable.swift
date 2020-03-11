//
//  myTableView.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/3/5.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import Foundation
import UIKit

private let darkGray: UIColor = UIColor(red: 160/255, green: 160/255, blue: 160/255, alpha: 1)
private let gray: UIColor = UIColor(red: 210/255, green: 210/255, blue: 210/255, alpha: 1)
private let lightGray: UIColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)

public class MyTable {
    
    private var curView: UIStackView
    private var columnNum: Int?
    private var rowUnit: UIStackView?
    private var num_of_row = 1
    private var num_of_column = 1
    
    init(rootView: UIStackView) {
        curView = rootView
        curView.axis = .vertical
        curView.spacing = 2
        curView.distribution = .equalSpacing
    }
    
    func setColumn(num: Int) {
        columnNum = num
    }
    
    func add(_ text: String) {
        if num_of_column == 1 {
            rowUnit = UIStackView()
            rowUnit?.axis = .horizontal
            if num_of_row == 1 { rowUnit?.spacing = 0 }
            else { rowUnit?.spacing = 2 }
        }
        
        let textLabel = UILabel()
        textLabel.numberOfLines = 0
        textLabel.font = UIFont.systemFont(ofSize: 13)
        textLabel.text = text
        textLabel.textColor = .black
        if num_of_row == 1 {
            textLabel.backgroundColor =  darkGray
            textLabel.textColor = .white
        }
        else if num_of_row % 2 == 1 { textLabel.backgroundColor = gray }
        else { textLabel.backgroundColor = lightGray }
//        textLabel.frame.size = CGSize(width: 50, height: 50)
        textLabel.textAlignment = .center
        
        rowUnit?.addArrangedSubview(textLabel)
        
        num_of_column += 1
        
        if num_of_column > columnNum! {
            rowUnit?.frame = CGRect(x: 0, y: 0, width: curView.frame.size.width, height: 40	)
            curView.addArrangedSubview(rowUnit!)
            
//            let horizonialDivider = UIView(frame: .zero)
//            horizonialDivider.translatesAutoresizingMaskIntoConstraints = false
//            horizonialDivider.heightAnchor.constraint(equalToConstant: 2).isActive = true
//            horizonialDivider.backgroundColor = darkGray
//            rowUnit?.addArrangedSubview(horizonialDivider)
            
            num_of_row += 1
            num_of_column = 1
        }
    }
}
