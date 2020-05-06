//
//  BaseInfoDetailController.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/3/3.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import UIKit

class BaseInfoDetailController: UIViewController {

    var mPresenter = BaseInfoDetailModel()
    
    @IBOutlet weak var label_companyName: UILabel!
    @IBOutlet weak var label_groupName: UILabel!
    @IBOutlet weak var label_establishDate: UILabel!
    @IBOutlet weak var label_stockNameList: UILabel!
    @IBOutlet weak var label_stockIdList: UILabel!
    @IBOutlet weak var label_registeredCapital: UILabel!
    @IBOutlet weak var label_legalRepresentative: UILabel!
    @IBOutlet weak var label_registeredAddress: UILabel!
    @IBOutlet weak var label_mainBusiness: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mPresenter.mView = self
        self.setCompanyName(name: remoteGetCompanyName())
        mPresenter.getInfo()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.addSubview(homeButton)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        homeButton.removeFromSuperview()
    }
}

extension BaseInfoDetailController: BaseInfoDetailView {
    func setCompanyName(name: String) {
        label_companyName.text = name
        label_companyName.backgroundColor = .systemBackground
    }
    
    func setGroupName(name: String) {
        label_groupName.text = name
        label_groupName.backgroundColor = .systemBackground
    }
    
    func setEstablishDate(date: String) {
        label_establishDate.text = date
        label_establishDate.backgroundColor = .systemBackground
    }
    
    func setListedInfo(list: [[String]]) {
        var nameList = ""
        var idList = ""
        for i in 0..<list.count {
            nameList += list[i][0]
            idList += list[i][1]
            if i < list.count - 1 {
                nameList += "\r"
                idList += "\r"
            }
        }
        label_stockNameList.text = nameList
        label_stockIdList.text = idList
    }
    
    func setResgisteredCapital(capital: String) {
        label_registeredCapital.text = capital
        label_registeredCapital.backgroundColor = .systemBackground
    }
    
    func setLegalPerson(person: String) {
        label_legalRepresentative.text = person
        label_legalRepresentative.backgroundColor = .systemBackground
    }
    
    func setRegisteredAddress(address: String) {
        label_registeredAddress.text = address
        label_registeredAddress.backgroundColor = .systemBackground
    }
    
    func setMainBusiness(paragraph: String) {
        label_mainBusiness.text = paragraph
        label_mainBusiness.backgroundColor = .systemBackground
    }
}
