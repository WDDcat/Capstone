//
//  OwnershipStructureController.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/4/27.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import UIKit

class OwnershipStructureController: UIViewController {

    var mPresenter = OwnershipStructureModel()
    
    @IBOutlet weak var label_groupCompany: UILabel!
    @IBOutlet weak var label_currentCompany: UILabel!
    @IBOutlet weak var stack_groupCompany: UIStackView!
    @IBOutlet weak var stack_fatherList: UIStackView!
    @IBOutlet weak var stack_childList: UIStackView!
    
    @IBOutlet weak var line1: UILabel!
    @IBOutlet weak var line2: UILabel!
    @IBOutlet weak var line3: UILabel!
    @IBOutlet weak var line4: UILabel!
    @IBOutlet weak var line5: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mPresenter.mView = self
        initTree(c_id: remoteGetCompanyId())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.addSubview(homeButton)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        homeButton.removeFromSuperview()
    }
    
    func initTree(c_id: String) {
        line4.alpha = 0
        mPresenter.refreshCompany(c_id: c_id)
    }
}

extension OwnershipStructureController: OwnershipStructureView {
    func setCurrentCompany(name: String) {
        label_currentCompany.text = name
    }
    
    func setGroupCompany(name: String) {
        label_groupCompany.text = name
    }
    
    func setFatherList(list: [[String]]) {
        let mfhl = MyFatherHolderList(rootView: stack_fatherList)
        for i in 0..<list.count {
            mfhl.add(list[i][1], list[i][2], list[i][0])
        }
        let height = list.count * 35 + (list.count - 1) * 8 + 30
        label_currentCompany.superview?.addConstraint(NSLayoutConstraint(item: label_currentCompany, attribute: .top, relatedBy: .equal, toItem: stack_fatherList, attribute: .top, multiplier: 1, constant: CGFloat(height)))
    }
    
    func setChildList(list: [[String]]) {
        let mchl = MyChildHolderList(rootView: stack_childList)
        for i in 0..<(list.count - 1) {
            mchl.add(list[i][1], list[i][2], list[i][0])
        }
        mchl.addLast(list[list.count - 1][1], list[list.count - 1][2], list[list.count - 1][0])
    }
    
    func refreshList(c_id: String) {
        if(label_currentCompany.text != "该公司信息尚未完善") {
            mPresenter.refreshFatherList(c_id: c_id)
            mPresenter.refreshChildList(c_id: c_id)
        }
    }
    
    func removeGroup() {
        line1.alpha = 0
        line2.alpha = 0
        line3.alpha = 0
        line4.alpha = 1
        label_currentCompany.superview?.removeConstraint(NSLayoutConstraint(item: label_currentCompany, attribute: .top, relatedBy: .equal, toItem: line1, attribute: .bottom, multiplier: 1, constant: 15))
        label_currentCompany.superview?.addConstraint(NSLayoutConstraint(item: label_currentCompany, attribute: .top, relatedBy: .equal, toItem: stack_groupCompany, attribute: .top, multiplier: 1, constant: 0))
    }
}
