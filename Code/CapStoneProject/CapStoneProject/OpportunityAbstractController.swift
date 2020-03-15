//
//  OpportunityAbstractController.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/3/12.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import UIKit
import ActiveLabel

private let lightGray = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)

class OpportunityAbstractController: UIViewController {

    var mPresenter = OpportunityAbstractModel()
    
    @IBOutlet weak var view_existingFinancingChance: UIView!
    @IBOutlet weak var view_additionalFinancingChance: UIView!
    @IBOutlet weak var view_commitmentOptimizationChance: UIView!
    @IBOutlet weak var view_costOptimizationChance: UIView!
    @IBOutlet weak var view_financialStructOptimizationChance: UIView!
    
    @IBOutlet weak var label_existingFinancingChance: UILabel!
    @IBOutlet weak var label_additionalFinancingChance: UILabel!
    @IBOutlet weak var label_commitmentOptimizationChance: UILabel!
    @IBOutlet weak var label_costOptimizationChance: UILabel!
    @IBOutlet weak var label_financialStructOptimizationChance: UILabel!
    
    @IBAction func btn_existingFinancingChance(_ sender: Any) {
        remoteSetOpportunityFirstLevel(name: "existing_financing_chance")
    }
    
    @IBAction func btn_additionalFinancingChance(_ sender: Any) {
        remoteSetOpportunityFirstLevel(name: "additional_financing_chance")
    }
    
    @IBAction func btn_commitmentOptimizationChance(_ sender: Any) {
        remoteSetOpportunityFirstLevel(name: "commitment_optimization_chance")
    }
    
    @IBAction func btn_costOptimizationChance(_ sender: Any) {
        remoteSetOpportunityFirstLevel(name: "cost_optimization_chance")
    }
    
    @IBAction func btn_financialStructOptimizationChance(_ sender: Any) {
        remoteSetOpportunityFirstLevel(name: "financial_structure_optimization_chance")
    }
    
    private var currentViewHeight: CGFloat = 0
    private let rootView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCompanyName(name: remoteGetCompanyName())
        mPresenter.mView = self
        mPresenter.getInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.barTintColor = .red
        navigationController?.navigationBar.tintColor = lightGray
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.barTintColor = .systemBackground
        navigationController?.navigationBar.tintColor = .systemRed
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label]
    }
}

extension OpportunityAbstractController: OpportunityAbstractView {
    func setCompanyName(name: String) {
        title = "\(name)商机"
    }
    
    func setExistingFinancingChance(para: String) {
        if para != "" {
            label_existingFinancingChance.text = para
            label_existingFinancingChance.backgroundColor = .systemBackground
        }
        else {
            view_additionalFinancingChance.alpha = 0
            view_additionalFinancingChance.superview?.addConstraint(NSLayoutConstraint(item: view_additionalFinancingChance, attribute: .top, relatedBy: .equal, toItem: view_additionalFinancingChance, attribute: .top, multiplier: 1.0, constant: 0))
        }
    }
    
    func setAdditionalFinancingChance(para: String) {
        if para != "" {
            label_additionalFinancingChance.text = para
            label_additionalFinancingChance.backgroundColor = .systemBackground
        }
        else {
            view_existingFinancingChance.alpha = 0
            view_commitmentOptimizationChance.superview?.addConstraint(NSLayoutConstraint(item: view_commitmentOptimizationChance, attribute: .top, relatedBy: .equal, toItem: view_existingFinancingChance, attribute: .top, multiplier: 1.0, constant: 0))
        }
    }
    
    func setCommitmentOptimizationChance(para: String) {
        if para != "" {
            label_commitmentOptimizationChance.text = para
            label_commitmentOptimizationChance.backgroundColor = .systemBackground
        }
        else {
            view_commitmentOptimizationChance.alpha = 0
            view_costOptimizationChance.superview?.addConstraint(NSLayoutConstraint(item: view_costOptimizationChance, attribute: .top, relatedBy: .equal, toItem: view_commitmentOptimizationChance, attribute: .top, multiplier: 1.0, constant: 0))
        }
    }
    
    func setCostOptimizationChance(para: String) {
        if para != "" {
            label_costOptimizationChance.text = para
            label_costOptimizationChance.backgroundColor = .systemBackground
        }
        else {
            view_costOptimizationChance.alpha = 0
            label_financialStructOptimizationChance.superview?.addConstraint(NSLayoutConstraint(item: label_financialStructOptimizationChance, attribute: .top, relatedBy: .equal, toItem: view_costOptimizationChance, attribute: .top, multiplier: 1.0, constant: 0))
        }
    }
    
    func setFinancialStructOptimizationChance(para: String) {
        if para != "" {
            label_financialStructOptimizationChance.text = para
            label_financialStructOptimizationChance.backgroundColor = .systemBackground
        }
        else {
            view_existingFinancingChance.alpha = 0
        }
    }
    

}
