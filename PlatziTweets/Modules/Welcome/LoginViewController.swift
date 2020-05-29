//
//  LoginViewController.swift
//  PlatziTweets
//
//  Created by Kary on 25/05/20.
//  Copyright © 2020 Kary. All rights reserved.
//

import UIKit
import NotificationBannerSwift
import Simple_Networking //Librería para trabajar la red
import SVProgressHUD //Librería para mostrar indicadores de carga al usuario

class LoginViewController: UIViewController {
    // MARK: - Outlets
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: - Actions
    @IBAction func loginButtonAction() {
        view.endEditing(true)
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
        
        //Crear request
        let request = LoginRequest(email: email, password: password)
        
        //Iniciamos la carga
        SVProgressHUD.show()
        
        //Llamar a librería de red
        SN.post(endpoint: Endpoints.login, model: request) { (response: SNResultWithEntity<LoginResponse, ErrorResponse>) in
        
            
            switch response {
            case .success(let user):
                NotificationBanner(subtitle: "Bienvenido \(user.user.names)",style: .success).show()
                self.performSegue(withIdentifier: "showHome", sender: nil)
                SimpleNetworking.setAuthenticationHeader(prefix: "", token: user.token)
                
            case .error(let error):
                NotificationBanner(subtitle: "Error",style: .danger).show()
                
            case .errorResult(let entity):
                NotificationBanner(subtitle: "Error",style: .warning).show()
                
            }
            
        }
        
        
        
        //Iniciar sesión aquí
        
    }
    
}
