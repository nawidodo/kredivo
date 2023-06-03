//
//  VoucherListView.swift
//  Kredivo
//
//  Created by Nugroho Arief Widodo on 01/06/23.
//

import UIKit

protocol VoucherListViewDelegate {
    func didTapVoucherListButton()
}

class VoucherListView: UIView {

    var delegate: VoucherListViewDelegate?

    @IBAction func didTapButton(_ sender: UIButton) {
        delegate?.didTapVoucherListButton()
    }
}
