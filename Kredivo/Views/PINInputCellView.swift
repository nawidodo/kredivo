//
//  PINInputCellView.swift
//  Kredivo
//
//  Created by Nugroho Arief Widodo on 02/06/23.
//

import UIKit

class PINInputCellView: UIView {

    @IBOutlet var showHideButton: UIButton!
    @IBOutlet var pinTextField: UITextField!
    @IBAction func didTapShowHide(_ sender: UIButton) {
        let isHidden = pinTextField.isSecureTextEntry
        pinTextField.isSecureTextEntry = !isHidden
        let icon = isHidden ? "eye.fill" : "eye.slash.fill"
        sender.setImage(UIImage(systemName: icon), for: .normal)
    }

    var delegate: InputViewDelegate?

    override func layoutSubviews() {
        super.layoutSubviews()
        pinTextField.becomeFirstResponder()
    }
}

extension PINInputCellView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if let currentText = textField.text {
            let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
            delegate?.didGet(text: newText)
        }
        return true
    }
}
