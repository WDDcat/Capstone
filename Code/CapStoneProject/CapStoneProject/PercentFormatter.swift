//
//  PercentFormatter.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/3/5.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import Foundation
import Charts

class PercentFormatter: NSObject, IValueFormatter {
    
    fileprivate var numberFormatter: NumberFormatter?
    
    convenience init(numberFormatter: NumberFormatter) {
        self.init()
        self.numberFormatter = numberFormatter
    }
    
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        guard let numberFormatter = numberFormatter
            else {
                return "\(value)%"
        }
        return numberFormatter.string(for: value)!
    }
}
