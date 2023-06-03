//
//  CustomView.swift
//  Kredivo
//
//  Created by Nugroho Arief Widodo on 02/06/23.
//

import UIKit

class CustomView: UIView {
    var edges: UIRectEdge = []
    var corners: CACornerMask = []
    var color: UIColor = .clear
    var thickness: CGFloat = 0
    var isDashPattern = false

    var shapeLayer: CAShapeLayer!

    override class var layerClass: AnyClass {
        return CAShapeLayer.self
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    func commonInit() -> Void {
        shapeLayer = self.layer as? CAShapeLayer
        shapeLayer.fillColor = UIColor.clear.cgColor
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let pth = UIBezierPath()

        if edges.contains(.top) || edges.contains(.all) {
            pth.move(to: CGPoint(x: bounds.minX, y: bounds.minY))
            pth.addLine(to: CGPoint(x: bounds.maxX, y: bounds.minY))
        }

        if edges.contains(.bottom) || edges.contains(.all) {
            pth.move(to: CGPoint(x: bounds.minX, y: bounds.maxY))
            pth.addLine(to: CGPoint(x: bounds.maxX, y: bounds.maxY))
        }

        if edges.contains(.left) || edges.contains(.all) {
            pth.move(to: CGPoint(x: bounds.minX, y: bounds.minY))
            pth.addLine(to: CGPoint(x: bounds.minX, y: bounds.maxY))
        }

        if edges.contains(.right) || edges.contains(.all) {
            pth.move(to: CGPoint(x: bounds.maxX, y: bounds.minY))
            pth.addLine(to: CGPoint(x: bounds.maxX, y: bounds.maxY))
        }

        shapeLayer.lineWidth = thickness
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.path = pth.cgPath

        if !corners.isEmpty {
            shapeLayer.maskedCorners = corners
        }

        if isDashPattern {
            shapeLayer.lineDashPattern = [5, 5]
        }
    }

    public func setBorder(properties: BorderProperties) {
        self.edges = properties.edges
        self.color = properties.color
        self.thickness = properties.thickness
        self.isDashPattern = properties.isDashPattern
        self.corners = properties.corners
        self.cornerRadius = properties.cornerRadius
    }
}
