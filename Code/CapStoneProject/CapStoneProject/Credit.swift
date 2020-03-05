//
//  Credit.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/3/3.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import Foundation

public class Credit {
    private var priority: Int  //1:人民币 2:美元 3:欧元 4:日元 5:其他
    private var currency: String
    private var used: String
    private var amount: String
    private var unused: String
    
    init(priority: Int, currency: String, used: String, amount: String, unused: String) {
        self.priority = priority
        self.currency = currency
        self.used = used
        self.unused = unused
        self.amount = amount
    }
    
    func getPriority() -> Int { return self.priority }
    
    func getCurrency() -> String { return self.currency }
    
    func getUsed() -> String { return self.unused }
    
    func getAmont() -> String { return self.amount }
    
    func getUnused() -> String {return self.unused }
}
