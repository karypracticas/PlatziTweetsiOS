//
//  LoginViewController.swift
//  PlatziTweets
//
//  Created by Kary on 25/05/20.
//  Copyright © 2020 Kary. All rights reserved.
//

import UIKit
import NotificationBannerSwift

class LoginViewController: UIViewController {
    // MARK: - Outlets
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: - Actions
    @IBAction func loginButtonAction() {
        performLogin()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        loginButton.layer.cornerRadius = 25
    }
    
    private func performLogin() {
        guard let email = emailTextField.text, !email.isEmpty else {
            NotificationBanner(title: "Error", subtitle: "Ingrese un correo electronico",style: .warning).show()
            
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            NotificationBanner(title: "Error", subtitle: "El campo password no puede estar vacio",style: .warning).show()
            
            return
        }
        
        
    }
}
