//
//  UIViewController+HideKeyboardStopEditing.swift
//  Diabetes
//
//  Created by Shirsat, Amit on 8/24/17.
//  Copyright © 2017 Malhotra, Neil. All rights reserved.
//

import Foundation
import UIKit
extension UIViewController
{
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard()
    {
        view.endEditing(true)
    }
}
