//
//  PromoDetailViewController.swift
//  Kredivo
//
//  Created by Nugroho Arief Widodo on 31/05/23.
//

import UIKit

class PromoDetailViewController:
    UIViewController {

    var voucher: Voucher

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var promoCodeLabel: UILabel!
    @IBOutlet var validDateLabel: UILabel!
    @IBOutlet var tncLabel: UILabel!

    @IBAction func didTapCopy(_ sender: UIButton) {
        let pasteboard = UIPasteboard.general
        pasteboard.string = promoCodeLabel.text
        let message = "Promo code '\(pasteboard.string ?? "")' has been copied to the clipboard."
        showMessage(message: message)
    }

    init(voucher: Voucher) {
        self.voucher = voucher
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        updateNavBar()
        self.title = "Merchant Promo"
        promoCodeLabel.text = voucher.voucherCode
        titleLabel.text = voucher.howToUse
        tncLabel.text = voucher.termsAndCondition
        validDateLabel.text = voucher.dateText()
    }
}
