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
        setCompanyName(name: remoteGetCompanyName())
        mPresenter.mView = self
        mPresenter.getInfo()
        print(remoteGetOpportunityFirstLevel())
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

extension OpportunityDetailController: OpportunityDetailView {
    func setCompanyName(name: String) {
        title = "\(name)商机"
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
        let table = UIStackView()
        table.axis = .vertical
        table.distribution = .equalSpacing
        let mTable = MyTable(rootView: table)
        mTable.setColumn(num: columnNum)
        for i in 0..<dataList.count {
            mTable.add(dataList[i])
        }
        
        rootView.addArrangedSubview(table)
        
//        table.
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

