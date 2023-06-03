//
//  VoucherResponse.swift
//  Kredivo
//
//  Created by Nugroho Arief Widodo on 03/06/23.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let voucherResponse = try? JSONDecoder().decode(VoucherResponse.self, from: jsonData)

import Foundation

// MARK: - VoucherResponse
struct VoucherResponse: Codable {
    let data: [Voucher]
    let status: String
}

// MARK: - Datum
struct Voucher: Codable {
    let name: String
    let number, percentage, iterator: Int
    let imageURL: String
    let minTransactionAmount: Int
    let endDate: String
    let id: Int
    let termsAndCondition, howToUse: String
    let usageCount: Int
    let startDate: String
    let maxDiscount: Int?
    let voucherCode: String
    let datumMaxDiscount: Int?

    enum CodingKeys: String, CodingKey {
        case name, number, percentage, iterator
        case imageURL = "image_url"
        case minTransactionAmount = "min_transaction_amount"
        case endDate = "end_date"
        case id
        case termsAndCondition = "terms_and_condition"
        case howToUse = "how_to_use"
        case usageCount = "usage_count"
        case startDate = "start_date"
        case maxDiscount = "Max_discount"
        case voucherCode = "voucher_code"
        case datumMaxDiscount = "max_discount"
    }

    func dateFormatter() -> DateFormatter {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM yyyy"
        dateFormatter.locale = Locale(identifier: "id_ID")

        return dateFormatter
    }

    func dateText() -> String? {
        guard let start = TimeInterval(startDate), let end = TimeInterval(endDate) else {return nil}

        let calendar = Calendar.current

        let firstDate = Date(timeIntervalSince1970: start)
        let secondDate = Date(timeIntervalSince1970: end)

        let firstComponents = calendar.dateComponents([.year, .month, .day], from: firstDate)
        let secondComponents = calendar.dateComponents([.year, .month, .day], from: secondDate)

        let formatter = dateFormatter()

        guard let firstYear = firstComponents.year, let firstMonth = firstComponents.month,
              let secondYear = secondComponents.year, let secondMonth = secondComponents.month, firstYear == secondYear, firstMonth == secondMonth else {
            return "\(formatter.string(from: firstDate)) - \(formatter.string(from: secondDate))"
        }

        let prefix = firstComponents.day!
        return "\(prefix) - \(formatter.string(from: secondDate))"
    }

    func validUntilText() -> String {
        let formatter = dateFormatter()
        guard let end = TimeInterval(endDate) else {return ""}
        let voucherEndDate = Date(timeIntervalSince1970: end)
        return formatter.string(from: voucherEndDate)
    }
}
