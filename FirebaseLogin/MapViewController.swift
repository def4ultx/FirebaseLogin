//
//  MapViewController.swift
//  FirebaseLogin
//
//  Created by bally on 11/24/17.
//  Copyright © 2017 bally. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var navigationBar: UINavigationItem!
    var userData:User?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        // Do any additional setup after loading the view.
        self.loadUserData(userData: userData!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func loadUserData(userData: User) {
        self.navigationItem.title = userData.Username
        let location = CLLocationCoordinate2DMake(userData.Latitude!, userData.Longtitude!)
        let annotation = MKPointAnnotation();
        annotation.coordinate = location;
        mapView.addAnnotation(annotation);
        self.setCenterOfMapToLocation(location: location)
    }
    
    private func setCenterOfMapToLocation(location: CLLocationCoordinate2D) {
        let coordinate = CLLocationCoordinate2DMake(location.latitude, location.longitude)
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta:0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)
    }
}
