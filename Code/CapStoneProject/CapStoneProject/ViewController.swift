//
//  ViewController.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/2/27.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import UIKit

let testList:[String] = ["债券名称", "起始日期", "期限（日）", "价格（%）", "金额（亿元）", "19凤凰机场CP001", "20190321", "11", "7.30", "10.00", "18海航Y5", "20181125", "36", "7.30", "14.00", "18海航Y4", "20181101", "36", "7.35", "8.00", "18海航Y3", "20181017", "36", "7.45", "15.00", "18海航Y2", "20180925", "36", "7.60", "5.00", "18海航Y1", "20180912", "36", "7.60", "5.00", "17凤凰MTN002", "20171219", "36", "8.00", "5.00"]
class ViewController: UIViewController {
    
    @IBOutlet var stack_productList: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mt = MyTable(rootView: stack_productList)
        
        mt.setColumn(num: 5)
//        mt.setWeight(weight: []	)
        
        for i in 0..<testList.count {
            mt.add(testList[i])
        }
        
//        for _ in 0..<10 {
//            mt.add(text: "我爱你我爱你我爱你")
//        }
    }
}

//realName: String, nickName: String, institution: String, department: String, position: String, responsibility: String, phoneNumber: String, email: String, avator: String, card: String
