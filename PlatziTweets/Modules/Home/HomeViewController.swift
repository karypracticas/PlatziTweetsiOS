//
//  HomeViewController.swift
//  PlatziTweets
//
//  Created by Kary on 28/05/20.
//  Copyright © 2020 Kary. All rights reserved.
//

import UIKit
import Simple_Networking
import SVProgressHUD
import NotificationBannerSwift

class HomeViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Properties
    private let cellId = "TweetTableViewCell"
    private var dataSource = [Post]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getPosts()
    }
    
    private func setupUI() {
        // 1. Asignar datasource
        // 2. Registar celda
        tableView.dataSource = self
        tableView.register(UINib(nibName: cellId, bundle: nil), forCellReuseIdentifier: cellId )
    }
    
    private func getPosts() {
        //1. Indicar carga al usuario
        SVProgressHUD.show()
        
        //Consumir el servicio
        SN.get(endpoint: Endpoints.getPosts) { (response: SNResultWithEntity<[Post], ErrorResponse>) in
            //Cerramos indicador de carga
            SVProgressHUD.dismiss()
                 
                     switch response {
                     case .success(let posts):
                        self.dataSource = posts
                        self.tableView.reloadData()
                     case .error(let error):
                         NotificationBanner(subtitle: "Error",style: .danger).show()
                     case .errorResult(let entity):
                         NotificationBanner(subtitle: "Error",style: .warning).show()
                         
                     
                     
                 }
        }
    }
}

//MARK: UITableViewDataSource

extension HomeViewController: UITableViewDataSource {
    // Número total de celdas
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    //Configurar celda deseada
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        if let cell =  cell as? TweetTableViewCell {
            //Configurar la celda
            cell.setupCellWith(post: dataSource[indexPath.row])
            
        }
        return cell
    }
}
