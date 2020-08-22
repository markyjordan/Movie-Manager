//
//  LoginViewController.swift
//  Movie Manager
//
//  Created by Marky Jordan on 8/17/20.
//  Copyright © 2020 Marky Jordan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: - Outlets/Properties
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginViaWebsiteButton: UIButton!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // set text field placeholder text
        emailTextField.text = ""
        passwordTextField.text = ""
    }

    // MARK: - Actions
    
    @IBAction func loginTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "completeLogin", sender: nil)
    }
    
    @IBAction func loginViaWebsiteTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "completeLogin", sender: nil)
    }
}
