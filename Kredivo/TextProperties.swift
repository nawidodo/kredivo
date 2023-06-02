//
//  TextProperties.swift
//  Kredivo
//
//  Created by Nugroho Arief Widodo on 01/06/23.
//

import UIKit

struct TextProperties {
    let text: String
    let color: UIColor
    let size: CGFloat
    let weight: UIFont.Weight
    var background: UIColor = .clear
}

struct BorderProperties {
    let edges: UIRectEdge
    let color: UIColor
    let thickness: CGFloat
    var isDashPattern: Bool = false
    var corners: CACornerMask = []
    var cornerRadius: CGFloat = 0.0
}

struct DetailProperties {
    let title: TextProperties
    let content: TextProperties
    let border: BorderProperties?
}
