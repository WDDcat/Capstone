//
//  PersonalCenterController.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/3/19.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import UIKit

class PersonalCenterController: UIViewController {

    var mPresenter = PersonalCenterModel()
    
    @IBOutlet weak var btn_logout: UIBarButtonItem!
    @IBOutlet weak var label_realName: UILabel!
    @IBOutlet weak var label_occupation: UILabel!
    @IBOutlet weak var label_company: UILabel!
    @IBOutlet weak var label_position: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mPresenter.mView = self
        title = "个人中心"
        mPresenter.getPersonalInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !userDefaults.bool(forKey: "loginStatus") {
            let controller = storyboard?.instantiateViewController(withIdentifier: "LoginPage") as! LoginPageController
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    
}

extension PersonalCenterController: PersonalCenterView {
    func setRealName(name: String) {
        label_realName.text = name
    }
    
    func setOccupation(occupation: String) {
        label_occupation.text = occupation
    }
    
    func setCompany(company: String) {
        label_company.text = company
    }
    
    func setPosition(position: String) {
        label_position.text = position
    }
}
