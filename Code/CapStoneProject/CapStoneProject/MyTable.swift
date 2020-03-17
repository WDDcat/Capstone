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
    private var tableHeight: CGFloat = 0
    private var rowMaxHeight: CGFloat = 0
    private var cellWidth: CGFloat = 0
    
    init(rootView: UIStackView) {
        curView = rootView
        curView.axis = .vertical
        curView.spacing = 2
        curView.distribution = .equalSpacing
        tableHeight = 0
        curView.frame.size.width = UIScreen.main.bounds.width - 16
    }
    
    func setColumn(num: Int) {
        columnNum = num
        cellWidth = (curView.frame.width + 2) / CGFloat(columnNum!) - 2
    }
    
    func add(_ text: String) {
        if num_of_column == 1 {
            rowUnit = UIStackView()
            rowUnit?.axis = .horizontal
            if num_of_row == 1 { rowUnit?.spacing = 0 }
            else { rowUnit?.spacing = 2 }
            rowMaxHeight = 0
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
        textLabel.textAlignment = .center
        
        let maxSize = CGSize(width: cellWidth, height: 9999)
        let realSize = textLabel.sizeThatFits(maxSize)
        if rowMaxHeight < realSize.height { rowMaxHeight = realSize.height }
        textLabel.frame.size = CGSize(width: realSize.width, height: realSize.height)
        
        rowUnit?.addArrangedSubview(textLabel)
        
        num_of_column += 1
        
        
        if num_of_column > columnNum! {
            rowUnit?.frame = CGRect(x: 0, y: 0, width: curView.frame.size.width, height: rowMaxHeight)
            curView.addArrangedSubview(rowUnit!)
            
            print("tableHeight = \(tableHeight) + \(rowMaxHeight)")
            tableHeight += rowMaxHeight + 2
            
            num_of_row += 1
            num_of_column = 1
        }
    }
    
    func getHeight() -> CGFloat {
        return tableHeight - 2
    }
}
