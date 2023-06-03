//
//  TransactionResponse.swift
//  Kredivo
//
//  Created by Nugroho Arief Widodo on 03/06/23.
//

import Foundation

// MARK: - TransactionResponse
struct TransactionResponse: Codable {
    let message, status: String
    let transactionContext: TransactionContext

    enum CodingKeys: String, CodingKey {
        case message, status
        case transactionContext = "transaction_context"
    }
}

// MARK: - TransactionContext
struct TransactionContext: Codable {
    let transactionStatus: Int
    let merchantDetails: MerchantDetails
    let appliedPaymentType, checkoutAmount, orderID: String
    let itemList: [ItemList]
    let expirationTime, amount, transactionToken: String

    enum CodingKeys: String, CodingKey {
        case transactionStatus = "transaction_status"
        case merchantDetails = "merchant_details"
        case appliedPaymentType = "applied_payment_type"
        case checkoutAmount = "checkout_amount"
        case orderID = "order_id"
        case itemList = "item_list"
        case expirationTime = "expiration_time"
        case amount
        case transactionToken = "transaction_token"
    }
}

// MARK: - ItemList
struct ItemList: Codable {
    let aggregatedPrice: String
    let quantity: Int
    let status, unitPrice, totalAmount: String
    let pID, skuType: Int
    let name, category, sku: String

    enum CodingKeys: String, CodingKey {
        case aggregatedPrice = "aggregated_price"
        case quantity, status
        case unitPrice = "unit_price"
        case totalAmount = "total_amount"
        case pID = "p_id"
        case skuType = "sku_type"
        case name, category, sku
    }
}

// MARK: - MerchantDetails
struct MerchantDetails: Codable {
    let logoURL: String
    let name: String

    enum CodingKeys: String, CodingKey {
        case logoURL = "logo_url"
        case name
    }
}


