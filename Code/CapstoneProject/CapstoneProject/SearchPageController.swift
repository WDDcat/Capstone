//
//  SearchPageController.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/3/21.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import UIKit
import CoreData

class SearchPageController: UITableViewController, UITextFieldDelegate {

    var mPresenter = SearchPageModel()
    
    var clear = UIButton()
    var searchView = UIView()
    var textField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mPresenter.mView = self
        
        tableView.keyboardDismissMode = .onDrag
        
//        NotificationCenter.default.addObserver(self, selector: #selector(KeyBoardWillShow(notification)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
//        userDefaults.set(["海南", "海南航空", "海澜之家", "小米", "腾讯", "航空", "海航集团", "中外名人", "上海奉贤", "hang sang"], forKey: "search_history")
    }

    override func viewWillAppear(_ animated: Bool) {
        clear = UIButton(frame: CGRect(x: UIScreen.main.bounds.width - 50, y: 5, width: 30, height: 30))
        clear.tintColor = .lightGray
        clear.setBackgroundImage(UIImage.init(systemName: "trash.fill"), for: .normal)
        clear.contentMode = .center
        clear.isUserInteractionEnabled = true
        clear.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickClear)))

        searchView = UIView(frame: CGRect(x: 40, y: 4, width: UIScreen.main.bounds.width - 100, height: 30))
        searchView.layer.cornerRadius = 14
        searchView.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        textField = UITextField(frame: CGRect(x: 15, y: 0, width: UIScreen.main.bounds.width - 120, height: 30))
        textField.attributedPlaceholder = NSAttributedString.init(string: "请输入企业名称", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        textField.clearButtonMode = .whileEditing
        textField.becomeFirstResponder()
        textField.returnKeyType = .search
        textField.textColor = .label
        searchView.addSubview(textField)

        navigationController?.navigationBar.addSubview(clear)
        navigationController?.navigationBar.addSubview(searchView)
        
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        clear.removeFromSuperview()
        textField.removeFromSuperview()
        searchView.removeFromSuperview()
    }
    
    @objc func clickClear() {
//        userDefaults.set([] as [String], forKey: "search_history")
//        tableView.reloadData()
        if (textField.text ?? "") != "" {
            updateRecordList(word: textField.text!)
            remoteSetSearchKeyword(word: textField.text!)
            let controller = storyboard?.instantiateViewController(withIdentifier: "CompanyList") as! CompanyListController
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (userDefaults.array(forKey: "search_history") ?? []).count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchPageItem", for: indexPath) as! SearchPageCell

        cell.label_companyName.text = (userDefaults.array(forKey: "search_history")![indexPath.row] as! String)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        remoteSetSearchKeyword(word: userDefaults.array(forKey: "search_history")![indexPath.row] as! String)
        updateRecordList(word: userDefaults.array(forKey: "search_history")![indexPath.row] as! String)
    }
    
    //MARK: -searchBar
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        print(textField.text ?? "")
//        return true
//    }
    
//    @objc func KeyBoardWillShow(notification: Notification) {
//        let userInfo = notification.userInfo! as Dictionary
//        let value = userInfo[UIKeyboardType.default.hashValue] as! NSValue
//        let keyboardRect = value.cgRectValue
//        let keyboardHeight = keyboardRect.size.height
//        tableView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: tableView.frame.height - keyboardHeight)
//    }
}

extension SearchPageController: SearchPageView {
    
}

extension SearchPageController {
    func updateRecordList(word: String) {
        let keyword = word//(word as NSString).replacingOccurrences(of: " ", with: "")
        if hasData(data: keyword) {
            renewData(data: keyword)
        }
        else {
            insertData(data: keyword)
        }
    }
    
    private func hasData(data: String) -> Bool {
        for i in 0..<(userDefaults.array(forKey: "search_history") ?? []).count {
            if userDefaults.array(forKey: "search_history")![i] as! String == data {
                return true
            }
        }
        return false
    }
    
    private func renewData(data: String) {
        var searchHistory: [String] = []
        for i in 0..<(userDefaults.array(forKey: "search_history") ?? []).count {
            searchHistory.append(userDefaults.array(forKey: "search_history")![i] as! String)
        }
        for i in 0..<(userDefaults.array(forKey: "search_history") ?? []).count {
            if userDefaults.array(forKey: "search_history")![i] as! String == data {
                searchHistory.remove(at: i)
                searchHistory.insert(data, at: 0)
                userDefaults.set(searchHistory, forKey: "search_history")
                return
            }
        }
    }
    
    private func insertData(data: String) {
        var searchHistory: [String] = []
        for i in 0..<(userDefaults.array(forKey: "search_history") ?? []).count {
            searchHistory.append(userDefaults.array(forKey: "search_history")![i] as! String)
        }
        searchHistory.insert(data, at: 0)
        if (userDefaults.array(forKey: "search_history") ?? []).count > 10 {
            searchHistory.remove(at: 10)
        }
        userDefaults.set(searchHistory, forKey: "search_history")
    }
}
