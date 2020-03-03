//
//  BaseInfoDetailContract.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/3/3.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import Foundation

protocol BaseInfoDetailView {
    func setCompanyName(name: String)
    func setGroupName(name: String)
    func setEstablishDate(date: String)
    func setListedInfo(list: [[String]])
    func setResgisteredCapital(capital: String)
    func setLegalPerson(person: String)
    func setRegisteredAddress(address: String)
    func setMainBusiness(paragraph: String)
}

protocol BaseInfoDetailPresent {
    func getInfo()
}
