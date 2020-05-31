//
//  AddPostViewController.swift
//  PlatziTweets
//
//  Created by Kary on 30/05/20.
//  Copyright © 2020 Kary. All rights reserved.
//

import UIKit

class AddPostViewController: UIViewController {
    // MARK: - IBoutlets
    @IBOutlet weak var postTextView: UITextView!
    
    // MARK: - IBActions
    @IBAction func addPostAction() {
        
    }
    
    @IBAction func dismissAction() {
        //Botón Volver
       dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
     
    }
}
