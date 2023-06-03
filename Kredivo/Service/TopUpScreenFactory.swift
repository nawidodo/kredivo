//
//  TopUpScreenFactory.swift
//  Kredivo
//
//  Created by Nugroho Arief Widodo on 03/06/23.
//

import UIKit

class TopUpScreenFactory {
    func make() -> UIViewController {
        let topUpVC: TopUpContainerViewController = .init()
        let rootNC: UINavigationController = .init(rootViewController: topUpVC)
        topUpVC.title = "Top Up"
        topUpVC.router = rootNC
        return rootNC
    }
}
