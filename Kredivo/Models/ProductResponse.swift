//
//  ProductResponse.swift
//  Kredivo
//
//  Created by Nugroho Arief Widodo on 03/06/23.
//

import Foundation

// MARK: - PriceResponse
struct ProductResponse: Codable {
    let status, message: String
    let products: [Product]
}

// MARK: - Product
struct Product: Codable {
    let productCode, billType, label, productOperator: String
    let nominal, description: String
    let price: Double

    enum CodingKeys: String, CodingKey {
        case productCode = "product_code"
        case billType = "bill_type"
        case label
        case productOperator = "operator"
        case nominal, description, price
    }
}
