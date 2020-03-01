//
//  FinancialReportController.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/3/1.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import UIKit

class FinancialReportController: UIViewController {

    var mPresenter = FinancialReportModel()
    
    // MARK: -title
    @IBOutlet weak var label_companyNameTitle: UILabel!
    @IBOutlet weak var stack_tags: UIStackView!
    @IBOutlet weak var tag_bond: UILabel!
    @IBOutlet weak var tag_gov: UILabel!
    @IBOutlet weak var tag_listed: UILabel!
    @IBOutlet weak var tag_loc: UILabel!
    @IBOutlet weak var tag_stateOwned: UILabel!
    //MARK: -basic info
    @IBOutlet weak var label_companyName: UILabel!
    @IBOutlet weak var label_groupName: UILabel!
    @IBOutlet weak var label_legalPerson: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mPresenter.mView = self
        stack_tags.alpha = 0
        self.setCompanyName(name: remoteGetCompanyName())
        mPresenter.getInfo()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        //self.navigationController?.navigationBar.tintColor = .white
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension FinancialReportController: FinancialReportView {
    // MARK: -title
    func setCompanyName(name: String) {
        label_companyNameTitle.text = name
        label_companyName.text = name
        label_companyName.backgroundColor = .white
    }
    
    func setTags(tags:[String]) {
        if tags[0] != "1" { tag_bond.removeFromSuperview() }
        if tags[1] != "1" { tag_gov.removeFromSuperview() }
        if tags[2] != "1" { tag_listed.removeFromSuperview() }
        if tags[3] != "1" { tag_loc.removeFromSuperview() }
        if tags[4] != "1" { tag_stateOwned.removeFromSuperview() }
        stack_tags.alpha = 1
    }
    //MARK: -basic info
    func setgroupName(name: String) {
        label_groupName.text = name
        label_groupName.backgroundColor = .white
    }
    
    func setLegalPerson(name: String) {
        label_legalPerson.text = name
        label_legalPerson.backgroundColor = .white
    }
    
    func setShareHolder(company: String, percent: String) {
        
    }
    
    func setHistory(paragraph: String) {
        
    }
    
    func setManager(names: String) {
        
    }
    
    func setBusinessInfo(paragraph: String) {
        
    }
}
