//
//  OpportunityAbstractContract.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/3/12.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import Foundation

protocol OpportunityAbstractView {
    func setTitle(title: String)
    func setParagraph(para: String)
}

protocol OpportunityAbstractPresenter {
    func getInfo()
}
