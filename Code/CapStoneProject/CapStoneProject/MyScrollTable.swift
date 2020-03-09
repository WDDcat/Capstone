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
private let lightGray: UIColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)

class MyScrollTable {
    
    private var rootView: UIScrollView
    private var curView: UIStackView
    private var rowNum: Int
    private var columnUnit: UIStackView?
    private var num_of_row = 1
    private var num_of_column = 1
        
    init(rootView: UIScrollView) {
        self.rootView = rootView
        curView = UIStackView()
        curView.axis = .horizontal
        curView.spacing = 2
        curView.distribution = .fillEqually
        rowNum = 10
        num_of_row = 1
        num_of_column = 1
    }
    
    func add(_ text: String) {
        if num_of_row == 1 {
            columnUnit = UIStackView()
            columnUnit?.axis = .vertical
            columnUnit?.spacing = 2
            columnUnit?.distribution = .fillEqually
        }
            
        let textLabel = UILabel()
        textLabel.numberOfLines = 0
        textLabel.font = UIFont.systemFont(ofSize: 13)
        textLabel.text = text
        textLabel.textColor = .black
        if num_of_column % 2 == 1 { textLabel.backgroundColor = gray }
        else { textLabel.backgroundColor = lightGray }
        textLabel.frame.size = CGSize(width: 40, height: 40)
        textLabel.textAlignment = .center
            
        columnUnit?.addArrangedSubview(textLabel)
            
        num_of_row += 1
        
        if num_of_row > rowNum {
            curView.addArrangedSubview(columnUnit!)
            num_of_column += 1
            num_of_row = 1
        }
    }
    
    func finish(content: UIView) {
        curView.frame.size = CGSize(width: num_of_column*100+(num_of_column-1)*2, height: rowNum*40+(rowNum-1)*2)
        rootView.addSubview(curView)
        (curView.superview as! UIScrollView).contentSize = curView.frame.size
    }
}
