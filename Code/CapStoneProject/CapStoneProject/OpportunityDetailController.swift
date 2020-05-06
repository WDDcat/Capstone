//
//  OpportunityDetailController.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/3/15.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import UIKit

private let lightGray = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)

class OpportunityDetailController: UIViewController {

    var mPresenter = OpportunityDetailModel()

    @IBOutlet weak var scrollView: UIScrollView!
    
    private var currentViewHeight: CGFloat = 0
    private let rootView = UIStackView()
    private var columnNum = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mPresenter.mView = self
        mPresenter.getInfo()
        switch remoteGetOpportunityFirstLevel() {
        case "existing_financing_chance":
            setCompanyName("存量融资机会")
        case "additional_financing_chance":
            setCompanyName("增量融资机会")
        case "commitment_optimization_chance":
            setCompanyName("期限优化机会")
        case "cost_optimization_chance":
            setCompanyName("成本优化机会")
        case "financial_structure_optimization_chance":
            setCompanyName("财报结构优化机会")
        default:
            setCompanyName("\(remoteGetCompanyName())商机")
        }
        print(remoteGetOpportunityFirstLevel())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.addSubview(homeButton)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        homeButton.removeFromSuperview()
    }
}

extension OpportunityDetailController: OpportunityDetailView {
    func setCompanyName(_ name: String) {
        title = name
    }
    
    func setTitle(title: String) {
        let titleView = UIView()
        
        let rectangle = UILabel()
        rectangle.backgroundColor = .red
        rectangle.text = " "
        rectangle.frame = CGRect(x: 8, y: currentViewHeight + 20, width: 4.5, height: 21)
        titleView.addSubview(rectangle)
        
        let text = UILabel()
        text.text = title
        text.textColor = .label
        text.font = .systemFont(ofSize: 17)
        text.frame = CGRect(x: 16.5, y: currentViewHeight + 20, width: UIScreen.main.bounds.width - 32.5, height: 21)
        titleView.addSubview(text)
        
        rootView.addArrangedSubview(titleView)
        currentViewHeight += 41
    }
    
    func setParagraph(para: String) {
        let paragraphView = UIView()
        
        let text = UILabel()
        text.text = para
        text.textColor = .gray
        text.font = .systemFont(ofSize: 17)
        text.numberOfLines = 0
        let maxSize = CGSize(width: UIScreen.main.bounds.width - 16, height: 9999)
        let realSize = text.sizeThatFits(maxSize)
        text.frame = CGRect(x: 8, y: currentViewHeight + 8, width: UIScreen.main.bounds.width - 16, height: realSize.height)
        
        paragraphView.addSubview(text)
        
        rootView.addArrangedSubview(paragraphView)
        currentViewHeight += realSize.height
    }
    
    func setPartEnd() {
        let line = UIView()
        line.backgroundColor = lightGray
        line.frame = CGRect(x: 8, y: currentViewHeight + 16, width: UIScreen.main.bounds.width - 16, height: 2)
        rootView.addSubview(line)
        currentViewHeight += 18
    }
    
    func setTableColumn(column: Int) {
        self.columnNum = column
    }
    
    func setTable(dataList: [String]) {
        let tableView = UIView()
        
        let table = UIStackView()
        table.axis = .vertical
        table.distribution = .fill
        let mTable = MyTable(rootView: table)
        mTable.setColumn(num: columnNum)
        for i in 0..<dataList.count {
            mTable.add(dataList[i])
        }
        
        table.frame = CGRect(x: 8, y: currentViewHeight + 16, width: UIScreen.main.bounds.width - 16, height: mTable.getHeight())
        
        tableView.addSubview(table)
        
        rootView.addArrangedSubview(tableView)
        currentViewHeight += mTable.getHeight() + 16
    }
    
    func finishSetting() {
        let footView = UIView()
        footView.frame.size = CGSize(width: UIScreen.main.bounds.width, height: 30)
        rootView.addArrangedSubview(footView)
        rootView.frame.size = CGSize(width: UIScreen.main.bounds.width, height: currentViewHeight + 30)
        scrollView.addSubview(rootView)
        scrollView.contentSize = rootView.frame.size
    }
}

