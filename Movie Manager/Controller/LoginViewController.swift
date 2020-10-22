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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // set text field placeholder text
        emailTextField.text = ""
        passwordTextField.text = ""
    }

    // MARK: - Actions
    
    @IBAction func loginTapped(_ sender: UIButton) {
        setLoggingIn(true)
        TMDBClient.getRequestToken(completionHandler: handleRequestTokenResponse(success:error:))
        performSegue(withIdentifier: "completeLogin", sender: nil)
    }
    
    @IBAction func loginViaWebsiteTapped(_ sender: UIButton) {
        setLoggingIn(true)
        TMDBClient.getRequestToken { (success, error) in
            if success {
                
                // updates the UI with a browser containing the login page
                UIApplication.shared.open(TMDBClient.Endpoints.webAuth.url, options: [:], completionHandler: nil)
            }
        }
    }
    
    // completion handler for getRequestToken
    func handleRequestTokenResponse(success: Bool, error: Error?) {
        if success {
            print(TMDBClient.Auth.requestToken)
            TMDBClient.login(username: self.emailTextField.text ?? "", password: self.passwordTextField.text ?? "", completionHandler: self.handleLoginResponse(success:error:) )
        }
    }
    
    // completion handler for login response
    func handleLoginResponse(success: Bool, error: Error?) {
        print(TMDBClient.Auth.requestToken)
        if success {
            TMDBClient.createSessionId(completionHandler: handleSessionResponse(success:error:))
        }
    }
    
    // completion handler for session response
    func handleSessionResponse(success: Bool, error: Error?) {
        setLoggingIn(false)
        if success {
                self.performSegue(withIdentifier: "completeLogin", sender: nil)
        }
    }
    
    func setLoggingIn(_ loggingIn: Bool) {
        if loggingIn {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        
        // enable/disable UI views
        emailTextField.isEnabled = !loggingIn
        passwordTextField.isEnabled = !loggingIn
        loginButton.isEnabled = !loggingIn
        loginViaWebsiteButton.isEnabled = !loggingIn
    }
}
