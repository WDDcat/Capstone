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
    
    private var userId = ""
    private var password = ""
    
    @IBAction func btn_login(_ sender: UIButton) {
        userId = textfield_userId.text ?? ""
        password = textfield_password.text ?? ""
        let mobile = "^1(3|4|5|7|8)\\d{9}$"
        let regexMobile = NSPredicate(format: "SELF MATCHES %@",mobile)
        if regexMobile.evaluate(with: userId as NSString) {
            if password != "" {
                mPresenter.loginAttempt(id: userId, pwd: password)
            }
            else {
                setPasswordPlaceholder(text: "密码不能为空")
            }
        }
        else {
            setIdPlaceholder(text: "请输入正确的手机号码")
        }
    }
    
    @IBAction func btn_forget(_ sender: UIButton) {
        remoteSetRegisterFrom(from: "forget")
    }
    
    @IBAction func btn_register(_ sender: Any) {
        remoteSetRegisterFrom(from: "register")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mPresenter.mView = self
    }
}

extension LoginPageController: LoginPageView {
    func setIdPlaceholder(text: String) {
        textfield_userId.text = ""
        textfield_password.text = ""
        textfield_userId.attributedPlaceholder = NSAttributedString.init(string: text, attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
    }
    
    func setPasswordPlaceholder(text: String) {
        textfield_password.text = ""
        textfield_password.attributedPlaceholder = NSAttributedString.init(string: text, attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
    }
    
    func loginSuccess() {
        print("login success")
        let alertController = UIAlertController(title: "登录成功", message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "确认", style: .default, handler: {
            action in
            self.navigationController?.popViewController(animated: true)
        })
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
