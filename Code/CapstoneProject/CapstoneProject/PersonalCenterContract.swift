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
    func refreshCompanyList()
    func refreshFriendsList()
    func refreshMessageList()
    func setFooterView(text: String)
    func logoutSuccess()
}

protocol PersonalCenterPresenter {
    func getPersonalInfo()
    func getFavouriteInfo(page: Int)
    func getFriendsInfo()
    func getMessageInfo()
    func logoutAttempt()
}
