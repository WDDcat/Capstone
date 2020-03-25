//
//  CompanyCellModel.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/3/26.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import Foundation

protocol CompanyCellModelDelegate {
    func postAddCollect(c_id: String, name: String, recordName: String) ->Bool
    func postCancelCollect(c_id: String, name: String, recordName: String) -> Bool
}

class CompanyCellModel: CompanyCellModelDelegate {
    func postAddCollect(c_id: String, name: String, recordName: String) -> Bool {
        print("stared company:\"\(name)\" with id:(\(c_id))")
        return true
    }
    
    func postCancelCollect(c_id: String, name: String, recordName: String) -> Bool {
        print("unstared company:\"\(name)\" with id:(\(c_id))")
        return true
    }
}
