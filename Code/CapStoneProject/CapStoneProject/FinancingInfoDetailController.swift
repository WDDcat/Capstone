//
//  FinancingInfoDetailController.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/3/9.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import UIKit

var columnNum: Int = 0

class FinancingInfoDetailController: UIViewController {

    var mPresenter = FinancingInfoDetailModel()
    
    @IBOutlet weak var baseScrollView: UIScrollView!
    @IBOutlet weak var label_topSummary: UILabel!
    @IBOutlet weak var label_preList: UILabel!
    @IBOutlet weak var stack_list: UIStackView!
    @IBOutlet weak var label_attention: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mPresenter.mView = self
        mPresenter.getInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.baseScrollView.contentSize = CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height + 20)
    }

}

extension FinancingInfoDetailController: FinancingInfoDetailView {
    func setTopSummary(para: String) {
        label_topSummary.text = para
        label_topSummary.backgroundColor = .systemBackground
    }
    
    func setPreList(para: String) {
        label_preList.text = para
        label_preList.backgroundColor = .systemBackground
    }
    
    func setAttention(para: String) {
        label_attention.text = para
    }
    
    func setChartColumn(col: Int) {
        columnNum = col
    }
    
    func setTable(data: [String]) {
        stack_list.superview!.addConstraint(NSLayoutConstraint(item: stack_list, attribute: .top, relatedBy: .equal, toItem: label_preList, attribute: .bottom, multiplier: 1.0, constant: 40))
        let mTable = MyTable(rootView: stack_list)
        mTable.setColumn(num: columnNum)
        for i in 0..<data.count {
            mTable.add(data[i])
        }
        stack_list.superview!.addConstraint(NSLayoutConstraint(item: label_attention, attribute: .top, relatedBy: .equal, toItem: stack_list, attribute: .bottom, multiplier: 1.0, constant: 20))
    }
}
