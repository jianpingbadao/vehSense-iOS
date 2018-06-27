//
//  MapViewController.swift
//  vehsense
//
//  Created by Brian Green on 6/19/18.
//  Copyright © 2018 Weida Zhong. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //add turning on and off GPS from Settings
        GPS.shared.startLocating()
        let notificationName = Notification.Name.init(gpsNotification)
        NotificationCenter.default.addObserver(self, selector: #selector(MapViewController.updateLocation(notification:)), name: notificationName, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func updateLocation(notification : Notification){
        guard let location = notification.userInfo?["location"] as? CLLocation else { return }
        var region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
    }
}
