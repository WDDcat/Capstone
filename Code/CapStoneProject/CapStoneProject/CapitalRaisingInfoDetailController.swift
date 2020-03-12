//
//  CapitalRaisingInfoDetailController.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/3/11.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import UIKit
import Charts

class CapitalRaisingInfoDetailController: UIViewController {

    var mPresenter = CapitalRaisingInfoDetailModel()
    
    @IBOutlet weak var label_overview: UILabel!
    //集团
    //1.
    @IBOutlet weak var label_bankCreditInfo: UILabel!
    @IBOutlet weak var stack_bankCreditTable: UIStackView!
    //2.
    @IBOutlet weak var label_bondCapitalRaisingInfo: UILabel!
    @IBOutlet weak var stack_bondCapitalRaisingTable: UIStackView!
    @IBOutlet weak var chart_totalPrice: UIView!
    @IBOutlet weak var chart_priceRate: UIView!
    //3.
    @IBOutlet weak var label_debtInfo: UILabel!
    @IBOutlet weak var stack_debtTable: UIStackView!
    @IBOutlet weak var stack_cashFlowTable: UIStackView!
    //4.
    @IBOutlet weak var label_equityFinancingInfo: UILabel!
    @IBOutlet weak var stack_equityFinancingTable: UIStackView!
    //5.
    @IBOutlet weak var label_assetManagementPlanInfo: UILabel!
    @IBOutlet weak var stack_scrollTrustTable: UIStackView!
    
    
    var totalPriceChartView = LineChartView()
    var priceRateChartView = LineChartView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mPresenter.mView = self
        mPresenter.getInfo()
        
    }
}

extension CapitalRaisingInfoDetailController: CapitalRaisingInfoDetailView {
    //MARK: -文字
    func setGroupCapitalRaisingOverviewInfo(para: String) {
        label_overview.text = para
        label_overview.backgroundColor = .systemBackground
    }
    
    func setGroupCreditInfo(para: String) {
        label_bankCreditInfo.text = para
        label_bankCreditInfo.backgroundColor = .systemBackground
    }
    
    func setBondCapitalRaisingInfo(para: String) {
        label_bondCapitalRaisingInfo.text = para
        label_bondCapitalRaisingInfo.backgroundColor = .systemBackground
    }
    
    func setDebtInfo(para: String) {
        label_debtInfo.text = para
        label_debtInfo.backgroundColor = .systemBackground
    }
    
    func setEquityFinancingInfo(para: String) {
        label_equityFinancingInfo.text = para
        label_equityFinancingInfo.backgroundColor = .systemBackground
    }
    
    func setAssetManagementPlanInfo(para: String) {
        label_assetManagementPlanInfo.text = para
        label_assetManagementPlanInfo.backgroundColor = .systemBackground
    }
    
    //MARK: -表格
    func setCreditTable(dataList: [String]) {
        let title = ["银行名称", "授信额度", "已使用额度", "未使用额度", "币种", "授信到期日"]
        let mTable = MyTable(rootView: stack_bankCreditTable)
        mTable.setColumn(num: 6)
        for i in 0..<title.count {
            mTable.add(title[i])
        }
        for i in 0..<dataList.count {
            mTable.add(dataList[i])
        }
    }
    
    func setBondTable(dataList: [String]) {
        let title = ["债务主体", "发行日期", "发行期限（月）", "发型规模", "主承销商", "种类"]
        let mTable = MyTable(rootView: stack_bondCapitalRaisingTable)
        mTable.setColumn(num: 6)
        for i in 0..<title.count {
            mTable.add(title[i])
        }
        for i in 0..<dataList.count {
            mTable.add(dataList[i])
        }
    }
    
    func setDebtTable(dataList: [String], latestDate: String) {
        let title = ["年份", "2015", "",  "2016", "", "2017", "", latestDate, ""]
        let mTable = MyTable(rootView: stack_debtTable)
        mTable.setColumn(num: 9)
        for i in 0..<title.count {
            mTable.add(title[i])
        }
        mTable.add("")
        for _ in 0..<4 {
            mTable.add("金额")
            mTable.add("占总负债比例")
        }
        for i in 0..<dataList.count {
            mTable.add(dataList[i])
        }
    }
    
