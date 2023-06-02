//
//  VoucherListViewController.swift
//  Kredivo
//
//  Created by Nugroho Arief Widodo on 02/06/23.
//

import UIKit

class VouchersViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(PaddingTableViewCell.self, forCellReuseIdentifier: "VoucherItemViewCell")
        tableView.separatorStyle = .none
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "VoucherItemViewCell", for: indexPath) as? PaddingTableViewCell, let view = cell.customView as? VoucherItemViewCell else { return UITableViewCell() }
        view.backgroundColor = .clear
        cell.setCard(leading: 16, trailing: 16, bottom: 0, top: 16)
        return cell
    }
}
