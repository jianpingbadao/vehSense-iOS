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
       
        let notificationName = Notification.Name.init(gpsNotification)
        NotificationCenter.default.addObserver(self, selector: #selector(MapViewController.updateLocation(notification:)), name: notificationName, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if GPS.shared.isAuth() == false{
            let alertController = UIAlertController(title: NSLocalizedString("Enable location services to use this feature", comment: ""), message: NSLocalizedString("", comment: ""), preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
            let settingsAction = UIAlertAction(title: NSLocalizedString("Settings", comment: ""), style: .default) { (UIAlertAction) in
                UIApplication.shared.openURL(NSURL(string: UIApplicationOpenSettingsURLString)! as URL)
            }
            
            alertController.addAction(cancelAction)
            alertController.addAction(settingsAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    @objc func updateLocation(notification : Notification){
        guard let location = notification.userInfo?["location"] as? CLLocation else { return }
        var region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
    }
}
