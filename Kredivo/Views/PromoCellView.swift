//
//  PromoCellView.swift
//  Kredivo
//
//  Created by Nugroho Arief Widodo on 29/05/23.
//

import UIKit

protocol PromoCellViewDelegate {
    func didSelectItemAt(indexPath: IndexPath)
}

class PromoCellView: UIView {
    @IBOutlet var collectionView: UICollectionView!

    var delegate: PromoCellViewDelegate?
    var vouchers: [Voucher] = []
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PaddingCollectionViewCell.self, forCellWithReuseIdentifier: "PromoItemView")
    }
}

extension PromoCellView: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vouchers.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = PaddingCollectionViewCell.dequeueReusableCell(for: collectionView, with: "PromoItemView", indexPath: indexPath) as? PaddingCollectionViewCell, let view = cell.customView as? PromoItemView else { return UICollectionViewCell() }
        view.backgroundColor = .clear
        return cell

    }
}

extension PromoCellView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width * 80 / 100
        let height = width / 2

        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        return UIEdgeInsets(top: 2, left: 0, bottom: 2, right: 0)
    }

}

extension PromoCellView: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.collectionView.scrollToNearestVisibleCollectionViewCell()
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.collectionView.scrollToNearestVisibleCollectionViewCell()
        }
    }
}

extension PromoCellView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectItemAt(indexPath: indexPath)
    }
}
