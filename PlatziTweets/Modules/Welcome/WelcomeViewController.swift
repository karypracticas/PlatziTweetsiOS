//
//  WelcomeViewController.swift
//  PlatziTweets
//
//  Created by Kary on 25/05/20.
//  Copyright © 2020 Kary. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    
    private func setupUI() {
        loginButton.layer.cornerRadius = 25
    }


}
