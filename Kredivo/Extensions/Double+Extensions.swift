//
//  Double+Extensions.swift
//  Kredivo
//
//  Created by Nugroho Arief Widodo on 03/06/23.
//

import Foundation

extension Double {
    func toCurrency(symbol: String = "Rp", isBreakSpace: Bool = true) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = symbol
        // Set the grouping separator for thousands
        formatter.usesGroupingSeparator = true
        formatter.currencyGroupingSeparator = "."
        formatter.alwaysShowsDecimalSeparator = false
        formatter.maximumFractionDigits = 0
        formatter.paddingCharacter = ""
        // Remove any non-numeric characters from the input string
        guard let amount = formatter.string(from: NSNumber(value: self)) else { return "Rp0" }
        if isBreakSpace {
            return amount.replacingOccurrences(of: "\u{00A0}", with: "")
        } else {
            return amount
        }
    }
}
