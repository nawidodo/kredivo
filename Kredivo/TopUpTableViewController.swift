//
//  TopUpTableViewController.swift
//  Kredivo
//
//  Created by Nugroho Arief Widodo on 28/05/23.
//

import UIKit
import XLPagerTabStrip

class TopUpTableViewController: UITableViewController {

    enum TopUpSection: CaseIterable {
        case label
        case mobileInput
        case price
        case promos
    }

    private let sections: [TopUpSection] = [.mobileInput, .price, .promos]

    var tabTitle: String = ""

    private func createTabSection(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SegmentedControlView", for: indexPath) as! PaddingTableViewCell
        let view = cell.customView as! SegmentedControlView
        let segment = view.segmentedView
        segment?.selectedTextColor = .kredivoOrange
        segment?.underlineColor = .kredivoOrange
        segment?.unselectedTextColor = .systemGray
        segment?.selectedFont = .systemFont(ofSize: 15)
        segment?.unselectedFont = .systemFont(ofSize: 15)
        segment?.underlineHeight = 3
        segment?.controlHeight = 60
        cell.selectionStyle = .none
        return cell
    }

    private func createMobileInputSection(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MobileInputView", for: indexPath) as! PaddingTableViewCell
        let view = cell.customView as! MobileInputView
        view.textField.becomeFirstResponder()
        cell.setCard(leading: 0, trailing: 0, bottom: 8, top: 0)
        cell.backgroundColor = UIColor.kredivoBlue.withAlphaComponent(0.1)
        cell.selectionStyle = .none
        return cell
    }

    private func createPriceSection(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PriceCellView", for: indexPath) as! PaddingTableViewCell
        let view = cell.customView as! PriceCellView
        view.backgroundColor = .clear
        cell.selectionStyle = .none
        return cell
    }

    private func createPromoSection(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PromoCellView", for: indexPath) as! PaddingTableViewCell
        let view = cell.customView as! PromoCellView
        view.backgroundColor = .white
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.kredivoBlue.withAlphaComponent(0.1)
        cell.setCard(leading: 0, trailing: 0, bottom: 0, top: 8)

        return cell
    }

    private func createLabelSection(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UILabel", for: indexPath) as! PaddingTableViewCell
        let view = cell.customView as! UILabel
        view.backgroundColor = .white
        view.text = "LOL"
        cell.selectionStyle = .none
        cell.setCard(leading: 0, trailing: 0, bottom: 0, top: 8)

        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(PaddingTableViewCell.self, forCellReuseIdentifier: "UILabel")
        tableView.register(PaddingTableViewCell.self, forCellReuseIdentifier: "MobileInputView")
        tableView.register(PaddingTableViewCell.self, forCellReuseIdentifier: "PriceCellView")
        tableView.register(PaddingTableViewCell.self, forCellReuseIdentifier: "PromoCellView")
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let section = sections[section]
        switch section {
        case .price:
            return 5
        default:
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let section = sections[indexPath.section]

        switch section {
        case .label:
            return createLabelSection(tableView: tableView, indexPath: indexPath)
        case .mobileInput:
            return createMobileInputSection(tableView: tableView, indexPath: indexPath)
        case .price:
            return createPriceSection(tableView: tableView, indexPath: indexPath)
        case .promos:
            return createPromoSection(tableView: tableView, indexPath: indexPath)
        }
    }

    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = sections[indexPath.section]

        if section == .promos {
            return UIScreen.main.bounds.width/2+50
        }
        return UITableView.automaticDimension
    }
}

extension TopUpTableViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: tabTitle)
    }
}


