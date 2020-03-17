//
//  OpportunityDetailContract.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/3/15.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import Foundation

protocol OpportunityDetailView {
    func setTitle(title: String)
    func setParagraph(para: String)
    func setPartEnd()
    func setTableColumn(column: Int)
    func setTable(dataList: [String])
    func finishSetting()
}

protocol OpportunityDetailPresenter {
    func getInfo()
}
