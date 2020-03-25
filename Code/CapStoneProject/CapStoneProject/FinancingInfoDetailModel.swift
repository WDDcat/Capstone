//
//  FinancingInfoDetailModel.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/3/9.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class FinancingInfoDetailModel: FinancingInfoDetailPresent {
    
    var mView: FinancingInfoDetailView?
    
    func getInfo() {
        let param:[String:Any] = ["c_id": remoteGetCompanyId(), "time": 2017]
        Alamofire.request(URL(string :"\(BASEURL)financialstatement")!, parameters: param, headers: getHeader())
            .responseJSON { response in
                switch response.result.isSuccess{
                case true:
                    if let data = response.result.value {
                        let json = JSON(data)
                        //MARK: -概述
                        var summaryString: String = ""
                        if json["is_a_h"].int ?? 0 == 1 {
                            if json["net_profit"].double ?? 0 == 0 {
                                summaryString = "该公司暂无公开财务情况"
                            }
                            else {
                                summaryString = "截止\(json["year"])，公司总资产\(unitFormat(json["sum_asset"].double ?? 0))元，"
                                summaryString += "总负债\(unitFormat(json["sum_debt"].double ?? 0))元，"
                                summaryString += "所有者权益\(unitFormat(json["sum_owners_equity"].double ?? 0))元，"
                                summaryString += "资产负债率 \(unitFormat(json["asset_debt_ratio"].string ?? ""))。"
                                summaryString += "\(json["year"])实现营业收入\(unitFormat(json["operate_rev"].double ?? 0))元，"
                                if (json["operate_rev_YOY"].string ?? "").contains("-") {
                                    summaryString += "同比减少\(((json["operate_rev_YOY"].string ?? "-") as NSString).substring(from: 1))，"
                                } else {
                                    summaryString += "同比增长\(json["operate_rev_YOY"])，"
                                }
                                summaryString += "实现净润\(unitFormat(json["net_profit"].double ?? 0))元，"
                                if (json["net_profit_YOY"].string ?? "").contains("-") {
                                    summaryString += "同比减少\(((json["net_profit_YOY"].string ?? "-") as NSString).substring(from: 1))。"
                                } else {
                                    summaryString += "同比增长\(json["net_profit_YOY"])。"
                                }
                            }
                        }
                        else {
                            if json["net_profit"].double ?? 0 == 0 {
                                summaryString = "该公司暂无公开财务情况"
                            }
                            else {
                                summaryString = "截止\(json["year"])，公司总资产\(unitFormat(json["sum_asset"].double ?? 0))元，"
                                summaryString += "总负债\(unitFormat(json["sum_debt"].double ?? 0))亿元，"
                                summaryString += "所有者权益\(unitFormat(json["sum_owners_equity"].double ?? 0))亿元，"
                                summaryString += "资产负债率 \(unitFormat(json["asset_debt_ratio"].string ?? ""))。"
                                summaryString += "\(json["year"])实现营业收入\(unitFormat(json["operate_rev"].double ?? 0))亿元，"
                                if (json["operate_rev_YOY"].string ?? "").contains("-") {
                                    summaryString += "同比减少\(((json["operate_rev_YOY"].string ?? "-") as NSString).substring(from: 1))，"
                                } else {
                                    summaryString += "同比增长\(json["operate_rev_YOY"])，"
                                }
                                summaryString += "实现净润\(unitFormat(json["net_profit"].double ?? 0))亿元，"
                                if (json["net_profit_YOY"].string ?? "").contains("-") {
                                    summaryString += "同比减少\(((json["net_profit_YOY"].string ?? "-") as NSString).substring(from: 1))。"
                                } else {
                                    summaryString += "同比增长\(json["net_profit_YOY"])。"
                                }
                            }
                        }
                        self.mView?.setTopSummary(para: summaryString)
                        
                        //MARK: -表格介绍
                        var preListString: String = ""
                        if json["is_a_h"].int ?? 0 == 1 {
                            let year: Int = json["statement_2_year"].count
                            if year != 0 && (json["statement_last"]["date"].string ?? "") != "" { //最新一期和最近三年都有数据
                                preListString = "\(json["name"])提供的\(((json["statement_2_year"][year - 1]["date"].string ?? "    ") as NSString).substring(to: 4).replacingOccurrences(of: "    ", with: "-"))-\(((json["statement_last"]["date"].string ?? "    ") as NSString).substring(to: 4).replacingOccurrences(of: "    ", with: "-"))年合并报表，具体情况如下表："
                            }
                            else if year != 0 { //最近三年有数据，最新一期没数据
                                preListString = "\(json["name"])提供的\(((json["statement_2_year"][year - 1]["date"].string ?? "    ") as NSString).substring(to: 4).replacingOccurrences(of: "    ", with: "-"))-\(((json["statement_2_year"][0]["date"].string ?? "    ") as NSString).substring(to: 4).replacingOccurrences(of: "    ", with: "-"))年合并报表，具体情况如下表："
                            }
                        }
                        else {
                            let year: Int = json["statement_2_year"].count
                            if year != 0 && (json["statement_last"]["report_date"].string ?? "") != "" {
                                preListString = "\(json["name"])提供的\(((json["statement_2_year"][year - 1]["report_date"].string ?? "    ") as NSString).substring(to: 4).replacingOccurrences(of: "    ", with: "-"))-\(((json["statement_last"]["report_date"].string ?? "    ") as NSString).substring(to: 4).replacingOccurrences(of: "    ", with: "-"))年合并报表，具体情况如下表："
                            }
                            else if year != 0 { //最近三年有数据，最新一期没数据
                                preListString = "\(json["name"])提供的\(((json["statement_2_year"][year - 1]["report_date"].string ?? "    ") as NSString).substring(to: 4).replacingOccurrences(of: "    ", with: "-"))-\(((json["statement_2_year"][0]["report_date"].string ?? "    ") as NSString).substring(to: 4).replacingOccurrences(of: "    ", with: "-"))年合并报表，具体情况如下表："
                            }
                        }
                        self.mView?.setPreList(para: preListString)
                        
                        //MARK: -表格下方提示
                        var attentionString: String = ""
                        if preListString == "" {
                            attentionString = ""
                        }
                        else {
                            attentionString = "注：\n1.本表中的行业平均值以国资委统计评价局制定的《企业绩效评价标准2018》为准，各年度指标计算方法与该书相应指标的计算方法保持一致。"
                            if json["industry"].string ?? "" != "" {
                                attentionString += "\n2.本表中的行业平均值为\(json["industry"])平均值。\n"
                            }
                        }
                        self.mView?.setAttention(para: attentionString)
                        
                        //MARK: -表格
                        var dataList: [String] = []
                        var columnNum = 0
                        let year: Int = json["statement_2_year"].count
                        if json["is_a_h"].int ?? 0 == 1 { //非港股
                            if (json["statement_last"]["date"].string ?? "") != "" {
                                self.mView?.setChartColumn(col: year + 3)
                                columnNum = year + 3
                            }
                            else {
                                self.mView?.setChartColumn(col: year + 2)
                                columnNum = year + 2
                            }
                            if year == 0 && (json["statement_last"]["date"].string ?? "") == "" {
                                dataList.append("")
                            }
                            else {
                                dataList.append("科目")
                                for i in (0..<json["statement_2_year"].count).reversed() {
                                    var dateString: NSString = (json["statement_2_year"][i]["date"].string ?? "    -  -  ") as NSString
                                    var date = "\(dateString.substring(to: 4).replacingOccurrences(of: "    ", with: "-"))年"
                                    dateString = dateString.substring(from: 5) as NSString
                                    date += "\(dateString.substring(to: 2).replacingOccurrences(of: "  ", with: "-"))月"
                                    dataList.append(date)
                                }
                                if (json["statement_last"]["date"].string ?? "") != "" {
                                    var dateString: NSString = (json["statement_last"]["date"].string ?? "    -  -  ") as NSString
                                    var date = "\(dateString.substring(to: 4).replacingOccurrences(of: "    ", with: "-"))年"
                                    dateString = dateString.substring(from: 5) as NSString
                                    date += "\(dateString.substring(to: 2).replacingOccurrences(of: "  ", with: "-"))月"
                                    dataList.append(date)
                                }
                                dataList.append("行业平均值")
                                
                                var itemList: [String] = []
                                for i in (0..<json["statement_2_year"].count).reversed() {
                                    let stateJSON = json["statement_2_year"][i]
                                    itemList.append(unitFormat(stateJSON["sum_asset"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["curr_asset"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["monetary_fund"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["account_rec"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["other_rec"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["advance_pay"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["inventory"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["sum_non_curr_ass"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["fixed_ass"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["constructiong_project"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["lt_equity_inv"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["intangble_ass"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["sum_liab"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["sum_curr_liab"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["st_borrow"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["bill_pay"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["account_pay"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["advance_rec"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["other_pay"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["non_curr_liab_one_year"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["sum_non_liab"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["lt_borrow"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["bond_pay"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["lt_account_pay"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["sum_she_equity"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["sum_parent_equity"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["operate_rev"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["operate_exp"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["operate_tax"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["sale_exp"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["manage_exp"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["fin_exp"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["operate_profit"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["sum_profit"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["net_profit"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["parent_net_profit"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["net_operate_cash_flow"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["net_inv_cash_flow"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["net_fin_cash_flow"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["net_cash_flow"].double ?? 0))
                                    itemList.append(stateJSON["asset_debt_ratio"].string ?? "-")
                                    itemList.append(stateJSON["current_ratio"].string ?? "-")
                                    itemList.append(stateJSON["quick_ratio"].string ?? "-")
                                    itemList.append(stateJSON["account_rec_turnover"].string ?? "-")
                                    itemList.append(stateJSON["inventory_turnover"].string ?? "-")
                                    itemList.append(stateJSON["total_asset_turnover"].string ?? "-")
                                    itemList.append(stateJSON["main_business_profit_ratio"].string ?? "-")
                                    itemList.append(stateJSON["net_asset_return_ratio"].string ?? "-")
                                    itemList.append(stateJSON["total_asset_return_ratio"].string ?? "-")
                                    itemList.append(stateJSON["business_growth_rate"].string ?? "-")
                                    itemList.append(stateJSON["total_asset_growth_rate"].string ?? "-")
                                    itemList.append(stateJSON["net_profit_growth_rate"].string ?? "-")
                                }
                                //MARK: -近一年
                                if (json["statement_last"]["date"].string ?? "") != "" {
                                    let stateJSON = json["statement_last"]
                                    itemList.append(unitFormat(stateJSON["sum_asset"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["curr_asset"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["monetary_fund"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["account_rec"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["other_rec"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["advance_pay"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["inventory"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["sum_non_curr_ass"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["fixed_ass"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["constructiong_project"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["lt_equity_inv"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["intangble_ass"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["sum_liab"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["sum_curr_liab"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["st_borrow"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["bill_pay"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["account_pay"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["advance_rec"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["other_pay"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["non_curr_liab_one_year"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["sum_non_liab"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["lt_borrow"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["bond_pay"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["lt_account_pay"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["sum_she_equity"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["sum_parent_equity"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["operate_rev"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["operate_exp"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["operate_tax"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["sale_exp"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["manage_exp"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["fin_exp"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["operate_profit"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["sum_profit"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["net_profit"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["parent_net_profit"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["net_operate_cash_flow"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["net_inv_cash_flow"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["net_fin_cash_flow"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["net_cash_flow"].double ?? 0))
                                    itemList.append(stateJSON["asset_debt_ratio"].string ?? "-")
                                    itemList.append(stateJSON["current_ratio"].string ?? "-")
                                    itemList.append(stateJSON["quick_ratio"].string ?? "-")
                                    itemList.append(stateJSON["account_rec_turnover"].string ?? "-")
                                    itemList.append(stateJSON["inventory_turnover"].string ?? "-")
                                    itemList.append(stateJSON["total_asset_turnover"].string ?? "-")
                                    itemList.append(stateJSON["main_business_profit_ratio"].string ?? "-")
                                    itemList.append(stateJSON["net_asset_return_ratio"].string ?? "-")
                                    itemList.append(stateJSON["total_asset_return_ratio"].string ?? "-")
                                    itemList.append(stateJSON["business_growth_rate"].string ?? "-")
                                    itemList.append(stateJSON["total_asset_growth_rate"].string ?? "-")
                                    itemList.append(stateJSON["net_profit_growth_rate"].string ?? "-")
                                }
                                //MARK: -行业平均值
                                for _ in 0..<40 {
                                    itemList.append("-")
                                }
                                if json["industry_avg_info"]["info"]["indexs"].count != 0 {
                                    let indexsJSON = json["industry_avg_info"]["info"]["indexs"]
                                    itemList.append(unitFormat(indexsJSON[11][3].double ?? 0))
                                    itemList.append("-")
                                    itemList.append(unitFormat(indexsJSON[13][3].double ?? 0))
                                    itemList.append(unitFormat(indexsJSON[7][3].double ?? 0))
                                    itemList.append(unitFormat(indexsJSON[22][3].double ?? 0))
                                    itemList.append(unitFormat(indexsJSON[6][3].double ?? 0))
                                    itemList.append(unitFormat(indexsJSON[2][3].double ?? 0))
                                    itemList.append(unitFormat(indexsJSON[1][3].double ?? 0))
                                    itemList.append(unitFormat(indexsJSON[0][3].double ?? 0))
                                    itemList.append(unitFormat(indexsJSON[17][3].double ?? 0))
                                    itemList.append(unitFormat(indexsJSON[20][3].double ?? 0))
                                    itemList.append(unitFormat(indexsJSON[19][3].double ?? 0))
                                }
                                else {
                                    for _ in 0..<12 {
                                        itemList.append("-")
                                    }
                                }
                                
                                let titleList = ["资产总额", "流动资产", "货币资金", "应收账款", "其他应收账款", "预付账款", "存货", "非流动资产", "固定资产", "在建工程", "长期股权投资", "无形资产", "负债总额", "流动负债", "短期借款", "应付票据", "应付账款", "预收账款", "其他应付账款", "一年内到期非流动负债", "非流动负债", "长期借款", "应付债券", "长期应付债券", "所有者权益", "母公司所有者权益", "主营业收入", "主营业成本", "税金及附加", "销售费用", "管理费用", "财务费用", "营业利润", "利润总额", "净利润", "归属母公司的净利润", "经营性现金净流量", "投资性现金净流量", "筹资性现金净流量", "现金净流量", "资产负债率", "流动比率", "速动比率", "应收账款周转率", "存货周转率", "总资产周转率", "主营业务利润", "净资产收益率", "总资产报酬率", "营业增长率", "总资产增长率", "净利润增长率"]
                                var k = 0
                                for i in 0..<titleList.count {
                                    for j in 0..<2 {
                                        if j == 0 {
                                            dataList.append(titleList[i])
                                        }
                                        else {
                                            if k < titleList.count {
                                                for t in 0..<(columnNum - 1) {
                                                    dataList.append(itemList[k + titleList.count * t])
                                                }
                                                k += 1
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        else { //港股
                            if (json["statement_last"]["report_date"].string ?? "") != "" {
                                self.mView?.setChartColumn(col: year + 3)
                                columnNum = year + 3
                            }
                            else {
                                self.mView?.setChartColumn(col: year + 2)
                                columnNum = year + 2
                            }
                            if year == 0 && (json["statement_last"]["date"].string ?? "") == "" {
                                dataList.append("")
                            }
                            else {
                                dataList.append("科目")
                                for i in (0..<json["statement_2_year"].count).reversed() {
                                    dataList.append(json["statement_2_year"][i]["date"].string ?? "-")
                                }
                                if (json["statement_last"]["date"].string ?? "") != "" {
                                    dataList.append(json["statement_last"]["date"].string ?? "")
                                }
                                dataList.append("行业平均值")

                                var itemList: [String] = []
                                for i in (0..<json["statement_2_year"].count).reversed() {
                                    let stateJSON = json["statement_2_year"][i]
                                    itemList.append(unitFormat(stateJSON["b_id"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["cash_equ"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["tran_fin_ass"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["other_short_term_ass"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["account_rec"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["other_rec"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["inventory"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["other_curr_ass"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["sum_curr_ass"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["fixed_ass_net"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["inv_property"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["constructiong_project"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["other_fixed_ass"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["equity_inv"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["hold_maturity_inv"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["saled_inv"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["other_long_term_inv"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["goodwill_intangl_ass"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["other_non_curr_ass"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["sum_non_curr_ass"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["sum_ass"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["account_pay"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["tran_fin_liab"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["expire_liab"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["other_curr_liab"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["lt_borrow"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["other_non_liab"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["sum_non_liab"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["sum_liab"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["equity"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["pre_stock"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["sum_she_equity"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["sum_liab_equity"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["net_profit"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["depre_amort"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["oper_capital_change"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["other_non_cash_change"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["net_oper_cash_flow"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["capital_exp"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["sale_fixed_ass_cash_flow"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["inv_add"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["inv_reduce"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["other_net_inv_cash_flow"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["net_inv_cash_flow"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["debt_add"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["debt_reduce"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["equity_add"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["equity_reduce"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["equity_int_sun"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["other_net_fin_cash_flow"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["net_fin_cash_flow"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["rate_change"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["other_cah_adjust"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["ni_cash_equi"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["net_cash_equi_begin"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["net_cash_equi_end"].double ?? 0))
                                    itemList.append(stateJSON["short_name"].string ?? "-")
                                    itemList.append(date2String(stateJSON["update_time"].string ?? "-"))
                                    itemList.append(unitFormat(stateJSON["tot_oper_rev"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["oper_rev"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["other_oper_rev"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["tot_oper_exp"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["oper_cost"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["oper_exp"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["gross_profit"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["sale_admin_exp"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["material_exp"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["employee_salary"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["r_d_cost"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["other_oper_exp_sum"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["operate_profig"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["int_cost"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["int_income"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["equity_inv_loss_benifit"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["pre_tax_profit"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["income_tax"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["sum_curr_liab"].double ?? 0))
                                    itemList.append(unitFormat(stateJSON["net_cash_flow"].double ?? 0))
                                    itemList.append(stateJSON["asset_debt_ratio"].string ?? "-")
                                    itemList.append(stateJSON["current_ratio"].string ?? "-")
                                    itemList.append(stateJSON["quick_ratio"].string ?? "-")
                                    itemList.append(stateJSON["account_rec_turnover"].string ?? "-")
                                    itemList.append(stateJSON["inventory_turnover"].string ?? "-")
                                    itemList.append(stateJSON["total_asset_turnover"].string ?? "-")
                                    itemList.append(stateJSON["main_business_profit_ratio"].string ?? "-")
                                    itemList.append(stateJSON["net_asset_return_ratio"].string ?? "-")
                                    itemList.append(stateJSON["total_asset_return_ratio"].string ?? "-")
                                    itemList.append(stateJSON["business_growth_rate"].string ?? "-")
                                    itemList.append(stateJSON["total_asset_growth_rate"].string ?? "-")
                                    itemList.append(stateJSON["net_profit_growth_rate"].string ?? "-")
                                }
                                //MARK: -近一年
                                let stateJSON = json["statement_last"]
                                itemList.append(unitFormat(stateJSON["b_id"].double ?? 0))
                                itemList.append(unitFormat(stateJSON["cash_equ"].double ?? 0))
                                itemList.append(unitFormat(stateJSON["tran_fin_ass"].double ?? 0))
                                itemList.append(unitFormat(stateJSON["other_short_term_ass"].double ?? 0))
                                itemList.append(unitFormat(stateJSON["account_rec"].double ?? 0))
                                itemList.append(unitFormat(stateJSON["other_rec"].double ?? 0))
                                itemList.append(unitFormat(stateJSON["inventory"].double ?? 0))
                                itemList.append(unitFormat(stateJSON["other_curr_ass"].double ?? 0))
                                itemList.append(unitFormat(stateJSON["sum_curr_ass"].double ?? 0))
                                itemList.append(unitFormat(stateJSON["fixed_ass_net"].double ?? 0))
                                itemList.append(unitFormat(stateJSON["inv_property"].double ?? 0))
                                itemList.append(unitFormat(stateJSON["constructiong_project"].double ?? 0))
                                itemList.append(unitFormat(stateJSON["other_fixed_ass"].double ?? 0))
                                itemList.append(unitFormat(stateJSON["equity_inv"].double ?? 0))
                                itemList.append(unitFormat(stateJSON["hold_maturity_inv"].double ?? 0))
                                itemList.append(unitFormat(stateJSON["saled_inv"].double ?? 0))
                                itemList.append(unitFormat(stateJSON["other_long_term_inv"].double ?? 0))
                                itemList.append(unitFormat(stateJSON["goodwill_intangl_ass"].double ?? 0))
                                itemList.append(unitFormat(stateJSON["other_non_curr_ass"].double ?? 0))
                                itemList.append(unitFormat(stateJSON["sum_non_curr_ass"].double ?? 0))
                                itemList.append(unitFormat(stateJSON["sum_ass"].double ?? 0))
                                itemList.append(unitFormat(stateJSON["account_pay"].double ?? 0))
                                itemList.append(unitFormat(stateJSON["tran_fin_liab"].double ?? 0))
                                itemList.append(unitFormat(stateJSON["expire_liab"].double ?? 0))
                                itemList.append(unitFormat(stateJSON["other_curr_liab"].double ?? 0))
                                itemList.append(unitFormat(stateJSON["lt_borrow"].double ?? 0))
                                itemList.append(unitFormat(stateJSON["other_non_liab"].double ?? 0))
                                itemList.append(unitFormat(stateJSON["sum_non_liab"].double ?? 0))
                                itemList.append(unitFormat(stateJSON["sum_liab"].double ?? 0))
                                itemList.append(unitFormat(stateJSON["equity"].double ?? 0))
                                itemList.append(unitFormat(stateJSON["pre_stock"].double ?? 0))
                                itemList.append(unitFormat(stateJSON["sum_she_equity"].double ?? 0))
                                itemList.append(unitFormat(stateJSON["sum_liab_equity"].double ?? 0))
                                itemList.append(unitFormat(stateJSON["net_profit"].double ?? 0))
                                itemList.append(unitFormat(stateJSON["depre_amort"].double ?? 0))
                                itemList.append(unitFormat(stateJSON["oper_capital_change"].double ?? 0))
                                itemList.append(unitFormat(stateJSON["other_non_cash_change"].double ?? 0))
                                itemList.append(unitFormat(stateJSON["net_oper_cash_flow"].double ?? 0))
                                itemList.append(unitFormat(stateJSON["capital_exp"].double ?? 0))
                                itemList.append(unitFormat(stateJSON["sale_fixed_ass_cash_flow"].double ?? 0))
                                itemList.append(unitFormat(stateJSON["inv_add"].double ?? 0))
                                itemList.append(unitFormat(stateJSON["inv_reduce"].double ?? 0))
                                itemList.append(unitFormat(stateJSON["other_net_inv_cash_flow"].double ?? 0))
                                itemList.append(unitFormat(stateJSON["net_inv_cash_flow"].double ?? 0))
                                itemList.append(unitFormat(stateJSON["debt_add"].double ?? 0))
                                itemList.append(unitFormat(stateJSON["debt_reduce"].double ?? 0))
                                itemList.append(unitFormat(stateJSON["equity_add"].double ?? 0))
                                itemList.append(unitFormat(stateJSON["equity_reduce"].double ?? 0))
                                itemList.append(unitFormat(stateJSON["equity_int_sun"].double ?? 0))
                                itemList.append(unitFormat(stateJSON["other_net_fin_cash_flow"].double ?? 0))
                                itemList.append(unitFormat(stateJSON["net_fin_cash_flow"].double ?? 0))
                                itemList.append(unitFormat(stateJSON["rate_change"].double ?? 0))
                                itemList.append(unitFormat(stateJSON["other_cah_adjust"].double ?? 0))
                                itemList.append(unitFormat(stateJSON["ni_cash_equi"].double ?? 0))
                                itemList.append(unitFormat(stateJSON["net_cash_equi_begin"].double ?? 0))
                                itemList.append(unitFormat(stateJSON["net_cash_equi_end"].double ?? 0))
                                itemList.append(stateJSON["short_name"].string ?? "-")
                                itemList.append(date2String(stateJSON["update_time"].string ?? "-"))
                                itemList.append(unitFormat(stateJSON["tot_oper_rev"].double ?? 0))
                                itemList.append(unitFormat(stateJSON["oper_rev"].double ?? 0))
                                itemList.append(unitFormat(stateJSON["other_oper_rev"].double ?? 0))
                                itemList.append(unitFormat(stateJSON["tot_oper_exp"].double ?? 0))
                                itemList.append(unitFormat(stateJSON["oper_cost"].double ?? 0))
                                itemList.append(unitFormat(stateJSON["oper_exp"].double ?? 0))
                                itemList.append(unitFormat(stateJSON["gross_profit"].double ?? 0))
                                itemList.append(unitFormat(stateJSON["sale_admin_exp"].double ?? 0))
                                itemList.append(unitFormat(stateJSON["material_exp"].double ?? 0))
                                itemList.append(unitFormat(stateJSON["employee_salary"].double ?? 0))
                                itemList.append(unitFormat(stateJSON["r_d_cost"].double ?? 0))
                                itemList.append(unitFormat(stateJSON["other_oper_exp_sum"].double ?? 0))
                                itemList.append(unitFormat(stateJSON["operate_profig"].double ?? 0))
                                itemList.append(unitFormat(stateJSON["int_cost"].double ?? 0))
                                itemList.append(unitFormat(stateJSON["int_income"].double ?? 0))
                                itemList.append(unitFormat(stateJSON["equity_inv_loss_benifit"].double ?? 0))
                                itemList.append(unitFormat(stateJSON["pre_tax_profit"].double ?? 0))
                                itemList.append(unitFormat(stateJSON["income_tax"].double ?? 0))
                                itemList.append(unitFormat(stateJSON["sum_curr_liab"].double ?? 0))
                                itemList.append(unitFormat(stateJSON["net_cash_flow"].double ?? 0))
                                itemList.append(stateJSON["asset_debt_ratio"].string ?? "-")
                                itemList.append(stateJSON["current_ratio"].string ?? "-")
                                itemList.append(stateJSON["quick_ratio"].string ?? "-")
                                itemList.append(stateJSON["account_rec_turnover"].string ?? "-")
                                itemList.append(stateJSON["inventory_turnover"].string ?? "-")
                                itemList.append(stateJSON["total_asset_turnover"].string ?? "-")
                                itemList.append(stateJSON["main_business_profit_ratio"].string ?? "-")
                                itemList.append(stateJSON["net_asset_return_ratio"].string ?? "-")
                                itemList.append(stateJSON["total_asset_return_ratio"].string ?? "-")
                                itemList.append(stateJSON["business_growth_rate"].string ?? "-")
                                itemList.append(stateJSON["total_asset_growth_rate"].string ?? "-")
                                itemList.append(stateJSON["net_profit_growth_rate"].string ?? "-")

                                //MARK: -行业平均值
                                for _ in 0..<78 {
                                    itemList.append("-")
                                }
                                if json["industry_avg_info"]["info"]["indexs"].count != 0 {
                                    let indexsJSON = json["industry_avg_info"]["info"]["indexs"]
                                    itemList.append(unitFormat(indexsJSON[11][3].double ?? 0))
                                    itemList.append("-")
                                    itemList.append(unitFormat(indexsJSON[13][3].double ?? 0))
                                    itemList.append(unitFormat(indexsJSON[7][3].double ?? 0))
                                    itemList.append(unitFormat(indexsJSON[22][3].double ?? 0))
                                    itemList.append(unitFormat(indexsJSON[6][3].double ?? 0))
                                    itemList.append(unitFormat(indexsJSON[2][3].double ?? 0))
                                    itemList.append(unitFormat(indexsJSON[1][3].double ?? 0))
                                    itemList.append(unitFormat(indexsJSON[0][3].double ?? 0))
                                    itemList.append(unitFormat(indexsJSON[17][3].double ?? 0))
                                    itemList.append(unitFormat(indexsJSON[20][3].double ?? 0))
                                    itemList.append(unitFormat(indexsJSON[19][3].double ?? 0))
                                }
                                else {
                                    for _ in 0..<12 {
                                        itemList.append("-")
                                    }
                                }

                                let titleList = ["证券代码", "现金及现金等价物", "交易性金融资产", "其他短期投资", "应收账款及票据", "其它应收款", "存货", "其他流动资产", "流动资产合计", "固定资产净值", "投资物业", "在建工程", "其他固定资产", "权益性投资", "持有至到期投资", "可供出售投资", "其他长期投资", "商誉及无形资产", "其他非流动资产", "非流动资产合计", "总资产", "应付账款及票据", "交易性金融负债", "短期借贷及长期借贷当期到期部分", "其他流动负债", "长期借贷", "其他非流动负债", "非流动负债合计", "总负债", "普通股股本", "优先股", "股东权益合计", "总负债及总权益", "净利润", "折旧与摊销", "营运资本变动", "其他非现金调整", "经营活动产生的现金流量净额", "资本性支出", "出售固定资产收到的现金", "投资增加", "投资减少", "其他投资活动产生的现金流量净额", "投资活动产生的现金流量净额", "债务增加", "债务减少", "股本增加", "股本减少", "支付的股利合计", "其他筹资活动产生的现金流量净额", "筹资活动产生的现金流量净额", "汇率变动影响", "其他现金流量调整", "现金及现金等价物净增加额", "现金及现金等价物期初余额", "现金及现金等价物期末余额", "证券简称", "更新时间", "总营业收入", "主营收入", "其他营业收入", "总营业支", "营业成本", "营业开支", "毛利", "销售、行政及一般费用", "材料及相关费用", "员工薪酬", "研发费用", "其他营业费用合计", "营业利润", "利息支出", "利息收入", "权益性投资损益", "除税前利润", "所得税", "流动负债合计", "现金净流量", "资产负债率", "流动比率", "速动比率", "应收账款周转率", "存货周转率", "总资产周转率", "主营业务利润率", "净资产收益率", "总资产报酬率", "营业增长率", "总资产增长率", "净利润增长率"]
                                var k = 0
                                for i in 0..<titleList.count {
                                    for j in 0..<2 {
                                        if j == 0 {
                                            dataList.append(titleList[i])
                                        }
                                        else {
                                            if k < titleList.count {
                                                for t in 0..<(columnNum - 1) {
                                                    dataList.append(itemList[k + titleList.count * t])
                                                }
                                                k += 1
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        self.mView?.setTable(data: dataList)
                    }
                case false:
                    print("fail")
                }
        }
    }
}


