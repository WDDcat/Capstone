//
//  RequestClient.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/2/27.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import Foundation

protocol RequestClient {
    var host: String { get }
    
    func requestParam<T: TargetType>(_ r: T,
                                     Success: @escaping(_ response: Any) -> (),
                                     Failure: @escaping(_ error: Error) -> ())
}
