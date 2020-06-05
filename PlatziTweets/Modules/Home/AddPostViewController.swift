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
import AVFoundation
import AVKit
import MobileCoreServices
import CoreLocation

class AddPostViewController: UIViewController {
    // MARK: - IBoutlets
    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var videoButton: UIButton!
    
    // MARK: - IBActions
    @IBAction func openCameraAction() {
        //Darle al usuario la opción de al abrir la cámara, seleccionar foto o video - Muestra un diálogo nativo
        let alert = UIAlertController(title: "Cámara",
                                      message: "Selecciona una opción",
                                      preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Foto", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Video", style: .default, handler: { _ in
            self.openVideoCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .destructive, handler: nil))
        
        //Presentar alert
        present(alert, animated: true, completion: nil)
        
        openCamera()
    }
    
    @IBAction func addPostAction() {
        uploadVideoToFirebase()
        //uploadPhotoToFirebase()
        
    }
    @IBAction func openPreviewAction() {
        guard let currentVideoURL = currentVideoURL else{
            return
        }
        
        
        //AVPlayer es el video
        let avPlayer = AVPlayer(url: currentVideoURL)
        // AVPlayerViewController es el que levanta la pantalla con el video
        let avPlayerController = AVPlayerViewController()
        avPlayerController.player = avPlayer
        //Método que presenta nuevas pantallas
        present(avPlayerController, animated: true) {
            //Reproducir el video automáticamente cuando se abra la pantalla
            avPlayerController.player?.play()
        }
    }
    
    @IBAction func dismissAction() {
        //Botón Volver
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Properties
    private var imagePicker: UIImagePickerController?
    private var currentVideoURL: URL?
    private var locationManager: CLLocationManager?
    private var userLocation: CLLocation?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestLocation()
        videoButton.isHidden = true
        
    }
    
    private func requestLocation() {
        //Validamos que el usuario tenga el GPS activo y disponible
        guard CLLocationManager.locationServicesEnabled() else {
            return
        }
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestAlwaysAuthorization()
        locationManager?.startUpdatingLocation()
    }
    
    private func openVideoCamera() {
           imagePicker = UIImagePickerController()
           imagePicker?.sourceType = .camera
           imagePicker?.mediaTypes = [kUTTypeMovie as String]
           imagePicker?.cameraFlashMode = .off
           imagePicker?.cameraCaptureMode = .video
           imagePicker?.videoQuality = .typeMedium
           imagePicker?.videoMaximumDuration = TimeInterval(5)
           imagePicker?.allowsEditing = true
           imagePicker?.delegate = self
           
           guard let imagePicker = imagePicker else {
               return
           }
           present(imagePicker, animated: true, completion: nil)
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
                        let downloadUrl = url?.absoluteString ?? ""
                        self.savePost(imageUrl: downloadUrl,videoUrl: nil )
                    }
                    
                }
            }
        }
    }
    
    private func uploadVideoToFirebase() {
        // 1. Asegurarnos de que el video exista
        // 2. Convertir en Data el video
        guard
            let currentVideoSavedURL = currentVideoURL,
            let videoData: Data = try? Data(contentsOf: currentVideoSavedURL) else {
                
                return
        }
        //Indicar la carga al usuario
        SVProgressHUD.show()
        
        // 3. Configuracion para guardar la foto en Firebase
        let metaDataConfig = StorageMetadata()
        metaDataConfig.contentType = "video/MP4"
        
        // 4. Referencia al Storage de firebase
        let storage = Storage.storage()
        
        // 5.Crear nombre de la imagen a subir, se genera un número random para no sobre escribir fotos previas
        let videoName = Int.random(in: 100...1000)
        
        // 6. Referencia a la carpeta donde se va a guardar la foto
        let folderReference = storage.reference(withPath: "videoTweets/\(videoName).mp4")
        
        // 7. Subir el video a firebase
        DispatchQueue.global(qos: .background).async {
            folderReference.putData(videoData, metadata: metaDataConfig) { (metaData: StorageMetadata?,error: Error?) in
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
                        let downloadUrl = url?.absoluteString ?? ""
                        self.savePost(imageUrl: nil, videoUrl: downloadUrl)
                    }
                    
                }
            }
        }
    }
    
    private func savePost(imageUrl: String?, videoUrl: String?) {
        // 1. Crear request
        let request = PostRequest(text: postTextView.text, imageUrl: imageUrl, videoUrl: videoUrl, location: nil)
        
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
        
        //Capturar imagen
        if info.keys.contains(.originalImage) {
            previewImageView.isHidden = false
            
            //Obtenemos la imagen tomada
            previewImageView.image = info[.originalImage] as? UIImage
        }
        
        //Aquí capturamos la URL del video
        if info.keys.contains(.mediaURL), let recordedVideoUrl = (info[.mediaURL] as? URL)?.absoluteURL {
            //Solo mostrará el botón del video, cuando haya un video guardado
            videoButton.isHidden = false
            currentVideoURL = recordedVideoUrl
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension AddPostViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //Obtenemos la última ubicación
        guard let bestLocation = locations.last else {
            return
        }
        //Ya tenemos la ubicación del usuario :)
        userLocation = bestLocation
    }
}
