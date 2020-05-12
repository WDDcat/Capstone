//
//  PreRegisterPageController.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/3/24.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import UIKit

class PreRegisterPageController: UIViewController {

    var mPresenter = PreRegisterPageModel()
    
    @IBOutlet weak var field_phoneNumber: UITextField!
    @IBOutlet weak var field_varificationCode: UITextField!
    @IBOutlet weak var image_varificationCode: UIImageView!
    @IBOutlet weak var field_SMSCode: UITextField!
    @IBOutlet weak var field_password: UITextField!
    @IBOutlet weak var field_passwordConfirm: UITextField!
    
    @IBAction func btn_sendSNS(_ sender: UIButton) {
        if validatePhoneNumber() {
            mPresenter.validateVarificationCode(phone: field_phoneNumber.text!, code: field_varificationCode.text!)
        }
        else {
            setPhoneNumberPlaceholder(text: "号码格式错误")
        }
    }
    
    @IBAction func btn_submit(_ sender: UIButton) {
        if checkDataValid() {
            print("attempt submit")
            if remoteGetRegisterFrom() == "forget" {
                mPresenter.submitSMSCode(phone: field_phoneNumber.text!, SMSCode: field_SMSCode.text!)
            }
            else if remoteGetRegisterFrom() == "register" {
                mPresenter.submitRegisteration(phone: field_phoneNumber.text!, password: field_password.text!, SMSCode: field_SMSCode.text!)
            }
        }
    }
    
    var clearToSendSMS = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mPresenter.mView = self
        mPresenter.getGraphicCode()
        image_varificationCode.isUserInteractionEnabled = true
        image_varificationCode.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickVerificationCode)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if remoteGetRegisterFrom() == "forget" {
            title = "找回密码"
            field_password.placeholder = "新密码"
        }
        else if remoteGetRegisterFrom() == "register" {
            title = "注册"
        }
    }

    @objc func clickVerificationCode() {
        clearToSendSMS = false
        mPresenter.getGraphicCode()
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
    
    func clearPlaceHolder() {
        field_phoneNumber.text = ""
        field_varificationCode.text = ""
        field_SMSCode.text = ""
        mPresenter.getGraphicCode()
        field_password.text = ""
        field_passwordConfirm.text = ""
    }
    
    func setGraphicCode(image: UIImage) {
        image_varificationCode.image = image
    }
    
    func rightVarificationCode() {
        clearToSendSMS = true
    }
    
    func rightSMSCode() {
        mPresenter.submitNewPassword(password: field_password.text!)
    }
    
    func registerSuccess() {
        let controller = storyboard?.instantiateViewController(withIdentifier: "RegisterPage") as! RegisterPageController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func resetPasswordSuccess() {
        let alertController = UIAlertController(title: "密码修改成功", message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "确认", style: .default, handler: {
            action in
            self.navigationController?.popToRootViewController(animated: true)
        })
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension PreRegisterPageController {
    func checkDataValid() -> Bool {
        
        if validatePhoneNumber() && clearToSendSMS && field_SMSCode.text != "" && validatePassword() && field_password.text == field_passwordConfirm.text {
            return true
        }
        
        if !validatePhoneNumber() {
            setPhoneNumberPlaceholder(text: "号码格式错误")
        }
        
        if !clearToSendSMS {
            setVarificationCodePlaceholder(text: "验证码错误")
            mPresenter.getGraphicCode()
        }
        
        if field_SMSCode.text == "" {
            field_SMSCode.attributedPlaceholder = NSAttributedString.init(string: "短信验证码错误", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
        }
        
        if !validatePassword() {
            field_password.text = ""
            field_password.attributedPlaceholder = NSAttributedString.init(string: "密码需为9-16位字母数字", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
        }
        
        if field_password.text != field_passwordConfirm.text {
            field_passwordConfirm.text = ""
            field_passwordConfirm.attributedPlaceholder = NSAttributedString.init(string: "密码输入不一致", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
        }
        
        return false
    }
    
    func validatePhoneNumber() -> Bool {
        let mobile = "^1(3|4|5|7|8)\\d{9}$"
        let regexMobile = NSPredicate(format: "SELF MATCHES %@", mobile)
        if regexMobile.evaluate(with: field_phoneNumber.text! as NSString) {
            return true
        }
        return false
    }
    
    func validatePassword() -> Bool {
        let password = "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,16}$"
        let regexPassword = NSPredicate(format: "SELF MATCHES %@", password)
        if regexPassword.evaluate(with: field_password.text! as NSString) {
            return true
        }
        return false
    }
}
