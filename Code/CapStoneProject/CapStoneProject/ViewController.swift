//
//  ViewController.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/2/27.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import UIKit
import TableKit

class ViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView! {
        didSet {
            tableDirector = TableDirector(tableView: tableView)
        }
    }
    @IBOutlet var stack_productList: UIStackView!
    
    var tableDirector: TableDirector!
    
    override func viewDidLoad() {
        tableView.frame = CGRect(x: 0, y: 0, width: 500, height: 500)
        super.viewDidLoad()
        
        let row1 = TableRow<StringTableViewCell>(item: "1")
        
        tableDirector += row1
        tableDirector += row1
        tableDirector += row1
        tableDirector += row1
        tableDirector += row1
        
        for i in 0...3 {
            let name = UILabel()
            name.text = "num:\(i)"
            name.backgroundColor = .cyan
            name.textColor = .darkGray
            name.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width - 16, height: 21)
            stack_productList.addArrangedSubview(name)
        }
    }
}

