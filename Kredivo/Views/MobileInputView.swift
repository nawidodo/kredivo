//
//  MobileInputView.swift
//  Kredivo
//
//  Created by Nugroho Arief Widodo on 28/05/23.
//

import UIKit

protocol InputViewDelegate {
    func didGet(text: String)
}

class MobileInputView: UIView {
    @IBOutlet var imageOperatorView: UIImageView!
    @IBOutlet var textField: UITextField!

    var delegate: InputViewDelegate?
}

extension MobileInputView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let currentText = textField.text {
            let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
            delegate?.didGet(text: newText)
        }
        return true
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        delegate?.didGet(text: "")
        return true
    }
}
