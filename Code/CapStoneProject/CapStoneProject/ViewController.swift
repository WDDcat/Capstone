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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

//        Alamofire.request(URL(string :"http://47.92.50.218:8881/api1/search_company")!, parameters: param, headers: header)
//            .responseJSON { response in
//            let data = response.data
//            let json = JSON(data!)
//            print(json)
//        }
    }
}

