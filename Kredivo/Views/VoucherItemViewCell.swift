//
//  VoucherItemViewCell.swift
//  Kredivo
//
//  Created by Nugroho Arief Widodo on 02/06/23.
//

import UIKit

protocol VoucherItemViewCellDelegate {
    func didSelect(voucher: Voucher)
}

class VoucherItemViewCell: UIView {

    @IBOutlet var voucherNameLabel: UILabel!
    @IBOutlet var validUntilLabel: UILabel!

    @IBAction func didTapSelectButton(_ sender: UIButton) {
        guard let voucher = voucher else { return }
        delegate?.didSelect(voucher: voucher)

    }
    var voucher: Voucher?
    var delegate: VoucherItemViewCellDelegate?
}
