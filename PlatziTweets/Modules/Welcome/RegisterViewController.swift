//
//  RegisterViewController.swift
//  PlatziTweets
//
//  Created by Kary on 25/05/20.
//  Copyright © 2020 Kary. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    // MARK: - Outlets

    @IBOutlet weak var registerButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     setupUI()
     
    }
    
    private func setupUI() {
        registerButton.layer.cornerRadius = 25
    }
    

}
