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
        case product
        case promos
    }

    private let sections: [TopUpSection] = [.mobileInput, .product, .promos]

    var tabTitle: String = ""
    var products: [Product] = []
    var vouchers: [Voucher] = []
    var phoneNumber: String = ""
    var router: UINavigationController?

    @Inject var service: APIService

    private func createMobileInputSection(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MobileInputView", for: indexPath) as! PaddingTableViewCell
        let view = cell.customView as! MobileInputView
        view.delegate = self
        view.textField.becomeFirstResponder()
        cell.setCard(leading: 0, trailing: 0, bottom: 8, top: 0)
        cell.backgroundColor = UIColor.kredivoBlue.withAlphaComponent(0.1)
        cell.selectionStyle = .none
        return cell
    }

    private func createProductSection(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let product = products[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "PriceCellView", for: indexPath) as! PaddingTableViewCell
        let view = cell.customView as! PriceCellView
        view.product = product
        view.delegate = self
        view.nominalLabel.text = product.nominal.toCurrency()
        view.priceButton.setTitle(product.price.toCurrency(symbol: "Rp", isBreakSpace: false), for: .normal)
        view.backgroundColor = .clear
        cell.selectionStyle = .none
        return cell
    }

    private func createPromoSection(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PromoCellView", for: indexPath) as! PaddingTableViewCell
        let view = cell.customView as! PromoCellView
        view.vouchers = vouchers
        view.delegate = self
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

    @MainActor
    private func reload(sections: IndexSet) {
        tableView.reloadSections(sections, with: .automatic)
    }

    private func loadPromos() {
        let index = sections.firstIndex(of: .promos)!
        Task { [weak self] in
            self?.vouchers = await service.getVouchers()
            self?.reload(sections: IndexSet(integer: index))
        }
    }
    
    private func registerCells() {
        tableView.register(PaddingTableViewCell.self, forCellReuseIdentifier: "UILabel")
        tableView.register(PaddingTableViewCell.self, forCellReuseIdentifier: "MobileInputView")
        tableView.register(PaddingTableViewCell.self, forCellReuseIdentifier: "PriceCellView")
        tableView.register(PaddingTableViewCell.self, forCellReuseIdentifier: "PromoCellView")
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        loadPromos()
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
        case .product:
            return products.count
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
        case .product:
            return createProductSection(tableView: tableView, indexPath: indexPath)
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

extension TopUpTableViewController: InputViewDelegate {
    func didGet(text: String) {
        phoneNumber = text
        let index = sections.firstIndex(of: .product)!
        if text.count == 4 {
            Task { [weak self] in
                let products = await service.getPrices()
                self?.products = products
                self?.reload(sections: IndexSet(integer: index))
            }
        } else if text.count <= 3 {
            products = []
            reload(sections: IndexSet(integer: index))
        }
    }
}

extension TopUpTableViewController: PromoCellViewDelegate {
    func didSelectItemAt(indexPath: IndexPath) {
        let voucher = vouchers[indexPath.row]
        let vc = PromoDetailViewController(voucher: voucher)
        router?.pushViewController(vc, animated: true)
    }
}

extension TopUpTableViewController: PriceCellViewDelegate {
    func didSelect(product: Product) {
        let order: Order = .init(phoneNumber: phoneNumber, product: product)
        let vc: ConfirmationPaymentViewController = .init(order: order)
        vc.service = service
        router?.pushViewController(vc, animated: true)
    }
}


