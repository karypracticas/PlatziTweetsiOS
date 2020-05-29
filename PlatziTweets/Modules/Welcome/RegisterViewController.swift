//
//  RegisterViewController.swift
//  PlatziTweets
//
//  Created by Kary on 25/05/20.
//  Copyright © 2020 Kary. All rights reserved.
//

import UIKit
import NotificationBannerSwift
import Simple_Networking
import SVProgressHUD

class RegisterViewController: UIViewController {
    // MARK: - Outlets

    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var namesTextField: UITextField!
    
       
       // MARK: - Actions
       @IBAction func registerButtonAction() {
        view.endEditing(true)
         performregister()
       }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     setupUI()
     
    }
    
    private func setupUI() {
        registerButton.layer.cornerRadius = 25
    }
    
    private func performregister() {
        guard let email = emailTextField.text, !email.isEmpty else {
            NotificationBanner(title: "Error", subtitle: "Ingrese un correo electronico",style: .warning).show()
            
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            NotificationBanner(title: "Error", subtitle: "El campo password no puede estar vacio",style: .warning).show()
            
            return
        }
    
        guard let names = namesTextField.text, !names.isEmpty else {
            NotificationBanner(title: "Error", subtitle: "Ingresa nombre y apellido",style: .warning).show()
            
            return
        }
        
        
        //Hacer request
        let request = RegisterRequest(email: email, password: password, names: names)
        
        //Iniciamos la carga
             SVProgressHUD.show()
             
             //Llamar a librería de red
             SN.post(endpoint: Endpoints.register, model: request) { (response: SNResultWithEntity<LoginResponse, ErrorResponse>) in
             
                 
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

}

}
