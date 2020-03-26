//
//  PreRegisterPage.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/3/24.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import Foundation
import UIKit

protocol  PreRegisterPageView {
    func setPhoneNumberPlaceholder(text: String)
    func setVarificationCodePlaceholder(text: String)
    func setGraphicCode(image: UIImage)
    func rightVarificationCode()
    func registerSuccess()
    func resetPasswordSuccess()
}

protocol PreRegisterPagePresenter {
    func getGraphicCode()
    func submitRegisteration(phone: String, password: String, SMSCode: String)
    func submitNewPassword(password: String)
    func validateVarificationCode(phone: String, code: String)
}
