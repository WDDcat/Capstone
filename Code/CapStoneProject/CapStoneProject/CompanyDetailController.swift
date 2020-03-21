//
//  CompanyDetailController.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/3/1.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import UIKit

class CompanyDetailController: UIViewController {

    var mPresenter = CompanyDetailModel()
    
    @IBOutlet weak var label_companyName: UILabel!
    @IBOutlet weak var label_shareHolder: UILabel!
    @IBOutlet weak var label_legalPerson: UILabel!
    @IBOutlet weak var label_financialReport: UIButton!
    @IBOutlet weak var label_businessOpportunity: UIButton!
    
    @IBAction func btn_financialReport(_ sender: UIButton) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "FinancialReport") as! FinancialReportController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func btn_businessOpportunity(_ sender: UIButton) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "OpportunityAbstract") as! OpportunityAbstractController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mPresenter.mView = self
        self.setCompanyName(name: remoteGetCompanyName())
        mPresenter.getInfo()
    }

}

extension CompanyDetailController: CompanyDetailView {
    func setCompanyName(name: String) {
        label_companyName.text = name
        label_financialReport.setTitle("\(name)融报", for: .normal)
        label_businessOpportunity.setTitle("\(name)商机", for: .normal)
    }
    
    func setShareHolder(name: String) {
        label_shareHolder.text = name
    }
    
    func setLegalPerson(name: String) {
        label_legalPerson.text = name
    }
}
