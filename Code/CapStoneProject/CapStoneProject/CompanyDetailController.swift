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
    @IBOutlet weak var btn_star: UIButton!
    
    @IBAction func btn_financialReport(_ sender: UIButton) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "FinancialReport") as! FinancialReportController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func btn_businessOpportunity(_ sender: UIButton) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "OpportunityAbstract") as! OpportunityAbstractController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    @IBAction func btn_starPressed(_ sender: UIButton) {
        if btn_star.image(for: .normal) == UIImage(systemName: "star") {
            mPresenter.postAddCollect(name: label_companyName.text!)
        }
        else {
            mPresenter.postCancelCollect(name: label_companyName.text!)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.addSubview(homeButton)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        homeButton.removeFromSuperview()
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
    
    func setStarStatus(status: Int) {
        let image = status == 1 ? "star.fill" : "star"
        btn_star.setImage(UIImage(systemName: image), for: .normal)
    }
    
    func addSuccess() {
        btn_star.setImage(UIImage(systemName: "star.fill"), for: .normal)
        let alertController = UIAlertController(title: "收藏成功", message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "确认", style: .default, handler: {
            action in
        })
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func cancelSuccess() {
        btn_star.setImage(UIImage(systemName: "star"), for: .normal)
        let alertController = UIAlertController(title: "取消收藏成功", message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "确认", style: .default, handler: {
            action in
        })
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

