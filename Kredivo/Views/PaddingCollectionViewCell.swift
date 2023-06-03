//
//  PaddingCollectionViewCell.swift
//  Kredivo
//
//  Created by Nugroho Arief Widodo on 29/05/23.
//

import UIKit

class PaddingCollectionViewCell: UICollectionViewCell {
    public var customView: UIView?
    public var leadingTrailingConstraint : [NSLayoutConstraint]?
    public var topBottomConstraint : [NSLayoutConstraint]?

    public static func dequeueReusableCell(for collectionView: UICollectionView, with reuseIdentifier: String, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        if let bmCell = cell as? PaddingCollectionViewCell {
            bmCell.initializeCustomView(identifier: reuseIdentifier)
        }
        return cell
    }

    private func initializeCustomView(identifier: String) {
        guard let customView: UIView = .getView(with: identifier) else {
            return
        }
        self.customView?.removeFromSuperview()
        self.customView = customView
        contentView.addSubview(customView)
        customView.translatesAutoresizingMaskIntoConstraints = false
        addCustomViewConstraintWith(leading: 0, trailing: 0, bottom: 0, top: 0)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public func setCard(leading: CGFloat, trailing: CGFloat,bottom: CGFloat,top: CGFloat) {

        if let leadingTrailing: [NSLayoutConstraint] = leadingTrailingConstraint {
            contentView.removeConstraints(leadingTrailing)
        }
        if let topBottom: [NSLayoutConstraint] = topBottomConstraint {
            contentView.removeConstraints(topBottom)
        }
        addCustomViewConstraintWith(leading: leading, trailing: trailing,bottom: bottom,top: top)
    }

    private func addCustomViewConstraintWith(leading: CGFloat, trailing: CGFloat,bottom: CGFloat,top: CGFloat) {

        if let tempView: UIView = customView {
            let leadingTrailing: [NSLayoutConstraint] = NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(leading)-[view]-\(trailing)-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view":tempView])
            contentView.addConstraints(leadingTrailing)
            leadingTrailingConstraint = leadingTrailing

            let topBottom: [NSLayoutConstraint] = NSLayoutConstraint.constraints(withVisualFormat: "V:|-\(top)-[view]-\(bottom)-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view":tempView])
            contentView.addConstraints(topBottom)
            topBottomConstraint = topBottom
        }
    }
}
