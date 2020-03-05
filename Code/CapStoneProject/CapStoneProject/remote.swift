//
//  remote.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/3/1.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import Foundation
import Alamofire

public let BASEURL = "http://47.92.50.218:8881/api1/"
public let header:HTTPHeaders = ["token-id":"a7b2668646dc11e9983300163e02e9cd"]

private var companyId:String = ""
public func remoteSetCompanyId(id: String) { companyId = id }
public func remoteGetCompanyId() -> String { return companyId }

private var companyName:String = ""
public func remoteSetCompanyName(name: String) { companyName = name }
public func remoteGetCompanyName() -> String { return companyName }
