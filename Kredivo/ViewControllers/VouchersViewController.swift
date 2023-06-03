//
//  VoucherListViewController.swift
//  Kredivo
//
//  Created by Nugroho Arief Widodo on 02/06/23.
//

import UIKit

protocol VouchersViewControllerDelegate {
    func didSelect(voucher: Voucher)
}

class VouchersViewController: UITableViewController {

    var vouchers: [Voucher] = []
    @Inject var service: APIService
    var delegate: VouchersViewControllerDelegate?

    private func registerCells() {
        tableView.register(PaddingTableViewCell.self, forCellReuseIdentifier: "VoucherItemViewCell")
        tableView.separatorStyle = .none
        self.title = "Voucher Saya"
    }

    private func loadVouchers() {
        Task { [weak self] in
            self?.vouchers = await service.getVouchers()
            self?.reload()
        }
    }

    @MainActor
    private func reload() {
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        loadVouchers()
        updateNavBar()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vouchers.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "VoucherItemViewCell", for: indexPath) as? PaddingTableViewCell, let view = cell.customView as? VoucherItemViewCell else { return UITableViewCell() }
        let voucher = vouchers[indexPath.row]
        view.delegate = self
        view.voucher = voucher
        view.voucherNameLabel.text = voucher.name
        view.validUntilLabel.text = voucher.validUntilText()
        view.backgroundColor = .clear
        cell.setCard(leading: 16, trailing: 16, bottom: 0, top: 16)
        return cell
    }
}

extension VouchersViewController: VoucherItemViewCellDelegate {
    func didSelect(voucher: Voucher) {
        delegate?.didSelect(voucher: voucher)
        navigationController?.popViewController(animated: true)
    }
}
