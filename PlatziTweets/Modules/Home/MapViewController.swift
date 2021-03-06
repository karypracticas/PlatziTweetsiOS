//
//  MapViewController.swift
//  PlatziTweets
//
//  Created by Kary on 05/06/20.
//  Copyright © 2020 Kary. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    //MARK: - IBOutlets
    @IBOutlet weak var mapContainer: UIView!
    
    //MARK: - Properties
    var posts = [Post]()
    private var map: MKMapView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupMap()
    }
    
    private func setupMap() {
        map = MKMapView(frame: mapContainer.bounds)
        mapContainer.addSubview(map ?? UIView())
        setupMarkers()
    }
    
    private func setupMarkers() {
        posts.forEach { item in
            let marker = MKPointAnnotation()
            marker.coordinate = CLLocationCoordinate2D(latitude: item.location.latitude, longitude: item.location.longitude)
            
            marker.title = item.text
            marker.subtitle = item.author.names
            
            map?.addAnnotation(marker)
        }
        
        //Buscamos el último Post del arreglo
        guard let lastPost = posts.last else {
            return
        }
        let lastPostLocation = CLLocationCoordinate2D(latitude: lastPost.location.latitude,
                                                      longitude: lastPost.location.longitude)
        guard let heading = CLLocationDirection(exactly: 12) else {
            return
        }
        
        map?.camera = MKMapCamera(lookingAtCenter: lastPostLocation, fromDistance: 30, pitch: .zero, heading: heading)
    }

}
