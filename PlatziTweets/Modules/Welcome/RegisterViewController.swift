//
//  RegisterViewController.swift
//  PlatziTweets
//
//  Created by Kary on 25/05/20.
//  Copyright © 2020 Kary. All rights reserved.
//

import UIKit
import  NotificationBannerSwift

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
        
        performSegue(withIdentifier: "showHome", sender: nil)

}

}
