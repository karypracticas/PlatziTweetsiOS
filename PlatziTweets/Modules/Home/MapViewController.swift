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
    private var posts = [Post]()
    private var map: MKMapView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupMap()
    }
    
    private func setupMap() {
        map = MKMapView(frame: mapContainer.bounds)
        mapContainer.addSubview(map ?? UIView())
    }


}
