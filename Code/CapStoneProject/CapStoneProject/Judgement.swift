//
//  Judgement.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/3/2.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import Foundation
import UIKit

public func isNullOrEmpty(_ str: String) -> Bool {
    if(str == "None" || str == "--" || str == "" || str == "null") {
        return true
    }
    return false
}

public func notNull(_ str: String) -> String {
    if(str == "None" || str == "--" || str == "" || str == "null") {
        return "-"
    }
    return str
}

public func unitFormat(_ num: String) -> String {
    var number: Double
    var result: String = ""
    if notNull(num) == "-" {
        result = "-"
    }
    else {
        let pattern = "^-?[0-9]+(.[0-9]+)?$"
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        if let results = regex?.matches(in: num, options: [], range: NSRange(location: 0, length: num.count)), results.count != 0 {
            for res in results {
                let string = (num as NSString).substring(with: res.range)
                number = Double(string) ?? 0.0
                if abs(number) >= 100000000 {
                    result = String(format: "%.2f", number / 100000000) + "亿"
                }
                else if abs(number) >= 10000 {
                    result = String(format: "%.2f", number / 10000) + "万"
                }
                else {
                    result = String(format: "%.2f", number)
                }
            }
        }
        else if num.contains("%") {
            number = Double(num.replacingOccurrences(of: "%", with: "")) ?? 0.0
            result = String(format: "%.2f", number) + "%"
        }
        else if num.contains(","){
            result = date2String(num)
        }
        else {
            result = num
        }
    }
    return result
}

public func pointFormat(_ num: String) -> String {
    if !isNullOrEmpty(num) {
        return String(format: "%.2f", num)
    }
    return "-"
}

func date2String(_ date: String) -> String {
    var year: String = ""
    var month: String = ""
    var day: String = ""
    
    let timeStr: Array<Substring> = date.split(separator: " ")
    
    for i in (1..<timeStr.count).reversed() {
        if i == 1 {
            day = "\(timeStr[i])"
        }
        else if i == 2 {
            month = "\(timeStr[i])"
            switch month {
            case "Jan":
                month = "1"
            case "Feb":
                month = "2"
            case "Mar":
                month = "3"
            case "Apr":
                month = "4"
            case "May":
                month = "5"
            case "Jun":
                month = "6"
            case "Jul":
                month = "7"
            case "Aug":
                month = "8"
            case "Sep":
                month = "9"
            case "Oct":
                month = "10"
            case "Nov":
                month = "11"
            case "Dec":
                month = "12"
            default:
                month = ""
            }
        }
        else if i == 3 {
            year = "\(timeStr[i])"
        }
    }
    return "\(year)年\(month)月\(day)日"
}
