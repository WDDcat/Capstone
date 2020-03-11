//
//  CapitalRaisingInfoDetailController.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/3/11.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import UIKit
import Charts

class CapitalRaisingInfoDetailController: UIViewController {

    var mPresenter = CapitalRaisingInfoDetailModel()
    
    @IBOutlet weak var label_overview: UILabel!
    @IBOutlet weak var label_bankCreditInfo: UILabel!
    @IBOutlet weak var stack_bankCreditTable: UIStackView!
    @IBOutlet weak var label_bondCapitalRaisingInfo: UILabel!
    @IBOutlet weak var stack_bondCapitalRaisingTable: UIStackView!
    @IBOutlet weak var chart_lineChart1: LineChartView!
    @IBOutlet weak var chart_lineChart2: LineChartView!
    @IBOutlet weak var label_debtInfo: UILabel!
    @IBOutlet weak var stack_debtTable: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mPresenter.mView = self
        mPresenter.getInfo()
    }
}

extension CapitalRaisingInfoDetailController: CapitalRaisingInfoDetailView {
    func setGroupCapitalRaisingOverviewInfo(para: String) {
        label_overview.text = para
        label_overview.backgroundColor = .systemBackground
    }
    
    func setGroupCreditInfo(para: String) {
        label_bankCreditInfo.text = para
        label_bankCreditInfo.backgroundColor = .systemBackground
    }
    
    func setBondCapitalRaisingInfo(para: String) {
        label_bondCapitalRaisingInfo.text = para
        label_bondCapitalRaisingInfo.backgroundColor = .systemBackground
    }
    
    func setCreditTable(dataList: [String]) {
        let title = ["银行名称", "授信额度", "已使用额度", "未使用额度", "币种", "授信到期日"]
        let mTable = MyTable(rootView: stack_bankCreditTable)
        mTable.setColumn(num: 6)
        for i in 0..<title.count {
            mTable.add(title[i])
        }
        for i in 0..<dataList.count {
            mTable.add(dataList[i])
        }
    }
    
    func setBondTable(dataList: [String]) {
        let title = ["债务主体", "发行日期", "发行期限（月）", "发型规模", "主承销商", "种类"]
        let mTable = MyTable(rootView: stack_bondCapitalRaisingTable)
        mTable.setColumn(num: 6)
        for i in 0..<title.count {
            mTable.add(title[i])
        }
        for i in 0..<dataList.count {
            mTable.add(dataList[i])
        }
    }
}
