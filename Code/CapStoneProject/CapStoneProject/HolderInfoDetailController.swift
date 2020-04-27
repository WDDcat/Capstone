//
//  HolderInfoDetailController.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/3/4.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import UIKit
import Charts

var holderInfoPieChartEntry: [PieChartDataEntry] = []

class HolderInfoDetailController: UIViewController {

    var mPresenter = HolderInfoDetailModel()
    
    @IBOutlet weak var baseScrollView: UIScrollView!
    @IBOutlet weak var label_firstHolder: UILabel!
    @IBOutlet weak var label_hodlerName: UILabel!
    @IBOutlet weak var label_stockList: UILabel!
    @IBOutlet weak var view_pieChart: UIView!
    
    var pieChartView = PieChartView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mPresenter.mView = self
        holderInfoPieChartEntry.removeAll()
        mPresenter.getInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.baseScrollView.contentSize = CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height + 70)
    }
}

extension HolderInfoDetailController: HolderInfoDetailView {    
    func setHolderName(name: String) {
        label_firstHolder.text = name
        label_firstHolder.backgroundColor = .systemBackground
        label_hodlerName.text = name
    }
    
    func setStockCode(codes: [String]) {
        var codeString: String = ""
        for i in 0..<codes.count {
            if i == codes.count - 1 {
                codeString += codes[i]
            } else {
                codeString += "\(codes[i])\n"
            }
        }
        label_stockList.text = codeString
    }
    
    func setPieChartData() {
        pieChartView.frame = CGRect(x: 0, y: 0, width: view_pieChart.frame.width, height: view_pieChart.frame.height)
        view_pieChart.addSubview(pieChartView)

        pieChartView.usePercentValuesEnabled = true //是否使用百分比
        pieChartView.setExtraOffsets(left: 20, top: 5, right: 20, bottom: 10) //上下左右距离
        pieChartView.dragDecelerationEnabled = false //开关拖拽效果
        pieChartView.drawEntryLabelsEnabled = false //区块内是否显示文本
        pieChartView.drawHoleEnabled = true //是否是空心的
        pieChartView.holeRadiusPercent = 0.5 //空心半径比例
        pieChartView.transparentCircleRadiusPercent = 46 //圆环半径
        pieChartView.drawCenterTextEnabled = true //中心文字
        pieChartView.centerText = "股东占比"
        pieChartView.rotationEnabled = false //是否可以旋转
        pieChartView.rotationAngle = 20 //旋转度数

        //比例块
        pieChartView.legend.formSize = 12 //字体
        pieChartView.legend.wordWrapEnabled = true
        pieChartView.legend.direction = Legend.Direction.leftToRight
        pieChartView.legend.textColor = .black

        pieChartView.legend.maxSizePercent = 1 //图例占比

        let dataSet = PieChartDataSet(entries: holderInfoPieChartEntry, label: "")
        dataSet.colors = ChartColorTemplates.vordiplom()
        dataSet.sliceSpace = 3
        dataSet.selectionShift = 1 //选中放大半径

        //折线
        dataSet.valueLinePart1OffsetPercentage = 0.8
        dataSet.valueLinePart1Length = 0.3
        dataSet.valueLinePart2Length = 0.4
        dataSet.valueLineWidth = 1
        dataSet.valueLineColor = .black
        dataSet.yValuePosition = PieChartDataSet.ValuePosition.outsideSlice

        let data = PieChartData.init(dataSets: [dataSet])
        data.setValueFormatter(PercentFormatter.init())
        data.setValueFont(UIFont.systemFont(ofSize: 10))
        data.setValueTextColor(.black)
//
        pieChartView.data = data
        pieChartView.highlightValue(nil)
    }
}

