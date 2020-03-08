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

class ProductionManagementController: UIViewController {

    var mPresenter = ProductionManagementDetailModel()
    
    @IBOutlet weak var baseScrollView: UIScrollView!
    @IBOutlet weak var label_productionManagementInfo: UILabel!
    @IBOutlet weak var stack_productTable: UIStackView!
    @IBOutlet weak var view_productContent: UIView!
    @IBOutlet weak var stack_areaTable: UIStackView!
    @IBOutlet weak var view_areaContent: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mPresenter.mView = self
        
        mPresenter.getInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        (stack_productTable.superview as! UIScrollView).contentSize = CGSize(width: stack_productTable.frame.size.width + 20, height: stack_productTable.frame.size.height)
        (stack_areaTable.superview as! UIScrollView).contentSize = CGSize(width: stack_areaTable.frame.size.width + 20, height: stack_areaTable.frame.size.height)
    }

}

extension ProductionManagementController: ProductionManagementDetailView {
    func setBusinessInfo(businessInfo: String) {
        label_productionManagementInfo.text = businessInfo
        label_productionManagementInfo.backgroundColor = .systemBackground
//        label_productionManagementInfo.layer.masksToBounds = true
//        label_productionManagementInfo.layer.cornerRadius = 5
    }
    
    func setProductTable() {
        let mst = MyScrollTable(rootView: stack_productTable)
        for i in 0..<productionManagementProductList.count {
            mst.add(unitFormat(productionManagementProductList[i]))
        }
        mst.finish(content: view_productContent)
        viewWillAppear(true)
    }
    
    func setAreaTable() {
        let mst = MyScrollTable(rootView: stack_areaTable)
        for i in 0..<productionManagementAreaList.count {
            mst.add(unitFormat(productionManagementAreaList[i]))
        }
        mst.finish(content: view_areaContent)
        viewWillAppear(true)
    }
}
