//
//  DataViewController.swift
//  vehsense
//
//  Created by Brian Green on 6/21/18.
//  Copyright © 2018 Weida Zhong. All rights reserved.
//

import UIKit
import CoreLocation
import CoreMotion

class DataViewController: UIViewController {

    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    
    @IBOutlet weak var gyroXLabel: UILabel!
    @IBOutlet weak var gyroYLabel: UILabel!
    @IBOutlet weak var gyroZLabel: UILabel!
    
    @IBOutlet weak var accXLabel: UILabel!
    @IBOutlet weak var accYLabel: UILabel!
    @IBOutlet weak var accZLabel: UILabel!
    
    @IBOutlet weak var magXLabel: UILabel!
    @IBOutlet weak var magYLabel: UILabel!
    @IBOutlet weak var magZLabel: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //add start locating to settings
        GPS.shared.startLocating()

        NotificationCenter.default.addObserver(self, selector: #selector(DataViewController.updateCoordinates(notification:)), name: Notification.Name.init(gpsNotification), object: nil)
        
        //add start gyroscope to settings
        Gyroscope.shared.startGyroscope()
        
        NotificationCenter.default.addObserver(self, selector: #selector(DataViewController.updateGyroscope(notification:)), name: Notification.Name.init(gyroscopeNotification), object: nil)
        
        //add start accelerometer to settings
        Accelerometer.shared.startAccelerometer()
        
        NotificationCenter.default.addObserver(self, selector: #selector(DataViewController.updateAccelerometer(notification:)), name: Notification.Name.init(accelerometerNotification), object: nil)
        
        Magnetometer.shared.startMagnetometer()
        
        NotificationCenter.default.addObserver(self, selector: #selector(DataViewController.updateMagnetometer(notification:)), name: Notification.Name.init(magnetometerNotification), object: nil)
   

    }
    
    @objc func updateCoordinates(notification : Notification)
    {
        guard let location = notification.userInfo?["location"] as? CLLocation else { return }
        latitudeLabel.text = String(location.coordinate.latitude)
        longitudeLabel.text = String(location.coordinate.longitude)
    }
    
    @objc func updateGyroscope(notification : Notification)
    {
        guard let gyroData = notification.userInfo?["gyroData"] as? CMGyroData else { return }
        gyroXLabel.text = "x: \(gyroData.rotationRate.x )"
        gyroYLabel.text = "y: \(gyroData.rotationRate.y )"
        gyroZLabel.text = "z: \(gyroData.rotationRate.z )"
    }
    
    @objc func updateAccelerometer(notification : Notification)
    {
        guard let accData = notification.userInfo?["accData"] as? CMAccelerometerData else { return }
        
        accXLabel.text = "x: \(accData.acceleration.x)"
        accYLabel.text = "y: \(accData.acceleration.y)"
        accZLabel.text = "z: \(accData.acceleration.z)"
    }
    
    @objc func updateMagnetometer(notification : Notification)
    {
        guard let magData = notification.userInfo?["magData"] as? CMMagnetometerData else { return }
        
        magXLabel.text = "x: \(magData.magneticField.x)"
        magYLabel.text = "y: \(magData.magneticField.y)"
        magZLabel.text = "z: \(magData.magneticField.z)"
    }
    
}
