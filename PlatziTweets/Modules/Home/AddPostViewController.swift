//
//  AddPostViewController.swift
//  PlatziTweets
//
//  Created by Kary on 30/05/20.
//  Copyright © 2020 Kary. All rights reserved.
//

import UIKit
import Simple_Networking
import SVProgressHUD
import NotificationBannerSwift
import FirebaseStorage

class AddPostViewController: UIViewController {
    // MARK: - IBoutlets
    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var previewImageView: UIImageView!
    
    // MARK: - IBActions
    @IBAction func openCameraAction() {
        openCamera()
    }
    
    @IBAction func addPostAction() {
        savePost()
        
    }
    
    @IBAction func dismissAction() {
        //Botón Volver
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Properties
    private var imagePicker: UIImagePickerController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    private func openCamera() {
        imagePicker = UIImagePickerController()
        imagePicker?.sourceType = .camera
        imagePicker?.cameraFlashMode = .off
        imagePicker?.cameraCaptureMode = .photo
        imagePicker?.allowsEditing = true
        imagePicker?.delegate = self
        
        guard let imagePicker = imagePicker else {
            return
        }
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func uploadPhotoToFirebase() {
        // 1. Asegurarnos de que la foto exista
        // 2. Comprimir la imagen y convertirla en Data
        guard
            let imageSaved = previewImageView.image,
           
            let imageSavedData: Data = imageSaved.jpegData(compressionQuality: 0.1) else {
                
                return
        }
        //Indicar la carga al usuario
        SVProgressHUD.show()
        
        // 3. Configuracion para guardar la foto en Firebase
        let metaDataConfig = StorageMetadata()
        metaDataConfig.contentType = "image/jpg"
        
        // 4. Referencia al Storage de firebase
        let storage = Storage.storage()
        
        // 5.Crear nombre de la imagen a subir, se genera un número random para no sobre escribir fotos previas
        let imageName = Int.random(in: 100...1000)
        
        // 6. Referencia a la carpeta donde se va a guardar la foto
        let folderReference = storage.reference(withPath: "fotosTweets/\(imageName).jpg")
        
        // 7. Subir la foto a firebase
        DispatchQueue.global(qos: .background).async {
            folderReference.putData(imageSavedData, metadata: metaDataConfig) { (metaData: StorageMetadata?,error: Error?) in
                // Regresar al hilo principal
                DispatchQueue.main.async {
                    //Detener la carga
                    SVProgressHUD.dismiss()
                    
                    if let error = error {
                        NotificationBanner(title: "Error" ,subtitle: error.localizedDescription,style: .warning).show()
                        return
                    }
                    // Obtener la URL de descarga
                    folderReference.downloadURL { (url: URL?, error: Error?) in
                        print(url?.absoluteURL ?? "")
                    }
                    
                }
            }
        }
    }
    
    private func savePost() {
        uploadPhotoToFirebase()
        
        return
        // 1. Crear request
        let request = PostRequest(text: postTextView.text, imageUrl: nil, videoUrl: nil)
        
        // 2. Indicar carga al usuario
        SVProgressHUD.show()
        
        // 3. Llamar al servicio del post
        SN.post(endpoint: Endpoints.post,
                model: request) { (response:  SNResultWithEntity<Post, ErrorResponse>) in
                    // 4. Cerrar indicador de carga
                    SVProgressHUD.dismiss()
                    
                    switch response {
                    case .success(let post):
                        self.dismiss(animated: true, completion: nil)
                    case .error(let error):
                        NotificationBanner(subtitle: "Error",style: .danger).show()
                    case .errorResult(let entity):
                        NotificationBanner(subtitle: "Error",style: .warning).show()
                        
                        
            }
        }
    }
}

//MARK: - UIImagePickerControllerDelegate
extension AddPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        //Cerrar cámara
        imagePicker?.dismiss(animated: true, completion: nil)
        
        if info.keys.contains(.originalImage) {
            previewImageView.isHidden = false
            
            //Obtenemos la imagen tomada
            previewImageView.image = info[.originalImage] as? UIImage
        }
    }
}
