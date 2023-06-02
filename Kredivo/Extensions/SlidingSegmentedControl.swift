//
//  NSSlidingSegmentedControl.swift
//  Kredivo
//
//  Created by Nugroho Arief Widodo on 28/05/23.
//

import UIKit

open class SlidingSegmentedControl: UISegmentedControl {

    // MARK: - Underline config
    public var controlHeight: CGFloat = 41 {
        didSet {
            addUnderline()
        }
    }

    public var underlineHeight: CGFloat = 2 {
        didSet {
            addUnderline()
        }
    }

    public var underlineColor = UIColor.blue {
        didSet {
            addUnderline()
        }
    }

    // MARK: - Fonts
    public var selectedFont: UIFont? {
        didSet {
            configureFonts()
        }
    }

    public var unselectedFont: UIFont? {
        didSet {
            configureFonts()
        }
    }

    public var selectedTextColor = UIColor.blue {
        didSet {
            configureFonts()
        }
    }

    public var unselectedTextColor = UIColor.gray {
        didSet {
            configureFonts()
        }
    }

    // MARK: - Private properties
    private let underline = UIView()
    private var underlineWidth: CGFloat = 0
    private var selectedSegmentIndexToken: NSKeyValueObservation?
    private var numberOfSegmentsToken: NSKeyValueObservation?
    private var widthToken: NSKeyValueObservation?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }

    // MARK: - Set up methods
    private func setUp() {
        removeDefaultStyles()
        heightAnchor.constraint(equalToConstant: controlHeight).isActive = true
        configureFonts()
        addUnderline()

        selectedSegmentIndexToken = observe(\.selectedSegmentIndex) { (_, _) in
            self.moveUnderline(to: self.selectedSegmentIndex)
        }

        numberOfSegmentsToken = observe(\.numberOfSegments, changeHandler: { (_, _) in
            self.addUnderline()
        })

        widthToken = observe(\.bounds, changeHandler: { (_, _) in
            self.addUnderline()
        })
    }

    deinit {
        selectedSegmentIndexToken = nil
        numberOfSegmentsToken = nil
        widthToken = nil
    }

    private func addUnderline() {
        underline.removeFromSuperview()
        underlineWidth = bounds.size.width / CGFloat(numberOfSegments)
        let startY = controlHeight - underlineHeight
        underline.backgroundColor = underlineColor
        underline.frame = CGRect(x: 0, y: startY, width: underlineWidth, height: underlineHeight)
        addSubview(underline)
    }

    private func moveUnderline(to index: Int) {
        let newX = underlineWidth * CGFloat(index)
        let y = controlHeight - underlineHeight

        UIView.animate(withDuration: 0.25) {
            self.underline.frame = CGRect(x: newX, y: y, width: self.underlineWidth, height: self.underlineHeight)
        }
    }

    private func configureFonts() {
        guard let selectedFont = selectedFont, let unselectedFont = unselectedFont else { return }
        setTitleTextAttributes([
            .font: selectedFont,
            .foregroundColor: selectedTextColor,
            ], for: .selected)

        setTitleTextAttributes([
            .font: unselectedFont,
            .foregroundColor: unselectedTextColor,
            ], for: .normal)
    }

    private func removeDefaultStyles() {
        setBackgroundImage(imageWithColor(color: .clear), for: .normal, barMetrics: .default)
        setBackgroundImage(imageWithColor(color: .clear), for: .highlighted, barMetrics: .default)
        setBackgroundImage(imageWithColor(color: .clear), for: .selected, barMetrics: .default)
        setDividerImage(imageWithColor(color: .clear), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
    }

    private func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width:  1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        guard let context = UIGraphicsGetCurrentContext() else { return UIImage() }
        context.setFillColor(color.cgColor);
        context.fill(rect);
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return image ?? UIImage()

    }
}
