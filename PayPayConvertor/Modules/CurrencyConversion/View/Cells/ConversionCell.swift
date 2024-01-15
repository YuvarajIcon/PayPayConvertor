//
//  ConversionCell.swift
//  PayPayConvertor
//
//  Created by Yuvaraj Selvam on 14/01/24.
//

import Foundation
import UIKit
import SnapKit

/**
 A custom cell used to display currency conversion information in a collection view.
 */
class ConversionCell: UICollectionViewCell {
    private lazy var containerStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        stack.alignment = .center
        return stack
    }()
    
    private let visualEffectView = {
        let effect = UIBlurEffect(style: .light)
        return UIVisualEffectView(effect: effect)
    }()
    
    private lazy var currencyLabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1)
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private lazy var valueLabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .black
        label.font = .systemFont(ofSize: 22, weight: .heavy)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        layer.masksToBounds = true
        layer.cornerRadius = 12
        contentView.backgroundColor = .clear
        contentView.addSubview(visualEffectView)
        contentView.addSubview(containerStackView)
        containerStackView.addArrangedSubview(currencyLabel)
        containerStackView.addArrangedSubview(valueLabel)
        containerStackView.snp.makeConstraints({ make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview()
        })
        visualEffectView.snp.makeConstraints({ $0.edges.equalToSuperview() })        
    }
    
/**
     Configures the cell with currency and value information.
     
     - Parameters:
        - currency: The currency code to be displayed.
        - value: The converted value to be displayed.
     */
    func configure(currency: String, value: Double) {
        currencyLabel.text = currency
        valueLabel.text = "\(value)"
    }
}
