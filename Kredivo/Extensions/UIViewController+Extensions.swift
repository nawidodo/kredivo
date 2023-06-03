//
//  UIViewController+Extensions.swift
//  Kredivo
//
//  Created by Nugroho Arief Widodo on 03/06/23.
//

import UIKit

extension UIViewController {
    @objc func goBack() {
        self.navigationController?.popViewController(animated: true)
    }

    func updateNavBar(image: String = "arrow.left") {
        let backImage: UIImage? = .init(systemName: image)
        let backButton: UIButton = .init()
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        backButton.setImage(backImage, for: .normal)
        backButton.tintColor = .white
        let leftBarButtonItem: UIBarButtonItem = .init(customView: backButton)
        navigationItem.leftBarButtonItem = leftBarButtonItem
    }

    func showMessage(title: String? = nil, message: String, completion: (() -> Void)? = nil) {
        let alertController: UIAlertController = .init(title: title, message: message, preferredStyle: .alert)
        let okAction: UIAlertAction = .init(title: NSLocalizedString("OK", comment: ""), style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: completion)
    }
}
