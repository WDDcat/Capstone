//
//  PreRegisterPageController.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/3/24.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import UIKit
import AlamofireImage

class PreRegisterPageController: UIViewController {

    var mPresenter = PreRegisterPageModel()
    
    @IBOutlet weak var field_phoneNumber: UITextField!
    @IBOutlet weak var field_varificationCode: UITextField!
    @IBOutlet weak var image_varificationCode: UIImageView!
    @IBOutlet weak var field_SNSCode: UITextField!
    @IBOutlet weak var field_password: UITextField!
    @IBOutlet weak var field_passwordConfirm: UITextField!
    
    @IBAction func btn_sendSNS(_ sender: UIButton) {
        if validatePhoneNumber() && field_varificationCode.text != "" {
            mPresenter.validateVarificationCode(phone: field_phoneNumber.text!, code: field_varificationCode.text!)
        }
        else {
            setPhoneNumberPlaceholder(text: "号码格式错误")
        }
    }
    
    @IBAction func btn_submit(_ sender: UIButton) {
        if checkDataValid() {
            print("attempt submit")
            mPresenter.submitRegisteration()
        }
    }
    
    var clearToSendSMS = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mPresenter.mView = self
        
        image_varificationCode.af_setImage(withURL: URL(string :"\(BASEURL)img_code")!)
        image_varificationCode.isUserInteractionEnabled = true
        image_varificationCode.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickVerificationCode)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if remoteGetRegisterFrom() == "forget" {
            title = "找回密码"
        }
        else if remoteGetRegisterFrom() == "register" {
            title = "注册"
        }
    }

    @objc func clickVerificationCode() {
        image_varificationCode.af_setImage(withURL: URL(string :"\(BASEURL)img_code")!)
    }
}

extension PreRegisterPageController: PreRegisterPageView {
    func setPhoneNumberPlaceholder(text: String) {
        field_phoneNumber.text = ""
        field_phoneNumber.attributedPlaceholder = NSAttributedString.init(string: text, attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
    }
    
    func setVarificationCodePlaceholder(text: String) {
        field_varificationCode.text = ""
        field_varificationCode.attributedPlaceholder = NSAttributedString.init(string: text, attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
    }
    
    func rightVarificationCode() {
        clearToSendSMS = true
    }
}

extension PreRegisterPageController {
    func checkDataValid() -> Bool {
        var clearToSubmit = true
        
        if !validatePhoneNumber() {
            setPhoneNumberPlaceholder(text: "号码格式错误")
            clearToSubmit = false
        }
        
        
        
        return clearToSubmit
    }
    
    func validatePhoneNumber() -> Bool {
        let mobile = "^1(3|4|5|7|8)\\d{9}$"
        let regexMobile = NSPredicate(format: "SELF MATCHES %@",mobile)
        if regexMobile.evaluate(with: field_phoneNumber.text! as NSString) {
            return true
        }
        return false
    }
}
