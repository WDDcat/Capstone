//
//  RegisterPageController.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/3/22.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import UIKit

private enum PickerType {
    case department
    case position
}

private let departmentList = ["金融市场部", "资产管理部", "投资银行部", "公司业务部", "战略客户部（大客户部）", "国际业务部"]
private let positionList = ["总经理", "副总经理", "处长", "副处长", "行长", "副行长", "客户经理", "经理", "高级经理", "副董事", "董事", "执行董事", "董事总经理"]

class RegisterPageController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var mPresenter = RegisterPageModel()
    
    @IBOutlet weak var field_name: UITextField!
    @IBOutlet weak var field_financialFacility: UITextField!
    @IBOutlet weak var label_department: UILabel!
    @IBOutlet weak var label_position: UILabel!
    @IBOutlet weak var field_duty: UITextField!
    @IBOutlet weak var field_phoneNumber: UITextField!
    @IBOutlet weak var field_email: UITextField!
    
    @IBAction func btn_submit(_ sender: UIButton) {
        if checkDataValid() {
            print("submit attempt")
            mPresenter.submitInformation(
                realName: field_name.text ?? "none",
                nickName: "none",
                institution: field_financialFacility.text ?? "none",
                department: label_department.text ?? "none",
                position: label_position.text ?? "none",
                responsibility: field_duty.text ?? "none",
                phoneNumber: field_phoneNumber.text ?? "none",
                email: field_email.text ?? "none",
                avatar: "none",
                card: "none")
        }
    }
    
    var pickerView = UIPickerView()
    
    fileprivate var pickerType: PickerType = .department
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mPresenter.mView = self
        pickerView.dataSource = self
        pickerView.delegate = self
        
        label_department.isUserInteractionEnabled = true
        label_department.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickDepartment)))
        
        label_position.isUserInteractionEnabled = true
        label_position.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickPosition)))
        
        mPresenter.getSavedInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        pickerView.alpha = 0
    }

    @objc func clickDepartment() {
        let alertController = UIAlertController(title: "\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "确定", style: .default) {
            (alertAction) -> Void in
            self.label_department.text = departmentList[self.pickerView.selectedRow(inComponent: 0)]
        })
        alertController.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        pickerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 16, height: 200)
        alertController.view.addSubview(pickerView)
        self.present(alertController, animated: true, completion: nil)
        pickerType = .department
        pickerView.reloadAllComponents()
        pickerView.alpha = 1
    }
    
    @objc func clickPosition() {
        let alertController = UIAlertController(title: "\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "确定", style: .default) {
            (alertAction) -> Void in
            self.label_position.text = positionList[self.pickerView.selectedRow(inComponent: 0)]
        })
        alertController.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        pickerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 16, height: 200)
        alertController.view.addSubview(pickerView)
        self.present(alertController, animated: true, completion: nil)
        pickerType = .position
        pickerView.reloadAllComponents()
        pickerView.alpha = 1
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerType {
        case .department:
            return departmentList.count
        case .position:
            return positionList.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerType {
        case .department:
            return departmentList[row]
        case .position:
            return positionList[row]
        }
    }
}

extension RegisterPageController: RegisterPageView {
    func setRealName(name: String) {
        field_name.text = name
    }
    
    func setFinancialFacility(facility: String) {
        field_financialFacility.text = facility
    }
    
    func setDepartment(department: String) {
        label_department.text = department
    }
    
    func setPosition(position: String) {
        label_position.text = position
    }
    
    func setDuty(duty: String) {
        field_duty.text = duty
    }
    
    func setPhoneNumber(num: String) {
        field_phoneNumber.text = num
    }
    
    func setEmail(email: String) {
        field_email.text = email
    }
    
    func submitSuccess() {
        navigationController?.popViewController(animated: true)
    }
}

extension RegisterPageController {
    func checkDataValid() -> Bool {
        
        var clearToSubmit = true
        
        if field_name.text == "" {
            field_name.attributedPlaceholder = NSAttributedString.init(string: "此项不能为空", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            clearToSubmit = false
        }
        
        if field_financialFacility.text == "" {
            field_financialFacility.attributedPlaceholder = NSAttributedString.init(string: "此项不能为空", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            clearToSubmit = false
        }
        
        if field_duty.text == "" {
            field_duty.attributedPlaceholder = NSAttributedString.init(string: "此项不能为空", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            clearToSubmit = false
        }
        
        let mobile = "^1(3|4|5|7|8)\\d{9}$"
        let regexMobile = NSPredicate(format: "SELF MATCHES %@",mobile)
        if !regexMobile.evaluate(with: field_phoneNumber.text! as NSString) {
            field_phoneNumber.text = ""
            field_phoneNumber.attributedPlaceholder = NSAttributedString.init(string: "请输入正确的手机号码", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            clearToSubmit = false
        }
        
        let email = "^([a-z0-9A-Z]+[-|\\.]?)+[a-z0-9A-Z]@[a-z0-9A-Z]+(-[a-z0-9A-Z]+?\\.)+[a-zA-Z]{2,}$"
        let regexEmail = NSPredicate(format: "SELF MATCHES %@",email)
        if !regexEmail.evaluate(with: field_email.text! as NSString) {
            field_email.text = ""
            field_email.attributedPlaceholder = NSAttributedString.init(string: "请输入正确的邮箱地址", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
//            clearToSubmit = false
        }
        
        return clearToSubmit
    }
}
