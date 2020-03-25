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

private var registerFrom = ""
public func remoteSetRegisterFrom(from: String) { registerFrom = from }
public func remoteGetRegisterFrom() -> String { return registerFrom }


public let userDefaults = UserDefaults.standard

func updateSession(newSession: String) -> Bool {
    let session = userDefaults.string(forKey: "session")
    if session != newSession {
        userDefaults.set(newSession, forKey: "session")
        return true
    }
    return false
}

func updateToken(newToken: String) -> Bool {
    let token = userDefaults.string(forKey: "token_id")
    if token != newToken {
        userDefaults.set(newToken, forKey: "token_id")
        return true
    }
    return false
}

func getHeader() -> HTTPHeaders {
    let token: String = userDefaults.string(forKey: "token_id") ?? ""
    let session: String = userDefaults.string(forKey: "session") ?? ""
    let header: HTTPHeaders = ["token-id": token, "Cookie": session]
    return header
}










