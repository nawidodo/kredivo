//
//  SnapCenterLayout.swift
//  Kredivo
//
//  Created by Nugroho Arief Widodo on 29/05/23.
//

import UIKit

final class SnapCenterLayout: UICollectionViewFlowLayout {
      override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else { return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity) }
        let parent = super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)

        let itemSpace = itemSize.width + minimumInteritemSpacing
        var currentItemIdx = round(collectionView.contentOffset.x / itemSpace)

        // Skip to the next cell, if there is residual scrolling velocity left.
        // This helps to prevent glitches
        let vX = velocity.x
        if vX > 0 {
          currentItemIdx += 1
        } else if vX < 0 {
          currentItemIdx -= 1
        }

        let nearestPageOffset = currentItemIdx * itemSpace
        return CGPoint(x: nearestPageOffset,
                       y: parent.y)
      }
}
