//
//  Extensions.swift
//  HappyDemo
//
//  Created by Huong Do on 8/30/20.
//

import UIKit

// MARK: Dismiss keyboard
extension UIApplication {
    func endEditing() {
        windows.forEach { $0.endEditing(false) }
    }
}

extension Array where Element:Equatable {
    func removeDuplicates() -> [Element] {
        var result = [Element]()

        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }

        return result
    }
}
