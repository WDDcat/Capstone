//
//  OpportunityAbstractContract.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/3/12.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import Foundation

protocol OpportunityAbstractView {
    func setCompanyName(name: String)
    func setExistingFinancingChance(para: String)
    func setAdditionalFinancingChance(para: String)
    func setCommitmentOptimizationChance(para: String)
    func setCostOptimizationChance(para: String)
    func setFinancialStructOptimizationChance(para: String)
}

protocol OpportunityAbstractPresenter {
    func getInfo()
}
