//
//  UIViewController+Extension.swift
//  Movie Manager
//
//  Created by Marky Jordan on 8/23/20.
//  Copyright © 2020 Marky Jordan. All rights reserved.
//

import UIKit

extension UIViewController {
    
    @IBAction func logoutTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