    func setCashFlowTable(dataList: [String], latestDate: String) {
        let title = ["年份", "2015",  "2016", "2017", latestDate]
        let mTable = MyTable(rootView: stack_cashFlowTable)
        mTable.setColumn(num: 5)
        for i in 0..<title.count {
            mTable.add(title[i])
        }
        for i in 0..<dataList.count {
            mTable.add(dataList[i])
        }
    }
    
    func setEquityFinancingTable(dataList: [String]) {
        let title = ["上市公司", "上市日期", "发行类型", "上市交易所", "发行股票数量（万股）", "发行价格（元）", "募集资金（亿元）", "主承销商"]
        let mTable = MyTable(rootView: stack_equityFinancingTable)
        mTable.setColumn(num: 8)
        for i in 0..<title.count {
            mTable.add(title[i])
        }
        for i in 0..<dataList.count {
            mTable.add(dataList[i])
        }
    }
    
    //MARK: -滑动表格
    func setTrustTable(dataList: [String]){
        let mScrollTable = MyScrollTable(rootView: stack_scrollTrustTable.superview as! UIScrollView, type: .trust)
        for i in 0..<dataList.count {
            mScrollTable.add(dataList[i])
        }
        mScrollTable.finish()
    }
    
    //MARK: -折线图
    func initTotalPriceChart(valueSize: Int) {
        totalPriceChartView.frame = CGRect(x: 0, y: 0, width: chart_totalPrice.frame.width, height: chart_totalPrice.frame.height)
        chart_totalPrice.addSubview(totalPriceChartView)
        
        totalPriceChartView.chartDescription?.text = "单位，亿元"  //描述信息
        totalPriceChartView.noDataText = ""  //没有数据时显示的文本
        totalPriceChartView.drawBordersEnabled = true  //绘制chart的边线
        totalPriceChartView.borderColor = .gray  //边框颜色
        totalPriceChartView.borderLineWidth = 1  //边框线宽度
        totalPriceChartView.dragEnabled = false  //是否可以拖拽
        totalPriceChartView.scaleXEnabled = true  //x,y轴是否可缩放
        totalPriceChartView.scaleYEnabled = true
        totalPriceChartView.doubleTapToZoomEnabled = false  //双击屏幕放大图表
        
        //图例
        totalPriceChartView.legend.verticalAlignment = Legend.VerticalAlignment.top  //在上中下
        totalPriceChartView.legend.horizontalAlignment = Legend.HorizontalAlignment.right  //在左中右
        totalPriceChartView.legend.orientation = Legend.Orientation.horizontal  //水平排列
        totalPriceChartView.legend.form = Legend.Form.circle  //形状
        totalPriceChartView.legend.wordWrapEnabled = true  //支持自动换行
        
        //x轴
        totalPriceChartView.xAxis.enabled = true  //启用x轴
        totalPriceChartView.xAxis.drawAxisLineEnabled = true  //绘制x轴
        totalPriceChartView.xAxis.drawGridLinesEnabled = true  //每个竖线都显示
        totalPriceChartView.xAxis.drawLabelsEnabled = true  //绘制对应值（标签）
        totalPriceChartView.xAxis.labelPosition = XAxis.LabelPosition.bottom  //位置
        totalPriceChartView.xAxis.setLabelCount(valueSize, force: true)  //标签个数
        
        //左边y轴
        totalPriceChartView.leftAxis.enabled = true
        totalPriceChartView.leftAxis.drawGridLinesEnabled = true
        totalPriceChartView.leftAxis.gridLineDashPhase = 0
        totalPriceChartView.leftAxis.gridLineDashLengths = [10]
        
        //左边y轴
        totalPriceChartView.rightAxis.enabled = true
        totalPriceChartView.rightAxis.drawGridLinesEnabled = true
        totalPriceChartView.rightAxis.gridLineDashPhase = 0
        totalPriceChartView.rightAxis.gridLineDashLengths = [10]
    }
    
