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
    
    @IBOutlet weak var rootView: UIView!
    
    private var currentViewHeight: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCompanyName(name: remoteGetCompanyName())
        mPresenter.mView = self
        mPresenter.getInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.barTintColor = .red
        navigationController?.navigationBar.tintColor = .lightGray
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.barTintColor = .systemBackground
        navigationController?.navigationBar.tintColor = .systemRed
    }
}

extension OpportunityAbstractController: OpportunityAbstractView {
    func setCompanyName(name: String) {
        navigationController?.title = "\(name)"
    }
    
    func setTitle(title: String) {
        let titleView = UIView()
        
        let detail = UILabel()
        detail.text = "详情"
        detail.textColor = .red
        detail.font = .systemFont(ofSize: 15)
        detail.frame = CGRect(x: 8, y: currentViewHeight + 22.5, width: UIScreen.main.bounds.width - 16, height: 18)
        detail.textAlignment = .right
        titleView.addSubview(detail)
        
        let rectangle = UILabel()
        rectangle.backgroundColor = .red
        rectangle.text = " "
        rectangle.frame = CGRect(x: 8, y: currentViewHeight + 20, width: 4.5, height: 20.5)
        titleView.addSubview(rectangle)
        
        let text = UILabel()
        text.text = title
        text.textColor = .label
        text.font = .systemFont(ofSize: 17)
        text.frame = CGRect(x: 16.5, y: currentViewHeight + 20, width: UIScreen.main.bounds.width - 24.5, height: 20.5)
        titleView.addSubview(text)
        
        let line = UIView()
        line.backgroundColor = .lightGray
        line.frame = CGRect(x: 8, y: currentViewHeight + 45.5, width: UIScreen.main.bounds.width - 16, height: 2)
        titleView.addSubview(line)
        
        rootView.addSubview(titleView)
        currentViewHeight += 47.5
        rootView.frame.size = CGSize(width: UIScreen.main.bounds.width, height: currentViewHeight)
    }
    
    func setParagraph(para: String) {
        let text = UILabel()
        text.text = para
        text.textColor = .label
        text.font = .systemFont(ofSize: 17)
        text.numberOfLines = 0
        let maxSize = CGSize(width: UIScreen.main.bounds.width - 16, height: 9999)
        let realSize = text.sizeThatFits(maxSize)
        text.frame = CGRect(x: 8, y: currentViewHeight + 8, width: UIScreen.main.bounds.width - 16, height: realSize.height)
        
        rootView.addSubview(text)
        currentViewHeight += realSize.height
        rootView.frame.size = CGSize(width: UIScreen.main.bounds.width, height: currentViewHeight)
    }
}
