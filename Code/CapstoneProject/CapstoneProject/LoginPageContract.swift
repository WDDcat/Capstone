//
//  LoginPagecontract.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/3/18.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import Foundation

protocol LoginPageView {
    func setIdPlaceholder(text: String)
    func setPasswordPlaceholder(text: String)
    func loginSuccess()
}

protocol LoginPagePresenter {
    func loginAttempt(id: String, pwd: String)
}