    func setTotalPriceChartData(_ yValues1: [ChartDataEntry], _ yValues2: [ChartDataEntry], _ yValues3: [ChartDataEntry], _ yValues4: [ChartDataEntry]) {
        let lineDataSet1 = LineChartDataSet.init(entries: yValues1, label: "-1")
        lineDataSet1.setColor(.init(red: 1, green: 1, blue: 0, alpha: 1))
        let lineDataSet2 = LineChartDataSet.init(entries: yValues2, label: "1-3")
        lineDataSet2.setColor(.init(red: 135/255, green: 206/255, blue: 235/255, alpha: 1))
        let lineDataSet3 = LineChartDataSet.init(entries: yValues3, label: "3-5")
        lineDataSet3.setColor(.init(red: 0, green: 1, blue: 0, alpha: 1))
        let lineDataSet4 = LineChartDataSet.init(entries: yValues4, label: "5-")
        lineDataSet4.setColor(.init(red: 1, green: 0, blue: 0, alpha: 1))
        
        lineDataSet1.highlightEnabled = true
        lineDataSet1.valueTextColor = .init(red: 1, green: 1, blue: 0, alpha: 1)
        lineDataSet1.valueFont = UIFont.systemFont(ofSize: 10)
        lineDataSet1.circleRadius = 3
        lineDataSet1.circleHoleRadius = 1
        lineDataSet2.highlightEnabled = true
        lineDataSet2.valueTextColor = .init(red: 135/255, green: 206/255, blue: 235/255, alpha: 1)
        lineDataSet2.valueFont = UIFont.systemFont(ofSize: 10)
        lineDataSet2.circleRadius = 3
        lineDataSet2.circleHoleRadius = 1
        lineDataSet3.highlightEnabled = true
        lineDataSet3.valueTextColor = .init(red: 0, green: 1, blue: 0, alpha: 1)
        lineDataSet3.valueFont = UIFont.systemFont(ofSize: 10)
        lineDataSet3.circleRadius = 3
        lineDataSet3.circleHoleRadius = 1
        lineDataSet4.highlightEnabled = true
        lineDataSet4.valueTextColor = .init(red: 1, green: 0, blue: 0, alpha: 1)
        lineDataSet4.valueFont = UIFont.systemFont(ofSize: 10)
        lineDataSet4.circleRadius = 3
        lineDataSet4.circleHoleRadius = 1
        
        let data = LineChartData.init(dataSets: [lineDataSet1, lineDataSet2, lineDataSet3, lineDataSet4])
        
        totalPriceChartView.data = data
        totalPriceChartView.animate(xAxisDuration: 1, yAxisDuration: 1)
    }
    
