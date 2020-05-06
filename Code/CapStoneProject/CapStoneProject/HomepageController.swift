//
//  HomepageController.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/3/18.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import UIKit

public var homeButton = UIButton()

class HomepageController: UIViewController, CycleScrollViewDelegate {

    var mPresenter = HomepageModel()
    
    @IBOutlet weak var view_cycleView: UIView!
    
    @IBAction func button(_ sender: UIButton) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "LoginPage") as! LoginPageController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    var images: [String] = ["img_homepage1", "img_homepage2", "img_homepage3"]
    var cycleView: MyCycleScrollView!
    var icon = UIImageView()
    var message = UIButton()
    var searchBar = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mPresenter.mView = self
        
        cycleView = MyCycleScrollView(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width - 60, height: view_cycleView.frame.height))
        cycleView.delegate = self
        cycleView.rollingEnable = true
        view_cycleView.addSubview(cycleView)
        
        view_cycleView.layer.masksToBounds = true
        view_cycleView.layer.cornerRadius = 10
        view_cycleView.layer.masksToBounds = false
        view_cycleView.layer.shadowColor = UIColor.gray.cgColor
        view_cycleView.layer.shadowOpacity = 1
        view_cycleView.layer.shadowRadius = 10
        view_cycleView.layer.shadowOffset = CGSize(width: 2, height: 2)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = .systemRed

        icon = UIImageView(frame: CGRect(x: 0, y: 5, width: 100, height: 30))
        icon.image = UIImage(named: "HomepageIcon")
        icon.contentMode = .scaleAspectFit
        
        message = UIButton(frame: CGRect(x: UIScreen.main.bounds.width - 50, y: 5, width: 40, height: 30))
        message.tintColor = .white
        message.setBackgroundImage(UIImage.init(systemName: "envelope.fill"), for: .normal)
        message.contentMode = .scaleAspectFit
        message.isUserInteractionEnabled = true
        message.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickMessage)))
        
        searchBar = UITextField(frame: CGRect(x: 100, y: 5, width: UIScreen.main.bounds.width - 160, height: 30))
        searchBar.layer.cornerRadius = 14
        searchBar.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        searchBar.attributedPlaceholder = NSAttributedString.init(string: "  请输入企业名称", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        searchBar.isUserInteractionEnabled = true
        searchBar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickSearchBar)))

        homeButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.width - 40, y: 5, width: 35, height: 30))
        homeButton.tintColor = .lightGray
        homeButton.setBackgroundImage(UIImage.init(systemName: "house"), for: .normal)
        homeButton.contentMode = .scaleAspectFit
        homeButton.isUserInteractionEnabled = true
        homeButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickHomeButton)))
        
        navigationController?.navigationBar.addSubview(icon)
        navigationController?.navigationBar.addSubview(message)
        navigationController?.navigationBar.addSubview(searchBar)
        navigationController?.navigationItem.rightBarButtonItem?.tintColor = .white
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        icon.removeFromSuperview()
        message.removeFromSuperview()
        searchBar.removeFromSuperview()
        
        self.navigationController?.navigationBar.barTintColor = .systemBackground
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = .systemRed
    }

    func cycleImageCount() -> Int {
        return images.count
    }
    
    func cycleImageView(_ imageView: UIImageView, index: Int) {
        imageView.image = UIImage(named: images[index])
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.backgroundColor = .none
    }
    
    @objc func clickMessage() {
        if userDefaults.bool(forKey: "login_status") {
            print("already login")
            let controller = storyboard?.instantiateViewController(withIdentifier: "PersonalCenter") as! PersonalCenterController
            self.navigationController?.pushViewController(controller, animated: true)
        }
        else {
            let controller = storyboard?.instantiateViewController(withIdentifier: "LoginPage") as! LoginPageController
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @objc func clickSearchBar() {
        let controller = storyboard?.instantiateViewController(withIdentifier: "SearchPage") as! SearchPageController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func clickHomeButton() {
        self.navigationController?.popToRootViewController(animated: true)
    }
}

extension HomepageController: HomepageView {
    
}
