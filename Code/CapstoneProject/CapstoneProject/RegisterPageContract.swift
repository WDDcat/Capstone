//
//  RegisterPageContract.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/3/22.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import Foundation

protocol RegisterPageView {
    func setRealName(name: String)
    func setFinancialFacility(facility: String)
    func setDepartment(department: String)
    func setPosition(position: String)
    func setDuty(duty: String)
    func setPhoneNumber(num: String)
    func setEmail(email: String)
    
    func submitSuccess()
}

protocol RegisterPagePresenter {
    func getSavedInfo()
    func submitInformation(realName: String, nickName: String, institution: String, department: String, position: String, responsibility: String, phoneNumber: String, email: String, avatar: String, card: String)
}
