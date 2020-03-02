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
    @IBOutlet weak var table_productList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mPresenter.mView = self
        stack_tags.alpha = 0
        //scrollView.contentSize = CGSize(width: 375, height: 1050)
        self.setCompanyName(name: remoteGetCompanyName())
        mPresenter.getInfo()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        //self.navigationController?.navigationBar.tintColor = .white
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension FinancialReportController: FinancialReportView {
    // MARK: -标题栏
    func setCompanyName(name: String) {
        label_companyNameTitle.text = name
        label_companyName.text = name
        label_companyName.backgroundColor = .white
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
        label_groupName.backgroundColor = .white
    }
    
    func setLegalPerson(name: String) {
        label_legalPerson.text = name
        label_legalPerson.backgroundColor = .white
    }
    //MARK: -股东信息
    func setShareHolder(company: String, percent: Float) {
        label_stockHolder.text = company
        label_stockHolder.backgroundColor = .white
        if percent == -1 { label_stockHolderPercent.text = "-" }
        else { label_stockHolderPercent.text = "\(percent)%" }
        
        label_stockHolderPercent.backgroundColor = .white
    }
    //MARK: -历史沿革
    func setHistory(paragraph: String) {
        if paragraph != "暂无数据" {
            label_history.text = "成立于\(paragraph)"
        }
        else {
            label_history.text = paragraph
        }
        label_history.backgroundColor = .white
    }
    //MARK: -高管信息
    func setManager(names: String) {
        label_managers.text = names
        label_managers.backgroundColor = .white
    }
    //MARK: -生产经营情况
    func setBusinessInfo(paragraph: String) {
        label_businessInfo.text = paragraph
        label_businessInfo.backgroundColor = .white
    }
    
    func setProductList(productList: [[String : String]]) {
        let text = UILabel()
        text.text = "产品"
        text.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 40)
        table_productList.tableHeaderView = text
    }
}