    func initPriceRateChart(valueSize: Int) {
        priceRateChartView.frame = CGRect(x: 0, y: 0, width: chart_priceRate.frame.width, height: chart_priceRate.frame.height)
        chart_priceRate.addSubview(priceRateChartView)
        
        priceRateChartView.chartDescription?.text = "单位，亿元"  //描述信息
        priceRateChartView.noDataText = ""  //没有数据时显示的文本
        priceRateChartView.drawBordersEnabled = true  //绘制chart的边线
        priceRateChartView.borderColor = .gray  //边框颜色
        priceRateChartView.borderLineWidth = 1  //边框线宽度
        priceRateChartView.dragEnabled = false  //是否可以拖拽
        priceRateChartView.scaleXEnabled = true  //x,y轴是否可缩放
        priceRateChartView.scaleYEnabled = true
        priceRateChartView.doubleTapToZoomEnabled = false  //双击屏幕放大图表
        
        //图例
        priceRateChartView.legend.verticalAlignment = Legend.VerticalAlignment.top  //在上中下
        priceRateChartView.legend.horizontalAlignment = Legend.HorizontalAlignment.right  //在左中右
        priceRateChartView.legend.orientation = Legend.Orientation.horizontal  //水平排列
        priceRateChartView.legend.form = Legend.Form.circle  //形状
        priceRateChartView.legend.wordWrapEnabled = true  //支持自动换行
        
        //x轴
        priceRateChartView.xAxis.enabled = true  //启用x轴
        priceRateChartView.xAxis.drawAxisLineEnabled = true  //绘制x轴
        priceRateChartView.xAxis.drawGridLinesEnabled = true  //每个竖线都显示
        priceRateChartView.xAxis.drawLabelsEnabled = true  //绘制对应值（标签）
        priceRateChartView.xAxis.labelPosition = XAxis.LabelPosition.bottom  //位置
        priceRateChartView.xAxis.setLabelCount(valueSize, force: true)  //标签个数
        
        //左边y轴
        priceRateChartView.leftAxis.enabled = true
        priceRateChartView.leftAxis.drawGridLinesEnabled = true
        priceRateChartView.leftAxis.gridLineDashPhase = 0
        priceRateChartView.leftAxis.gridLineDashLengths = [10]
        
        //左边y轴
        priceRateChartView.rightAxis.enabled = true
        priceRateChartView.rightAxis.drawGridLinesEnabled = true
        priceRateChartView.rightAxis.gridLineDashPhase = 0
        priceRateChartView.rightAxis.gridLineDashLengths = [10]
    }
    
    func setPriceRateChartData(_ yValues1: [ChartDataEntry], _ yValues2: [ChartDataEntry], _ yValues3: [ChartDataEntry], _ yValues4: [ChartDataEntry]) {
        let lineDataSet1 = LineChartDataSet.init(entries: yValues1, label: "-1")
        lineDataSet1.setColor(.init(red: 1, green: 1, blue: 0, alpha: 1))
        let lineDataSet2 = LineChartDataSet.init(entries: yValues2, label: "1-3")
        lineDataSet2.setColor(.init(red: 135/255, green: 206/255, blue: 235/255, alpha: 1))
        let lineDataSet3 = LineChartDataSet.init(entries: yValues3, label: "3-5")
        lineDataSet3.setColor(.init(red: 0, green: 1, blue: 0, alpha: 1))
        let lineDataSet4 = LineChartDataSet.init(entries: yValues4, label: "5-")
        lineDataSet4.setColor(.init(red: 1, green: 0, blue: 0, alpha: 1))
        
        lineDataSet1.highlightEnabled = true
        lineDataSet1.valueTextColor = .init(red: 1, green: 1, blue: 0, alpha: 1)
        lineDataSet1.valueFont = UIFont.systemFont(ofSize: 10)
        lineDataSet1.circleRadius = 3
        lineDataSet1.circleHoleRadius = 1
        lineDataSet2.highlightEnabled = true
        lineDataSet2.valueTextColor = .init(red: 135/255, green: 206/255, blue: 235/255, alpha: 1)
        lineDataSet2.valueFont = UIFont.systemFont(ofSize: 10)
        lineDataSet2.circleRadius = 3
        lineDataSet2.circleHoleRadius = 1
        lineDataSet3.highlightEnabled = true
        lineDataSet3.valueTextColor = .init(red: 0, green: 1, blue: 0, alpha: 1)
        lineDataSet3.valueFont = UIFont.systemFont(ofSize: 10)
        lineDataSet3.circleRadius = 3
        lineDataSet3.circleHoleRadius = 1
        lineDataSet4.highlightEnabled = true
        lineDataSet4.valueTextColor = .init(red: 1, green: 0, blue: 0, alpha: 1)
        lineDataSet4.valueFont = UIFont.systemFont(ofSize: 10)
        lineDataSet4.circleRadius = 3
        lineDataSet4.circleHoleRadius = 1
        
        let data = LineChartData.init(dataSets: [lineDataSet1, lineDataSet2, lineDataSet3, lineDataSet4])
        
        priceRateChartView.data = data
        priceRateChartView.animate(xAxisDuration: 1, yAxisDuration: 1)
    }
}
