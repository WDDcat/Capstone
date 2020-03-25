//
//  PersonalCenterController.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/3/19.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import UIKit
import SVProgressHUD

class PersonalCenterController: UIViewController {

    var mPresenter = PersonalCenterModel()
    
    @IBOutlet weak var label_realName: UILabel!
    @IBOutlet weak var label_occupation: UILabel!
    @IBOutlet weak var label_company: UILabel!
    @IBOutlet weak var label_position: UILabel!
    
    var logout = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mPresenter.mView = self
        mPresenter.getPersonalInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !userDefaults.bool(forKey: "login_status") {
            let controller = storyboard?.instantiateViewController(withIdentifier: "LoginPage") as! LoginPageController
            self.navigationController?.pushViewController(controller, animated: true)
        }
        else {
            logout = UIButton(frame: CGRect(x: UIScreen.main.bounds.width - 50, y: 0, width: 40, height: (navigationController?.navigationBar.frame.height)!))
            logout.setTitleColor(.systemRed, for: .normal)
            logout.setTitle("注销", for: .normal)
            logout.isUserInteractionEnabled = true
            logout.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickLogout)))
            navigationController?.navigationBar.addSubview(logout)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        logout.removeFromSuperview()
    }
    
    @objc func clickLogout() {
        print("attempt logout")
        mPresenter.logoutAttempt()
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
    
    func logoutSuccess() {
        print("success")
        self.navigationController?.popViewController(animated: true)
    }
}
