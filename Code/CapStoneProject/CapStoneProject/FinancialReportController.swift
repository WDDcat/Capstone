//
//  FinancialReportController.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/3/1.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import UIKit

class FinancialReportController: UIViewController {

    var mPresenter = FinancialReportModel()
    
    @IBOutlet weak var scrollView: UIScrollView!
    // MARK: -标题栏
    @IBOutlet weak var label_companyNameTitle: UILabel!
    @IBOutlet weak var stack_tags: UIStackView!
    @IBOutlet weak var tag_bond: UILabel!
    @IBOutlet weak var tag_gov: UILabel!
    @IBOutlet weak var tag_listed: UILabel!
    @IBOutlet weak var tag_loc: UILabel!
    @IBOutlet weak var tag_stateOwned: UILabel!
    //MARK: -公司基本情况
    @IBOutlet weak var label_companyName: UILabel!
    @IBOutlet weak var label_groupName: UILabel!
    @IBOutlet weak var label_legalPerson: UILabel!
    //MARK: -股东信息
    @IBOutlet weak var label_stockHolder: UILabel!
    @IBOutlet weak var label_stockHolderPercent: UILabel!
    //MARK: -历史沿革
    @IBOutlet weak var label_history: UILabel!
    //MARK: -高管信息
    @IBOutlet weak var label_managers: UILabel!
    //MARK: -生产经营情况
    @IBOutlet weak var label_businessInfo: UILabel!
    @IBOutlet var stack_productList: UIStackView!
    @IBOutlet var stack_locationList: UIStackView!
    //MARK: -财务情况
    @IBOutlet weak var label_financingInfo: UILabel!
    //MARK: -融资情况
    @IBOutlet weak var label_rasingInfo: UILabel!
    
    var defaultBackgroundImage: UIImage?
    var defaultShadowImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mPresenter.mView = self
        stack_tags.alpha = 0
        self.setCompanyName(name: remoteGetCompanyName())
        mPresenter.getInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.isTranslucent = true
    }
}

extension FinancialReportController: FinancialReportView {
    // MARK: -标题栏
    func setCompanyName(name: String) {
        label_companyNameTitle.text = name
        label_companyName.text = name
        label_companyName.backgroundColor = .systemBackground
    }
    
    func setTags(tags: [String]) {
        if tags[0] != "1" { tag_bond.removeFromSuperview() }
        if tags[1] != "1" { tag_gov.removeFromSuperview() }
        if tags[2] != "1" { tag_listed.removeFromSuperview() }
        if tags[3] != "1" { tag_loc.removeFromSuperview() }
        if tags[4] != "1" { tag_stateOwned.removeFromSuperview() }
        stack_tags.alpha = 1
    }
    //MARK: -公司基本情况
    func setgroupName(name: String) {
        label_groupName.text = name
        label_groupName.backgroundColor = .systemBackground
    }
    
    func setLegalPerson(name: String) {
        label_legalPerson.text = name
        label_legalPerson.backgroundColor = .systemBackground
    }
    //MARK: -股东信息
    func setShareHolder(company: String, percent: Float) {
        label_stockHolder.text = company
        label_stockHolder.backgroundColor = .systemBackground
        if percent == -1 { label_stockHolderPercent.text = "-" }
        else { label_stockHolderPercent.text = "\(percent)%" }
        
        label_stockHolderPercent.backgroundColor = .systemBackground
    }
    //MARK: -历史沿革
    func setHistory(paragraph: String) {
        if paragraph != "暂无数据" {
            label_history.text = "成立于\(paragraph)"
        }
        else {
            label_history.text = paragraph
        }
        label_history.backgroundColor = .systemBackground
    }
    //MARK: -高管信息
    func setManager(names: String) {
        label_managers.text = names
        label_managers.backgroundColor = .systemBackground
    }
    //MARK: -生产经营情况
    func setBusinessInfo(paragraph: String) {
        label_businessInfo.text = paragraph
        label_businessInfo.backgroundColor = .systemBackground
    }
    
    func setProductList(productList: [[String]] ) {
        if productList.count > 0{
            let title = UILabel()
            title.text = "根据产品划分的前三年生产经营情况"
            title.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width - 16, height: 21)
            title.backgroundColor = .gray
            title.textColor = .white
            stack_productList.addArrangedSubview(title)
            
            for i in 0...(productList.count - 1) {
                let name = UILabel()
                name.text = productList[i][0]
                name.backgroundColor = .lightGray
                name.textColor = .darkGray
                stack_productList.addArrangedSubview(name)
            }
        }
        else {
            
        }
    }
    
    func setLocationList(locationList: [[String]]) {
        
    }
    //MARK: -财务情况
    func setFinancingInfo(paragraph: String) {
        label_financingInfo.text = paragraph
        label_financingInfo.backgroundColor = .systemBackground
    }
    //MARK: -融资情况
    func setRaisingInfo(paragraph: String) {
        label_rasingInfo.text = paragraph
        label_rasingInfo.backgroundColor = .systemBackground
    }
}
