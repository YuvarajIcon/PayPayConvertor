//
//  PaddedTextField.swift
//  PayPayConvertor
//
//  Created by Yuvaraj Selvam on 14/01/24.
//

import Foundation
import UIKit
/**
 PaddedTextField

 A custom text field with padding for better aesthetics.
 */
class PaddedTextField: UITextField {
    struct Constants {
        static let sidePadding: CGFloat = 10
        static let topPadding: CGFloat = 8
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(
            x: bounds.origin.x + Constants.sidePadding,
            y: bounds.origin.y + Constants.topPadding,
            width: bounds.size.width - Constants.sidePadding * 2,
            height: bounds.size.height - Constants.topPadding * 2
        )
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return self.textRect(forBounds: bounds)
    }
}
