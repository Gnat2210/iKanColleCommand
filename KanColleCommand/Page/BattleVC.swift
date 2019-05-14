//
// Created by CC on 2019-03-07.
// Copyright (c) 2019 CC. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import RxSwift

class BattleVC: UIViewController {

    private static let cellIdentifier = "BattleCellId"
    private let friendListDelegate = FriendListDelegate()
    private let friendListDataSource = FriendListDataSource()
    private let enemyListDelegate = EnemyListDelegate()
    private let enemyListDataSource = EnemyListDataSource()

    private var friendList: UITableView!
    private var enemyList: UITableView!
    private var nodeText: UILabel!
    private var nextText: UILabel!
    private var headingText: UILabel!
    private var airCommandText: UILabel!
    private var resultText: UILabel!
    private var getText: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ViewController.DEFAULT_BACKGROUND
        setupList()
        setupInfoViews()
        watchBattle()
    }

    private func setupList() {
        friendList = UITableView()
        friendList.delegate = friendListDelegate
        friendList.dataSource = friendListDataSource
        friendList.backgroundColor = UIColor.clear
        friendList.separatorStyle = .none
        friendList.register(BattleCell.self, forCellReuseIdentifier: BattleVC.cellIdentifier)
        self.view.addSubview(friendList)
        friendList.snp.makeConstraints { maker in
            maker.left.equalTo(self.view.snp.left).offset(4)
            maker.top.equalTo(self.view.snp.top).offset(4)
            maker.bottom.equalTo(self.view.snp.centerY).offset(-4)
            maker.width.equalTo(320)
        }
        enemyList = UITableView()
        enemyList.delegate = enemyListDelegate
        enemyList.dataSource = enemyListDataSource
        enemyList.backgroundColor = UIColor.clear
        enemyList.separatorStyle = .none
        enemyList.register(BattleCell.self, forCellReuseIdentifier: BattleVC.cellIdentifier)
        self.view.addSubview(enemyList)
        enemyList.snp.makeConstraints { maker in
            maker.left.equalTo(friendList.snp.left)
            maker.top.equalTo(self.view.snp.centerY).offset(4)
            maker.bottom.equalTo(self.view.snp.bottom).offset(4)
            maker.width.equalTo(friendList.snp.width)
        }
    }

    private func setupInfoViews() {
        let infoContainer = UIStackView()

        nodeText = UILabel()
        nodeText.numberOfLines = 1
        nodeText.lineBreakMode = .byTruncatingTail
        nodeText.font = UIFont.systemFont(ofSize: 12)
        nodeText.textColor = UIColor.white
        nodeText.textAlignment = .center
        infoContainer.addArrangedSubview(nodeText)
        nodeText.snp.makeConstraints { maker in
            maker.width.equalTo(infoContainer)
        }
        nextText = UILabel()
        nextText.numberOfLines = 1
        nextText.lineBreakMode = .byTruncatingTail
        nextText.font = UIFont.systemFont(ofSize: 12)
        nextText.textColor = UIColor.white
        nextText.textAlignment = .center
        infoContainer.addArrangedSubview(nextText)
        nextText.snp.makeConstraints { maker in
            maker.width.equalTo(infoContainer)
        }
        headingText = UILabel()
        headingText.numberOfLines = 1
        headingText.lineBreakMode = .byTruncatingTail
        headingText.font = UIFont.systemFont(ofSize: 12)
        headingText.textColor = UIColor.white
        headingText.textAlignment = .center
        infoContainer.addArrangedSubview(headingText)
        headingText.snp.makeConstraints { maker in
            maker.width.equalTo(infoContainer)
        }
        airCommandText = UILabel()
        airCommandText.numberOfLines = 1
        airCommandText.lineBreakMode = .byTruncatingTail
        airCommandText.font = UIFont.systemFont(ofSize: 12)
        airCommandText.textColor = UIColor.white
        airCommandText.textAlignment = .center
        infoContainer.addArrangedSubview(airCommandText)
        airCommandText.snp.makeConstraints { maker in
            maker.width.equalTo(infoContainer)
        }
        resultText = UILabel()
        resultText.numberOfLines = 1
        resultText.lineBreakMode = .byTruncatingTail
        resultText.font = UIFont.systemFont(ofSize: 12)
        resultText.textColor = UIColor.white
        resultText.textAlignment = .center
        infoContainer.addArrangedSubview(resultText)
        resultText.snp.makeConstraints { maker in
            maker.width.equalTo(infoContainer)
        }
        getText = UILabel()
        getText.numberOfLines = 1
        getText.lineBreakMode = .byTruncatingTail
        getText.font = UIFont.systemFont(ofSize: 12)
        getText.textColor = UIColor.white
        getText.textAlignment = .center
        infoContainer.addArrangedSubview(getText)
        getText.snp.makeConstraints { maker in
            maker.width.equalTo(infoContainer)
        }

        infoContainer.axis = .vertical
        infoContainer.distribution = .fillEqually
        infoContainer.alignment = .center
        self.view.addSubview(infoContainer)
        infoContainer.snp.makeConstraints { maker in
            maker.left.equalTo(friendList.snp.right).offset(4)
            maker.right.equalTo(self.view.snp.right).offset(4)
            maker.top.equalTo(self.view.snp.top).offset(36)
            maker.bottom.equalTo(self.view.snp.bottom).offset(-36)
        }
    }

    private func watchBattle() {
        Oyodo.attention().watch(data: Battle.instance.phase) { (event: Event<Phase>) in
            if let phase = event.element {
                self.refreshListData(phase)
                self.refreshInfoData(phase)
            }
        }
    }

    private func refreshListData(_ phase: Phase) {
        switch (phase) {
        case Phase.Start, Phase.Next, Phase.Idle:
            self.friendListDataSource.friendFleet1.removeAll()
            self.friendListDataSource.friendFleet2.removeAll()
            self.enemyListDataSource.enemyFleet1.removeAll()
            self.enemyListDataSource.enemyFleet2.removeAll()
            break
        default:
            if (Battle.instance.friendCombined) {
                self.friendListDataSource.friendFleet1 = Fleet.instance.getShips(index: 0)
                self.friendListDataSource.friendFleet2 = Fleet.instance.getShips(index: 1)
                self.enemyListDataSource.enemyFleet1 = Battle.instance.subEnemyList
                self.enemyListDataSource.enemyFleet2 = Battle.instance.enemyList
            } else {
                let friendFleetIndex = Battle.instance.friendIndex
                self.friendListDataSource.friendFleet1 = Fleet.instance.getShips(index: friendFleetIndex)
                self.friendListDataSource.friendFleet2.removeAll()
                self.enemyListDataSource.enemyFleet1 = Battle.instance.enemyList
                self.enemyListDataSource.enemyFleet2.removeAll()
            }
            break
        }
        self.friendList.reloadData()
        self.enemyList.reloadData()
    }

    private func refreshInfoData(_ phase: Phase) {
        switch (phase) {
        case Phase.Start:
            nodeText.text = "\(Battle.instance.area)-\(Battle.instance.map)"
            let spot = MapSpotHelper.instance.getSpotMarker(area: Battle.instance.area, map: Battle.instance.map, route: Battle.instance.route)
            nextText.text = "罗盘: \(spot?[safe: 1] ?? "")"
            headingText.text = ""
            airCommandText.text = ""
            resultText.text = ""
            getText.text = ""
            break
        case Phase.Next:
            nodeText.text = "\(Battle.instance.area)-\(Battle.instance.map)"
            let spot = MapSpotHelper.instance.getSpotMarker(area: Battle.instance.area, map: Battle.instance.map, route: Battle.instance.route)
            nextText.text = "罗盘: \(spot?[safe: 1] ?? "")"
            headingText.text = ""
            airCommandText.text = ""
            resultText.text = ""
            getText.text = ""
            break
        case Phase.BattleDaytime, Phase.BattleNight, Phase.BattleNightSp, Phase.BattleAir:
            nodeText.text = "\(Battle.instance.area)-\(Battle.instance.map)"
            let spot = MapSpotHelper.instance.getSpotMarker(area: Battle.instance.area, map: Battle.instance.map, route: Battle.instance.route)
            nextText.text = "\(spot?[safe: 1] ?? "")"
            headingText.text = buildHeadingStr(heading: Battle.instance.heading)
            airCommandText.text = buildAirCommandStr(air: Battle.instance.airCommand)
            resultText.text = Battle.instance.rank
            getText.text = ""
            break
        case Phase.BattleResult:
            nodeText.text = "\(Battle.instance.area)-\(Battle.instance.map)"
            let spot = MapSpotHelper.instance.getSpotMarker(area: Battle.instance.area, map: Battle.instance.map, route: Battle.instance.route)
            nextText.text = "\(spot?[safe: 1] ?? "")"
            headingText.text = buildHeadingStr(heading: Battle.instance.heading)
            airCommandText.text = buildAirCommandStr(air: Battle.instance.airCommand)
            resultText.text = Battle.instance.rank
            getText.text = "捞: \(Battle.instance.get)"
            break
        default:
            nodeText.text = "未出击"
            nextText.text = ""
            headingText.text = ""
            airCommandText.text = ""
            resultText.text = ""
            getText.text = ""
            break
        }
    }

    private class FriendListDelegate: NSObject, UITableViewDelegate {

        public func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
//        tableView.deselectRow(at: indexPath, animated: false)
            return nil
        }

        public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 24
        }

    }

    private class FriendListDataSource: NSObject, UITableViewDataSource {

        var friendFleet1 = Array<Ship>()
        var friendFleet2 = Array<Ship>()

        public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return friendFleet1.count
        }

        public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            var cell: BattleCell! = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? BattleCell
            if cell == nil {
                cell = BattleCell(style: .default, reuseIdentifier: cellIdentifier)
            }
            cell.set(ship: friendFleet1[indexPath.item], friend: true)
            return cell
        }

    }

    private class EnemyListDelegate: NSObject, UITableViewDelegate {

        public func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
//        tableView.deselectRow(at: indexPath, animated: false)
            return nil
        }

        public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 24
        }

    }

    private class EnemyListDataSource: NSObject, UITableViewDataSource {

        var enemyFleet1 = Array<Ship>()
        var enemyFleet2 = Array<Ship>()

        public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return enemyFleet1.count
        }

        public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            var cell: BattleCell! = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? BattleCell
            if cell == nil {
                cell = BattleCell(style: .default, reuseIdentifier: cellIdentifier)
            }
            cell.set(ship: enemyFleet1[indexPath.item], friend: false)
            return cell
        }

    }

}

