//
//  PreRegisterPage.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/3/24.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import Foundation

protocol  PreRegisterPageView {
    func setPhoneNumberPlaceholder(text: String)
    func setVarificationCodePlaceholder(text: String)
    func rightVarificationCode()
}

protocol PreRegisterPagePresenter {
    func getGraphicCode()
    func submitRegisteration()
    func validateVarificationCode(phone: String, code: String)
}
