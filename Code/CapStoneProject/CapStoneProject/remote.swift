//
//  remote.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/3/1.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import Foundation

public let BASEURL = "http://47.92.50.218:8881/api1/"

private var companyId:String = ""
public func remoteSetCompanyId(id: String) { companyId = id }
public func remoteGetCompanyId() -> String { return companyId }

private var companyName:String = ""
public func remoteSetCompanyName(name: String) { companyName = name }
public func remoteGetCompanyName() -> String { return companyName }


//let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 40))
//titleLabel.text = "海南航空控股股份有限公司"
//titleLabel.backgroundColor = .clear
//titleLabel.textAlignment = .center
//titleLabel.textColor = .white
//titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
