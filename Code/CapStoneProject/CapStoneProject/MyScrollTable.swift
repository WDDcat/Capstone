//
//  MyScrollTable.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/3/7.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import Foundation
import UIKit

private let gray: UIColor = UIColor(red: 210/255, green: 210/255, blue: 210/255, alpha: 1)
private let grayCG: CGColor = CGColor.init(srgbRed: 210/255, green: 210/255, blue: 210/255, alpha: 1)
private let lightGray: UIColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)

private let productionRowNum = 10
private let trustRowNum = 13
private let insuranceRowNum = 4
private let securityRowNum = 4

enum ScrollTableType {
    case production
    case trust
    case insurance
    case security
}

class MyScrollTable {
    
    private var rootView: UIScrollView
    private var curView: UIStackView
    private var rowNum: Int
    private var columnUnit: UIStackView?
    private var num_of_row = 1
    private var num_of_column = 1
    private var tableType: ScrollTableType?
    private var cellWidth: CGFloat?
    private var cellHeight: CGFloat?
        
    init(rootView: UIScrollView, type: ScrollTableType) {
        self.rootView = rootView
        curView = UIStackView()
        curView.axis = .horizontal
        curView.spacing = 2
        curView.distribution = .fillEqually
        num_of_row = 1
        num_of_column = 1
        tableType = type
        
        switch tableType {
        case .production:
            rowNum = productionRowNum
            cellWidth = 100
            cellHeight = 40
        case .trust:
            rowNum = trustRowNum
            cellWidth = 200
            cellHeight = 80
        case .insurance:
            rowNum = insuranceRowNum
            cellWidth = 100
            cellHeight = 60
        case .security:
            rowNum = securityRowNum
            cellWidth = 100
            cellHeight = 60
        default:
            rowNum = 0
        }
    }
    
    func add(_ text: String) {
        if num_of_row == 1 {
            columnUnit = UIStackView()
            columnUnit?.axis = .vertical
            columnUnit?.spacing = 2
            columnUnit?.distribution = .fillEqually
            if num_of_column % 2 == 1 { columnUnit?.backgroundColor = gray }
            else { columnUnit?.backgroundColor = lightGray }
        }
        
        let textLabel = UILabel()
        textLabel.numberOfLines = 0
        textLabel.font = UIFont.systemFont(ofSize: 13)
        textLabel.text = text
        textLabel.textColor = .black
        if num_of_column % 2 == 1 { textLabel.backgroundColor = gray }
        else { textLabel.backgroundColor = lightGray }
        textLabel.textAlignment = .center
        
        if tableType == ScrollTableType.trust {
            let labelMaxSize = CGSize(width: cellWidth!, height: 9999)
            let realSize = textLabel.sizeThatFits(labelMaxSize)
            if realSize.height < cellHeight! {
                columnUnit?.addArrangedSubview(textLabel)
            }
            else {
                let scroll = UIScrollView()
                scroll.showsVerticalScrollIndicator = true
                scroll.showsHorizontalScrollIndicator = false
                scroll.bounces = false
                scroll.layer.borderColor = grayCG
                
                textLabel.frame = CGRect(x: 0, y: 0, width: realSize.width, height: realSize.height)
                scroll.contentSize = CGSize(width: textLabel.frame.width, height: textLabel.frame.height)
                scroll.addSubview(textLabel)
                
                columnUnit?.addArrangedSubview(scroll)
            }
        }
        else {
            columnUnit?.addArrangedSubview(textLabel)
        }
        
        num_of_row += 1
        
        if num_of_row > rowNum {
            curView.addArrangedSubview(columnUnit!)
            num_of_column += 1
            num_of_row = 1
        }
    }
    
    func finish() {
        var width = CGFloat(num_of_column) * cellWidth! + (CGFloat(num_of_column - 1) * 2)
        if width < rootView.frame.size.width { width = rootView.frame.size.width }
        let height = CGFloat(rowNum) * cellHeight! + CGFloat((rowNum - 1) * 2)
        curView.frame.size = CGSize(width: width, height: height)
        rootView.addSubview(curView)
        rootView.contentSize = curView.frame.size
    }
}
