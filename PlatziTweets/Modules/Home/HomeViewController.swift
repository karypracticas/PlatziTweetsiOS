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
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getPosts()
    }
    
    private func setupUI() {
        // 1. Asignar datasource
        // 2. Registar celda
        tableView.delegate = self
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
    
    //Método que se encargará de borrar el Post
    private func deletePostAt(indexPath: IndexPath) {
        // 1. Indicar carga al usuario
        SVProgressHUD.show()
        
        // 2. Obtener Id del post que vamos a borrar
        let postId = dataSource[indexPath.row].id
        
        // 3. Preparamos el endpoint para borrar
        let endpoint = Endpoints.delete +  postId
        
        // 4. Consumir el servicio para borrar el post
        SN.delete(endpoint: endpoint) { (reponse: SNResultWithEntity<GeneralResponse, ErrorResponse>) in
            
               //Cerramos indicador de carga
                     SVProgressHUD.dismiss()
                          
                              switch reponse {
                              case .success:
                                 // 1. Borrar el post del datasource
                                self.dataSource.remove(at: indexPath.row)
                                
                                // 2. Borrar la celda de la tabla
                                self.tableView.deleteRows(at: [indexPath], with: .left)
                                
                                
                              case .error(let error):
                                  NotificationBanner(title: "Error",
                                  subtitle: error.localizedDescription,style: .danger).show()
                                  print(error.localizedDescription)
                              case .errorResult(let entity):
                                  NotificationBanner(title: "Error",
                                  subtitle: entity.error,style: .warning).show()
       
                            }
                        }
                    }
                }

//MARK: UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Borrar") { (_, _) in
            //Aquí borramos el tweet
            self.deletePostAt(indexPath: indexPath)
        }
        return [deleteAction]
  
    }
    
    //Restringir para no poder borrar tweets de otros usuarios
    //TODO: Guardar el correo del usuario y validar contra uno real
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return dataSource[indexPath.row].author.email != "noesmimail@test.com"
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
