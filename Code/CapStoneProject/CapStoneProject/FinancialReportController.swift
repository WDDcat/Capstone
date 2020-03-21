//
//  FinancialReportController.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/3/1.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import UIKit

var financialReportProductList: [[String]] = []
var financialReportLocationList: [[String]] = []

class FinancialReportController: UIViewController {

    var mPresenter = FinancialReportModel()
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
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
    @IBOutlet weak var stack_productList: UIStackView!
    @IBOutlet weak var stack_locationList: UIStackView!
    //MARK: -财务情况
    @IBOutlet weak var tag_financingInfo: UILabel!
    @IBOutlet weak var label_financingInfo: UILabel!
    //MARK: -融资情况
    @IBOutlet weak var label_rasingInfo: UILabel!
    //MARK: -PDF
    @IBOutlet weak var btn_PDFCreate: UIButton!
    @IBOutlet weak var btn_detailBusiness: UIButton!
    @IBOutlet weak var btn_detailFinancial: UIButton!
    
    
    var defaultBackgroundImage: UIImage?
    var defaultShadowImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mPresenter.mView = self
        stack_tags.alpha = 0
        self.setCompanyName(name: remoteGetCompanyName())
        mPresenter.getInfo()
        view.isUserInteractionEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = .lightGray
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = .systemRed
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
        else {
            tag_bond.layer.masksToBounds = true
            tag_bond.layer.cornerRadius = 3
        }
        if tags[1] != "1" { tag_gov.removeFromSuperview() }
        else {
            tag_gov.layer.masksToBounds = true
            tag_gov.layer.cornerRadius = 3
        }
        if tags[2] != "1" { tag_listed.removeFromSuperview() }
        else {
            tag_listed.layer.masksToBounds = true
            tag_listed.layer.cornerRadius = 3
        }
        if tags[3] != "1" { tag_loc.removeFromSuperview() }
        else {
            tag_loc.layer.masksToBounds = true
            tag_loc.layer.cornerRadius = 3
        }
        if tags[4] != "1" { tag_stateOwned.removeFromSuperview() }
        else {
            tag_stateOwned.layer.masksToBounds = true
            tag_stateOwned.layer.cornerRadius = 3
        }
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
    func setShareHolder(company: String, percent: String) {
        label_stockHolder.text = company
        label_stockHolder.backgroundColor = .systemBackground
        label_stockHolderPercent.text = "\(percent)%"
        
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
    
    func setProductList() {
        if financialReportProductList.count > 0 {
            stack_productList.superview!.addConstraint(NSLayoutConstraint(item: stack_productList, attribute: .top, relatedBy: .equal, toItem: label_businessInfo, attribute: .bottom, multiplier: 1.0, constant: 20))
            
            let title = UILabel()
            title.text = "根据产品划分的前三年生产经营情况"
            title.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width - 16, height: 21)
            title.backgroundColor = .gray
            title.textColor = .white
            stack_productList.addArrangedSubview(title)
            
            for i in 0...(financialReportProductList.count - 1) {
                let stack = UIStackView()
                stack.axis = .horizontal
                
                let name = UILabel()
                name.text = "\(financialReportProductList[i][0])"
                name.backgroundColor = UIColor(red: 0.86, green: 0.86, blue: 0.86, alpha: 1)
                name.textColor = .darkGray
                
                let rate = UILabel()
                rate.text = "\(financialReportProductList[i][1])"
                rate.backgroundColor = UIColor(red: 0.86, green: 0.86, blue: 0.86, alpha: 1)
                rate.textColor = .darkGray
                
                stack.addArrangedSubview(name)
                stack.addArrangedSubview(rate)
                stack.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width - 16, height: 21)
                stack_productList.addArrangedSubview(stack)
            }
        }
        else {
            stack_productList.superview!.addConstraint(NSLayoutConstraint(item: stack_locationList, attribute: .top, relatedBy: .equal, toItem: label_businessInfo, attribute: .bottom, multiplier: 1.0, constant: 20))
        }
    }
    
    func setLocationList() {
        if financialReportLocationList.count > 0{
            stack_locationList.superview!.addConstraint(NSLayoutConstraint(item: stack_locationList, attribute: .top, relatedBy: .equal, toItem: stack_productList, attribute: .bottom, multiplier: 1.0, constant: 20))
            
            let title = UILabel()
            title.text = "根据其他地区划分的前三年生产经营情况"
            title.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width - 16, height: 21)
            title.backgroundColor = .gray
            title.textColor = .white
            stack_locationList.addArrangedSubview(title)
            
            for i in 0...(financialReportLocationList.count - 1) {
                let stack = UIStackView()
                stack.axis = .horizontal
                
                let name = UILabel()
                name.text = "\(financialReportLocationList[i][0])"
                name.backgroundColor = UIColor(red: 0.86, green: 0.86, blue: 0.86, alpha: 1)
                name.textColor = .darkGray
                
                let rate = UILabel()
                rate.text = "\(financialReportLocationList[i][1])"
                rate.backgroundColor = UIColor(red: 0.86, green: 0.86, blue: 0.86, alpha: 1)
                rate.textColor = .darkGray
                
                stack.addArrangedSubview(name)
                stack.addArrangedSubview(rate)
                stack_locationList.addArrangedSubview(stack)
            }
        }
        else {
            if financialReportProductList.count > 0 {
                stack_locationList.superview!.addConstraint(NSLayoutConstraint(item: tag_financingInfo, attribute: .top, relatedBy: .equal, toItem: stack_productList, attribute: .bottom, multiplier: 1, constant: 20))
            }
            else {
                stack_locationList.superview!.addConstraint(NSLayoutConstraint(item: tag_financingInfo, attribute: .top, relatedBy: .equal, toItem: label_businessInfo, attribute: .bottom, multiplier: 1, constant: 20))
            }
        }
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
        
        btn_PDFCreate.superview!.frame.size = CGSize(width: btn_PDFCreate.superview!.frame.size.width, height: scrollView.contentLayoutGuide.layoutFrame.size.height) //由于在上面的label设置了段落文字后，会使下方button的frame超出他父控件的frame，z所以这里需要重新设置父控件的frame使button有效
    }
}