private class BattleCell: UITableViewCell {

    private var leftView: UIView!
    private var rightView: UIView!

    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.backgroundColor = UIColor.clear

        leftView = UIView()
        addSubview(leftView)
//        leftView.snp.makeConstraints { maker in
//            maker.left.equalTo(self)
//            maker.top.equalTo(self)
//            maker.bottom.equalTo(self).offset(-4)
//            maker.right.equalTo(self.snp.centerX).offset(-2)
//        }
        leftView.snp.makeConstraints { maker in
            maker.left.equalTo(self)
            maker.top.equalTo(self)
            maker.bottom.equalTo(self).offset(-4)
            maker.right.equalTo(self)
        }
        addCellSubViews(to: leftView)

//        rightView = UIView()
//        addSubview(rightView)
//        rightView.snp.makeConstraints { maker in
//            maker.left.equalTo(self.snp.centerX).offset(2)
//            maker.top.equalTo(self)
//            maker.bottom.equalTo(leftView)
//            maker.right.equalTo(self)
//        }
//        addCellSubViews(to: rightView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addCellSubViews(to cellRoot: UIView) {
        // HP Bar
        let hp = HpBar()
        hp.attachTo(cell: cellRoot)
        hp.tag = "hp".hash

        // HP Text
        let hpText = UILabel()
        cellRoot.addSubview(hpText)
        hpText.snp.makeConstraints { maker in
            maker.right.equalTo(cellRoot).offset(-4)
            maker.width.equalTo(80)
            maker.height.equalTo(cellRoot)
        }
        hpText.numberOfLines = 1
        hpText.lineBreakMode = .byTruncatingTail
        hpText.font = UIFont.systemFont(ofSize: 12)
        hpText.textColor = UIColor.lightGray
        hpText.textAlignment = .right
        hpText.tag = "hpText".hash

