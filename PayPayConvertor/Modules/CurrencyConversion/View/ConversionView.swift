//
//  ConversionView.swift
//  PayPayConvertor
//
//  Created by Yuvaraj Selvam on 14/01/24.
//

import Foundation
import UIKit
import SnapKit

protocol ConversionViewDelegate: AnyObject {
    func didEnterValue(as: Double)
    func didTapChangeCurrency()
}

/**
 A custom view for displaying and entering currency conversion information.
 */
class ConversionView: UIView {
    private lazy var textField = {
        let textField = PaddedTextField(frame: bounds)
        textField.delegate = self
        textField.backgroundColor = .systemGroupedBackground
        textField.layer.cornerRadius = 12
        textField.keyboardType = .decimalPad
        return textField
    }()
    
    private lazy var currencyLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32, weight: .semibold)
        return label
    }()
    
    private lazy var changeCurrencyButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 4
        button.backgroundColor = .black
        button.setTitle("  Change Currency  ", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12, weight: .semibold)
        button.addTarget(self, action: #selector(didTapChange), for: .touchUpInside)
        return button
    }()
    
    weak var delegate: ConversionViewDelegate?
    private var currency: String = ""
    
    init() {
        super.init(frame: .zero)
        self.setupView()
    }
    
    @available(*, unavailable, message: "use `init()` instead")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        layer.cornerRadius = 12
        addSubview(currencyLabel)
        addSubview(textField)
        addSubview(changeCurrencyButton)
        textField.snp.makeConstraints({ make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16)
            make.width.equalTo(124)
            make.height.equalTo(48)
        })
        currencyLabel.snp.makeConstraints({ make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalTo(textField.snp.trailing).offset(8)
        })
        changeCurrencyButton.snp.makeConstraints({ make in
            make.leading.equalTo(currencyLabel.snp.trailing).offset(16)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-16)
        })
    }

/**
     Configures the conversion view with a currency code.
     
     - Parameters:
        - currency: The currency code to be displayed.
     */
    func configure(currency: String) {
        currencyLabel.text = currency
    }
    
/**
     Sets the text of the text field.
     
     - Parameters:
        - string: The text to be set in the text field.
     */
    func setText(as string: String) {
        textField.text = string
    }
    
    @objc
    private func didTapChange() {
        delegate?.didTapChangeCurrency()
    }
}

//MARK: TextFieldDelegate Extension
extension ConversionView: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard var text = textField.text else { return }
        if text.isEmpty {
            text = "1"
            textField.text = text
        }
        guard let inputValue = Double(text) else { return }
        delegate?.didEnterValue(as: inputValue)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textField.text ?? "") as NSString
        let newText = currentText.replacingCharacters(in: range, with: string)
        return isValidDouble(text: newText)
    }

    private func isValidDouble(text: String) -> Bool {
        guard text.isEmpty == false else { return true }
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.number(from: text) != nil
    }
}
