//
//  TargetType.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/2/27.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import Foundation
import Alamofire

//接口相关配置
 public protocol TargetType {
    var url: String {get}
    var param: [String:Any] {get}
    var header: HTTPHeaders {get}
    var method: HTTPMethod {get}
    var hud: Bool {get}
}

extension TargetType {
    public var method: HTTPMethod {
        return HTTPMethod.get
    }
    public var hud: Bool {
        return true
    }
}
