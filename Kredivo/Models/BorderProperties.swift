//
//  BorderProperties.swift
//  Kredivo
//
//  Created by Nugroho Arief Widodo on 03/06/23.
//

import UIKit

struct BorderProperties {
    let edges: UIRectEdge
    let color: UIColor
    let thickness: CGFloat
    var isDashPattern: Bool = false
    var corners: CACornerMask = []
    var cornerRadius: CGFloat = 0.0
}
