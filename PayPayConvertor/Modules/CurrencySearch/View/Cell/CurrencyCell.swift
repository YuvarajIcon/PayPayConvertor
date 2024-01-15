//
//  CurrencyCell.swift
//  PayPayConvertor
//
//  Created by Yuvaraj Selvam on 14/01/24.
//

import Foundation
import UIKit
import SnapKit

/**
 Custom UICollectionViewCell for displaying currency information.
 */
class CurrencyCell: UICollectionViewCell {
    private lazy var currencyLabel = {
        let label = UILabel()
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
        contentView.addSubview(currencyLabel)
        currencyLabel.snp.makeConstraints({ $0.edges.equalToSuperview() })
    }
    
/**
     Configures the cell with the provided currency information.
     
     - Parameter string: The currency information to be displayed.
     */
    func configure(with string: String) {
        currencyLabel.text = string
    }
}
