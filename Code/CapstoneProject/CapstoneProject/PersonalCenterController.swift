//
//  PersonalCenterController.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/3/19.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import UIKit

var PersonalCenterCompanyList:[[String]] = [[]]

private let customLightGray: UIColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
private enum ListType {
    case favourite
    case friends
    case message
}

class PersonalCenterController: UIViewController {

    var mPresenter = PersonalCenterModel()
    
    @IBOutlet weak var label_realName: UILabel!
    @IBOutlet weak var label_occupation: UILabel!
    @IBOutlet weak var label_company: UILabel!
    @IBOutlet weak var label_position: UILabel!
    
    @IBOutlet weak var tag_favourite: UILabel!
    @IBOutlet weak var tag_friends: UILabel!
    @IBOutlet weak var tag_message: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var logout = UIButton()
    private var page = 0
    fileprivate var listType: ListType = .favourite
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mPresenter.mView = self
        tableView.delegate = self
        tableView.dataSource = self
        mPresenter.getPersonalInfo()
        PersonalCenterCompanyList.removeAll()
        mPresenter.getFavouriteInfo(page: page)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        logout = UIButton(frame: CGRect(x: UIScreen.main.bounds.width - 50, y: 0, width: 40, height: (navigationController?.navigationBar.frame.height)!))
        logout.setTitleColor(.lightGray, for: .normal)
        logout.setTitle("注销", for: .normal)
        logout.setBackgroundImage(nil, for: .normal)
        logout.isUserInteractionEnabled = true
        logout.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickLogout)))
        navigationController?.navigationBar.addSubview(logout)
        
        tag_favourite.isUserInteractionEnabled = true
        tag_favourite.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickFavourite)))
        
        tag_friends.isUserInteractionEnabled = true
        tag_friends.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickFriends)))
        
        tag_message.isUserInteractionEnabled = true
        tag_message.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickMessage)))
        
        mPresenter.getPersonalInfo()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        logout.removeFromSuperview()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewController = segue.destination as! RegisterPageController
        viewController.from = "personalCenter"
    }
    
    @objc func clickLogout() {
        print("attempt logout")
        mPresenter.logoutAttempt()
    }
    
    @objc func clickFavourite() {
        tag_favourite.backgroundColor = customLightGray
        tag_friends.backgroundColor = .lightGray
        tag_message.backgroundColor = .lightGray
        page = 0
        mPresenter.getFavouriteInfo(page: page)
    }
    
    @objc func clickFriends() {
        tag_favourite.backgroundColor = .lightGray
        tag_friends.backgroundColor = customLightGray
        tag_message.backgroundColor = .lightGray
        mPresenter.getFriendsInfo()
    }
    
    @objc func clickMessage() {
        tag_favourite.backgroundColor = .lightGray
        tag_friends.backgroundColor = .lightGray
        tag_message.backgroundColor = customLightGray
        mPresenter.getMessageInfo()
    }
}

extension PersonalCenterController: PersonalCenterView {
    func setRealName(name: String) {
        label_realName.text = name
    }
    
    func setOccupation(occupation: String) {
        label_occupation.text = occupation
    }
    
    func setCompany(company: String) {
        label_company.text = company
    }
    
    func setPosition(position: String) {
        label_position.text = position
    }
    
    func refreshCompanyList() {
        listType = .favourite
        tableView.reloadData()
    }
    
    func refreshFriendsList() {
        listType = .friends
        tableView.reloadData()
    }
    
    func refreshMessageList() {
        listType = .message
        tableView.reloadData()
    }
    
    func setFooterView(text: String) {
        let view = UILabel()
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 21)
        view.backgroundColor = .gray
        view.textColor = .white
        view.text = text
        view.textAlignment = .center
        tableView.tableFooterView = view
    }
    
    func logoutSuccess() {
        print("success")
        self.navigationController?.popViewController(animated: true)
    }
}

extension PersonalCenterController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch listType {
        case .favourite:
            return PersonalCenterCompanyList.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavouriteCompanyItem", for: indexPath) as! FavouriteCompanyListCell
        
        switch listType {
        case .favourite:
            cell.mPresenter = CompanyCellModel()
            cell.label_companyName.text = PersonalCenterCompanyList[indexPath.row][0]
            cell.label_address.text = "地址：\(PersonalCenterCompanyList[indexPath.row][1])"
            cell.label_legalPerson.text = "法人：\(PersonalCenterCompanyList[indexPath.row][2])"
            cell.btn_star.setImage(UIImage(systemName: "star.fill"), for: .normal)
            cell.c_id = PersonalCenterCompanyList[indexPath.row][4]
        case .friends:
            break
        case .message:
            break
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (page * 10 + 9){
            print("refresh")
            page = page + 1
            mPresenter.getFavouriteInfo(page: page)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        remoteSetCompanyId(id: PersonalCenterCompanyList[indexPath.row][4])
        remoteSetCompanyName(name: PersonalCenterCompanyList[indexPath.row][0])
        print("didSelect:\(PersonalCenterCompanyList[indexPath.row][0])")
        let controller = storyboard?.instantiateViewController(withIdentifier: "CompanyDetail") as! CompanyDetailController
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
