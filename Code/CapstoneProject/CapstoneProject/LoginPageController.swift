//
//  LoginPageController.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/3/18.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import UIKit

class LoginPageController: UIViewController {

    var mPresenter = LoginPageModel()
    
    @IBOutlet weak var textfield_userId: UITextField!
    @IBOutlet weak var textfield_password: UITextField!
    
    @IBAction func btn_back(_ sender: UIBarButtonItem) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    private var userId = ""
    private var password = ""
    
    @IBAction func btn_login(_ sender: UIButton) {
        userId = textfield_userId.text ?? ""
        password = textfield_password.text ?? ""
        let pattern = "^1(3|4|5|7|8)\\d{9}$"
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        if let results = regex?.matches(in: userId, options: [], range: NSRange(location: 0, length: userId.count)), results.count != 0 {
            for res in results {
                let string = (userId as NSString).substring(with: res.range)
                if !(password == "") {
                    mPresenter.loginAttempt(id: string, pwd: password)
                }
                else {
                    setPasswordPlaceholder(text: "密码不能为空")
                }
            }
        }
        else {
            setIdPlaceholder(text: "请输入正确的手机号码")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mPresenter.mView = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
}

extension LoginPageController: LoginPageView {
    func setIdPlaceholder(text: String) {
        textfield_userId.attributedPlaceholder = NSAttributedString.init(string: text, attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
        textfield_password.text = ""
    }
    
    func setPasswordPlaceholder(text: String) {
        textfield_password.attributedPlaceholder = NSAttributedString.init(string: text, attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
    }
    
    func loginSuccess() {
        print("success")
        self.navigationController?.popViewController(animated: true)
    }
}
