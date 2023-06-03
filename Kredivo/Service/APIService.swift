//
//  APIService.swift
//  Kredivo
//
//  Created by Nugroho Arief Widodo on 03/06/23.
//

import Foundation

class APIService {
    func getPrices() async -> [Product] {
        guard let fileURL = Bundle.main.url(forResource: "ProductResponse", withExtension: "json"),
              let data = try? Data(contentsOf: fileURL),
              let response = try? JSONDecoder().decode(ProductResponse.self, from: data) else { return [] }
        return response.products
    }

    func getVouchers() async -> [Voucher] {
        guard let fileURL = Bundle.main.url(forResource: "VoucherResponse", withExtension: "json"), let data = try? Data(contentsOf: fileURL), let response = try? JSONDecoder().decode(VoucherResponse.self, from: data) else { return [] }
        return response.data
    }

    func getTransaction() async -> TransactionContext? {
        guard let fileURL = Bundle.main.url(forResource: "TransactionResponse", withExtension: "json"), let data = try? Data(contentsOf: fileURL), let response = try? JSONDecoder().decode(TransactionResponse.self, from: data) else { return nil }
        return response.transactionContext
    }
}
