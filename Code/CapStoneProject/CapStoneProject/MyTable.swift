//
//  myTableView.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/3/5.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import Foundation
import UIKit

public class MyTable {
    
    private var currentView: UIView
    private var width: CGFloat = 0.0
    
    init(view: UIView) {//}, width: Float) {
        currentView = view
        
        
        
        currentView.backgroundColor = .black
    }
    
    
}

extension UIView {
    var size: CGSize {
        get { return self.frame.size }
        set(newValue) {
            self.frame.size = CGSize(width: newValue.width, height: newValue.height)
        }
    }
    
    var x: CGFloat {
        get { return frame.origin.x }
        set(newValue) {
            var tempFrame: CGRect = frame
            tempFrame.origin.x    = newValue
            frame                 = tempFrame
        }
    }
    
    var y: CGFloat {
        get { return frame.origin.y }
        set(newValue) {
            var tempFrame: CGRect = frame
            tempFrame.origin.y    = newValue
            frame                 = tempFrame
        }
    }
    
    var height: CGFloat {
        get { return frame.size.height }
        set(newValue) {
            var tempFrame: CGRect = frame
            tempFrame.size.height = newValue
            frame                 = tempFrame
        }
    }
    
    var width: CGFloat {
        get { return frame.size.width }
        set(newValue) {
            var tempFrame: CGRect = frame
            tempFrame.size.width  = newValue
            frame                 = tempFrame
        }
    }
    
    
}
