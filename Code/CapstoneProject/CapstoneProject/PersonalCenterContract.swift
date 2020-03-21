//
//  PersonalCenterContract.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/3/19.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import Foundation

protocol PersonalCenterView {
    func setRealName(name: String)
    func setOccupation(occupation: String)
    func setCompany(company: String)
    func setPosition(position: String)
}

protocol PersonalCenterPresenter {
    func getPersonalInfo()
}
