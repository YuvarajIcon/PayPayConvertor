//
//  BaseViewController.swift
//  PayPayConvertor
//
//  Created by Yuvaraj Selvam on 07/01/24.
//

import Foundation
import UIKit

/**
 BaseViewController

 A custom base class for view controllers providing common functionality.
 */
class BaseViewController: UIViewController {   
    /// Determines whether the keyboard should be dismissed when tapping on the view.
    var dismissKeyboardOnTap: Bool { false }
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }
    
/**
     Presents a simple alert with an "Okay" action button.

     - Parameters:
        - title: The title of the alert.
        - message: The message displayed in the alert.
     */
    func presentAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alertController.addAction(okayAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func configure() {
        if dismissKeyboardOnTap {
            self.addTapDismissKeyboardGesture()
        }
    }
    
    private func addTapDismissKeyboardGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc 
    private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc
    private func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
}
