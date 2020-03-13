//
//  ProductionManagementController.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/3/6.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import UIKit

var productionManagementProductList: [String] = []
var productionManagementAreaList: [String] = []

class ProductionManagementDetailController: UIViewController {

    var mPresenter = ProductionManagementDetailModel()
    
    @IBOutlet weak var baseScrollView: UIScrollView!
    @IBOutlet weak var label_productionManagementInfo: UILabel!
    @IBOutlet weak var scroll_productTable: UIScrollView!
    @IBOutlet weak var scroll_areaTable: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mPresenter.mView = self
        mPresenter.getInfo()
    }
}

extension ProductionManagementDetailController: ProductionManagementDetailView {
    func setBusinessInfo(businessInfo: String) {
        label_productionManagementInfo.text = businessInfo
        label_productionManagementInfo.backgroundColor = .systemBackground
//        label_productionManagementInfo.layer.masksToBounds = true
//        label_productionManagementInfo.layer.cornerRadius = 5
    }
    
    func setProductTable() {
        let mst = MyScrollTable(rootView: scroll_productTable, type: .production)
        for i in 0..<productionManagementProductList.count {
            mst.add(unitFormat(productionManagementProductList[i]))
        }
        mst.finish()
    }
    
    func setAreaTable() {
        let mst = MyScrollTable(rootView: scroll_areaTable, type: .production)
        for i in 0..<productionManagementAreaList.count {
            mst.add(unitFormat(productionManagementAreaList[i]))
        }
        mst.finish()
    }
}
