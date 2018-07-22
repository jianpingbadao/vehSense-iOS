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

    @IBOutlet weak var recordButton: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var setupButton: UIBarButtonItem!
    
    @IBOutlet weak var mphLabel: UILabel!
    @IBOutlet weak var latLabel: UILabel!
    @IBOutlet weak var longLabel: UILabel!
    
    @IBOutlet weak var magXLabel: UILabel!
    @IBOutlet weak var magYLabel: UILabel!
    @IBOutlet weak var magZLabel: UILabel!
    
    @IBOutlet weak var accXLabel: UILabel!
    @IBOutlet weak var accYLabel: UILabel!
    @IBOutlet weak var accZLabel: UILabel!
    
    @IBOutlet weak var gyroXLabel: UILabel!
    @IBOutlet weak var gyroYLabel: UILabel!
    @IBOutlet weak var gyroZLabel: UILabel!
    
    @IBOutlet weak var bearingLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        if !Settings.shared.gpsState{
            mphLabel.text = "---"
            latLabel.text = "---"
            longLabel.text = "---"
            bearingLabel.text = "---"
        }
        
        if !Setup.shared.magSelectedState{
            magXLabel.text = "x:"
            magYLabel.text = "y:"
            magZLabel.text = "z:"
        }
        
        if !Setup.shared.accSelectedState{
            accXLabel.text = "x:"
            accYLabel.text = "y:"
            accZLabel.text = "z:"
        }
        
        if !Setup.shared.gyroSelectedState {
            gyroXLabel.text = "x:"
            gyroYLabel.text = "y:"
            gyroZLabel.text = "z"
        }
        
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
  
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(DataViewController.updateCoordinates(notification:)), name: Notification.Name.init(gpsNotification), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(DataViewController.updateGyroscope(notification:)), name: Notification.Name.init(gyroscopeNotification), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(DataViewController.updateAccelerometer(notification:)), name: Notification.Name.init(accelerometerNotification), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(DataViewController.updateMagnetometer(notification:)), name: Notification.Name.init(magnetometerNotification), object: nil)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @objc func updateCoordinates(notification : Notification)
    {
        guard let location = notification.userInfo?["location"] as? CLLocation else { return }
        
        let rawSpeed = Double(location.speed)
        let rawLat = Double(location.coordinate.latitude)
        let rawLong = Double(location.coordinate.longitude)
        let rawBearing = Double(location.course)
        
        latLabel.text = String(rawLat)
        longLabel.text = String(rawLong)
        bearingLabel.text = String(rawBearing)
        
        let rawMPH = rawSpeed < 0 ? 0 : rawSpeed * 2.23694
        mphLabel.text  = String(format: "%.1f", rawMPH)
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
    

    @IBAction func recordButtonPressed(_ sender: UIBarButtonItem) {
        
        if DataRecording.shared.recordingState{
            sender.title = "Start Recording"
            sender.tintColor = .green
            setupButton.tintColor = nil
            setupButton.isEnabled = true
            DataRecording.shared.stopRecording()
            
            GPS.shared.isRecording = false
            
            UIApplication.shared.isIdleTimerDisabled = false
            
        } else{
            if !Setup.shared.stateList().contains(true) && !Settings.shared.gpsState{
                let alertController = UIAlertController(title: NSLocalizedString("Enable setup or GPS to start recording", comment: ""), message: NSLocalizedString("", comment: ""), preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
                
            else{
                DataRecording.shared.startRecording()
                sender.title = "Stop Recording"
                sender.tintColor = .red
                setupButton.tintColor = .gray
                setupButton.isEnabled = false
                
                GPS.shared.isRecording = true
                
                UIApplication.shared.isIdleTimerDisabled = true
                
            }
            
        }
    }
}

