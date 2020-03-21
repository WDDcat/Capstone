//
//  remote.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/3/1.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import Foundation
import Alamofire


//public let BASEURL = "http://47.92.50.218:8881/api1/"
public let BASEURL = "http://apitest.qirongbaotech.com/api1/"

private let id = "918551a38b7bb58df883e8df0f156ed4"
//private let id = "3ad1d93a9080cc86ffc0e9612717cc0d"

//private var tokenId: String = id
//public func remoteSetTokenId(id: String) { tokenId = id }
//public func remoteGetTokenId() -> String { return tokenId }

public var header: HTTPHeaders = ["token-id": userDefaults.string(forKey: "token_id") ?? ""]

private var keyword = ""
public func remoteSetSearchKeyword(word: String) { keyword = word }
public func remoteGetSearchKeyword() -> String { return keyword }

private var companyId = ""
public func remoteSetCompanyId(id: String) { companyId = id }
public func remoteGetCompanyId() -> String { return companyId }

private var companyName = ""
public func remoteSetCompanyName(name: String) { companyName = name }
public func remoteGetCompanyName() -> String { return companyName }

private var opportunityFirstLevel = ""
public func remoteSetOpportunityFirstLevel(name: String) { opportunityFirstLevel = name }
public func remoteGetOpportunityFirstLevel() -> String { return opportunityFirstLevel }

public let userDefaults = UserDefaults.standard










