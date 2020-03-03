//
//  ViewController.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/2/27.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

let GETURL = "http://47.92.50.218:8881/api1/condition_search_company?keyword=A"
let header:HTTPHeaders = ["token-id":"a7b2668646dc11e9983300163e02e9cd"]

class ViewController: UIViewController {

    @IBOutlet var stackView: UIStackView!
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let view = UILabel()
//        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width - 16, height: 21)
//        view.backgroundColor = UIColor(red: 0.86, green: 0.86, blue: 0.86, alpha: 1)
//        view.text = "123"
//
//        stackView.addArrangedSubview(view)
//
//        let view1 = UILabel()
//        view1.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width - 16, height: 21)
//        view1.backgroundColor = UIColor(red: 0.86, green: 0.86, blue: 0.86, alpha: 1)
//        view1.text = "123"
//
//        stackView.addArrangedSubview(view1)
        
//        tableView.number
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = tableView.cellForRow(at: indexPath)
        
        
        
    }
}

