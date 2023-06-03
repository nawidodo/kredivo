//
//  PriceCellView.swift
//  Kredivo
//
//  Created by Nugroho Arief Widodo on 28/05/23.
//

import UIKit

protocol PriceCellViewDelegate {
    func didSelect(product: Product)
}

class PriceCellView: UIView {

    @IBOutlet var nominalLabel: UILabel!
    @IBOutlet var priceButton: UIButton!

    @IBAction func didTapButton(_ sender: UIButton) {
        guard let product = product else { return }
        delegate?.didSelect(product: product)
    }
    var product: Product?
    var delegate: PriceCellViewDelegate?
}
