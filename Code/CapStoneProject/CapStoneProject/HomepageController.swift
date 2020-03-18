//
//  HomepageController.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/3/18.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import UIKit

class HomepageController: UIViewController, CycleScrollViewDelegate {

    var mPresenter = HomepageModel()
    
    @IBOutlet weak var view_cycleView: UIView!
    @IBAction func textField(_ sender: Any) {
        
    }
    
    var images: [String] = ["img_homepage1", "img_homepage2", "img_homepage3"]
    var cycleView: MyCycleScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mPresenter.mView = self
        cycleView = MyCycleScrollView(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width - 60, height: view_cycleView.frame.height))
        cycleView.delegate = self
        cycleView.rollingEnable = true
        view_cycleView.addSubview(cycleView)
        
        view_cycleView.layer.masksToBounds = true
        view_cycleView.layer.cornerRadius = 10
    }

    func cycleImageCount() -> Int {
        return images.count
    }
    
    func cycleImageView(_ imageView: UIImageView, index: Int) {
        imageView.image = UIImage(named: images[index])
    }
}

extension HomepageController: HomepageView {
    
}
