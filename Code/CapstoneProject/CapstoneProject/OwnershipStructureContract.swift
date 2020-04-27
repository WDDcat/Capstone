//
//  OwnershipStructureContract.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/4/27.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import Foundation

protocol OwnershipStructureView {
    func setCurrentCompany(name: String)
    func setGroupCompany(name: String)
    func setFatherList(list: [[String]])
    func setChildList(list: [[String]])
    func refreshList(c_id: String)
    func removeGroup()
}

protocol OwnershipStructurePresent {
    func refreshCompany(c_id: String)
    func refreshFatherList(c_id: String)
}