        // Name
        let nameText = UILabel()
        cellRoot.addSubview(nameText)
        nameText.snp.makeConstraints { maker in
            maker.left.equalTo(cellRoot).offset(4)
            maker.right.equalTo(hpText.snp.left).offset(-4)
            maker.height.equalTo(cellRoot)
        }
        nameText.numberOfLines = 1
        nameText.lineBreakMode = .byTruncatingTail
        nameText.font = UIFont.systemFont(ofSize: 12)
        nameText.textColor = UIColor.white
        nameText.tag = "nameText".hash
    }

    func set(ship: Ship, friend: Bool) {
        let hpBar = leftView.viewWithTag("hp".hash) as! HpBar
        hpBar.set(percent: CGFloat(ship.hp()) / CGFloat(ship.maxHp))
        let nameText = leftView.viewWithTag("nameText".hash) as! UILabel
        nameText.text = ship.name
        let hpText = leftView.viewWithTag("hpText".hash) as! UILabel
        var hpValue = 0
        if (friend) {
            hpValue = max(ship.hp(), 1)
        } else {
            hpValue = ship.hp()
        }
        var hpStr = "\(hpValue) / \(ship.maxHp)"
        let lastDamage = ship.damage.last ?? 0
        if (lastDamage > 0) {
            hpStr = hpStr + " (-\(lastDamage))"
        }
        hpText.text = hpStr
    }

}
