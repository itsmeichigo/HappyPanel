//
//  Extensions.swift
//  HappyDemo
//
//  Created by ichigo on 10/07/2021.
//

import UIKit

// MARK: Dismiss keyboard
extension UIApplication {
    func endEditing() {
        windows.forEach { $0.endEditing(false) }
    }
}
