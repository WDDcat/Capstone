//
//  CycleScrollView.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/3/18.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import UIKit

@objc protocol CycleScrollViewDelegate: NSObjectProtocol {
    func cycleImageCount() -> Int
    func cycleImageView(_ imageView: UIImageView, index: Int)
    @objc optional func cycleImageViewClick(_ index: Int)
}

class MyCycleScrollView: UIView, UIScrollViewDelegate {
    private var imageViews = [UIImageView(), UIImageView(), UIImageView()]
    private var scrollView: UIScrollView!
    private var imageCount: Int = 0
    private var timer: Timer? = nil
    private var index: Int = 0
    
    public var currentIndex: Int {
        get {
            return index
        }
        set {
            index = min(newValue, imageCount)
            updateImage()
        }
    }
    
    public var rollingEnable: Bool = false {
        willSet {
            newValue ? startTimer() : stopTimer()
        }
    }
    
    public var duration: TimeInterval = 5.0
    
    public weak var delegate: CycleScrollViewDelegate? {
        didSet {
            if let delegate = delegate {
                imageCount = delegate.cycleImageCount()
                scrollView.isScrollEnabled = imageCount > 1
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        addSubview(scrollView)
        
        for item in imageViews {
            scrollView.addSubview(item)
        }
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(_:))))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if imageViews[0].frame == .zero {
            let width = frame.width, height = frame.height
            scrollView.frame = CGRect(x: 0, y: 0, width: width, height: height)
            scrollView.contentSize = CGSize(width: width * 3, height: height)
            for (i, obj) in imageViews.enumerated() {
                obj.frame = CGRect(x: CGFloat(i) * width, y: 0, width: width, height: height)
            }
            currentIndex = index
        }
    }
    
    @objc private func tap(_ gesture: UITapGestureRecognizer) {
        delegate?.cycleImageViewClick?(currentIndex)
    }
    
    private func updateImage() {
        if (imageCount < 2) {
            delegate?.cycleImageView(imageViews[1], index: index)
        }
        else {
            for (i, index) in [getLast(currentIndex), currentIndex, getNext(currentIndex)].enumerated() {
                delegate?.cycleImageView(imageViews[i], index: index)
            }
        }
        scrollView.contentOffset.x = frame.width
    }
    
    private func startTimer() {
        if imageCount < 2 {
            return
        }
        timer = Timer.scheduledTimer(timeInterval: duration, target: self, selector: #selector(rolling), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: .common)
    }
    
    private func stopTimer() {
        if imageCount < 2 {
            return
        }
        timer?.invalidate()
        timer = nil
    }
    
    @objc private func rolling() {
        scrollView.setContentOffset(CGPoint(x: frame.width * 2, y: 0), animated: true)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if rollingEnable {
            stopTimer()
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if rollingEnable {
            startTimer()
        }
    }
    
    private func getNext(_ current: Int) -> Int {
        let count = imageCount - 1
        if count < 1 {
            return 0
        }
        return current + 1 > count ? 0 : current + 1
    }
    
    private func getLast(_ current: Int) -> Int {
        let count = imageCount - 1
        if count < 1 {
            return 0
        }
        return current - 1 < 0 ? count : current - 1
    }
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
        stopTimer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
