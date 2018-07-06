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
import MobileCoreServices

class DataViewController: UIViewController {

    @IBOutlet weak var mphLabel: UILabel!
    
    @IBOutlet weak var bearingLabel: UILabel!
    
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
        NotificationCenter.default.addObserver(self, selector: #selector(DataViewController.updateCoordinates(notification:)), name: Notification.Name.init(gpsNotification), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(DataViewController.updateGyroscope(notification:)), name: Notification.Name.init(gyroscopeNotification), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(DataViewController.updateAccelerometer(notification:)), name: Notification.Name.init(accelerometerNotification), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(DataViewController.updateMagnetometer(notification:)), name: Notification.Name.init(magnetometerNotification), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !Settings.shared.gpsState || !GPS.shared.isAuth(){
            latitudeLabel.text = "---"
            longitudeLabel.text = "---"
            bearingLabel.text = "---"
            mphLabel.text = "0.0"
            
        }
        
        if !Setup.shared.accSelectedState{
            accXLabel.text = "x:"
            accYLabel.text = "y:"
            accZLabel.text = "z:"
        }
        
        if !Setup.shared.magSelectedState{
            magXLabel.text = "x:"
            magYLabel.text = "y:"
            magZLabel.text = "z:"
        }
        
        if !Setup.shared.gyroSelectedState{
            gyroXLabel.text = "x:"
            gyroYLabel.text = "y:"
            gyroZLabel.text = "z:"
        }
        
    }
    
    @objc func updateCoordinates(notification : Notification)
    {
        guard let location = notification.userInfo?["location"] as? CLLocation else { return }
        latitudeLabel.text = String(location.coordinate.latitude)
        longitudeLabel.text = String(location.coordinate.longitude)
        
        bearingLabel.text = String(location.course)
        
        var currentSpeed = location.speed
        currentSpeed = currentSpeed < 0 ? 0 : currentSpeed * 2.23694
        mphLabel.text = String(format: "%.1f", currentSpeed)
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
    
    @IBAction func viewRecordPressed(_ sender: UIButton) {
        VideoHelper.startMediaBrowser(delegate: self, sourceType: .camera)

    }
    
}

extension DataViewController: UIImagePickerControllerDelegate {
}

extension DataViewController: UINavigationControllerDelegate {
}
