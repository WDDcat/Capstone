//
//  OpportunityAbstractController.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/3/12.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import UIKit

class OpportunityAbstractController: UIViewController {

    var mPresenter = OpportunityAbstractModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mPresenter.mView = self
        mPresenter.getInfo()
    }
}

extension OpportunityAbstractController: OpportunityAbstractView {
    
}
