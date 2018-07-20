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
    
    let iconArray = [#imageLiteral(resourceName: "mphIcon"),#imageLiteral(resourceName: "bearingIcon"),#imageLiteral(resourceName: "latitudeIcon"),#imageLiteral(resourceName: "longitudeIcon"),#imageLiteral(resourceName: "gyroscopeIcon"),#imageLiteral(resourceName: "accIcon"),#imageLiteral(resourceName: "magnitudeIcon")]
    
    var currentMPH = "0.0"
    var currentBearing = "---"
    var currentLat = "---"
    var currentLong = "---"
    
    var currentGyroX = "x:"
    var currentGyroY = "y:"
    var currentGyroZ = "z:"
    
    var currentAccX = "x:"
    var currentAccY = "y:"
    var currentAccZ = "z:"
    
    var currentMagX = "x:"
    var currentMagY = "y:"
    var currentMagZ = "z:"

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
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
        
        currentLat = String(rawLat)
        currentLong = String(rawLong)
        currentBearing = String(rawBearing)
        
        let rawMPH = rawSpeed < 0 ? 0 : rawSpeed * 2.23694
        currentMPH  = String(format: "%.1f", rawMPH)
        
        collectionView.reloadData()
    }
    
    @objc func updateGyroscope(notification : Notification)
    {
        guard let gyroData = notification.userInfo?["gyroData"] as? CMGyroData else { return }
        currentGyroX = "x: \(gyroData.rotationRate.x )"
        currentGyroY = "y: \(gyroData.rotationRate.y )"
        currentGyroZ = "z: \(gyroData.rotationRate.z )"
        
        collectionView.reloadData()
    }

    @objc func updateAccelerometer(notification : Notification)
    {
        guard let accData = notification.userInfo?["accData"] as? CMAccelerometerData else { return }

        currentAccX = "x: \(accData.acceleration.x)"
        currentAccY = "y: \(accData.acceleration.y)"
        currentAccZ = "z: \(accData.acceleration.z)"
        
        collectionView.reloadData()
    }

    @objc func updateMagnetometer(notification : Notification)
    {
        guard let magData = notification.userInfo?["magData"] as? CMMagnetometerData else { return }

        currentMagX = "x: \(magData.magneticField.x)"
        currentMagY = "y: \(magData.magneticField.y)"
        currentMagZ = "z: \(magData.magneticField.z)"
        
        collectionView.reloadData()
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


extension DataViewController : UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return iconArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! DataViewCollectionViewCell
        
        cell.image.image = iconArray[indexPath.row]
        
        if !Settings.shared.gpsState || !GPS.shared.isAuth(){
            currentLat = "---"
            currentLong = "---"
            currentBearing = "---"
            currentMPH = "0.0"
        }
        
        switch indexPath.row {
        case 0:
            cell.titleLabel.text = "MPH"
            cell.descriptionLabel.text = currentMPH
        case 1:
            cell.titleLabel.text = "BEARING"
            cell.descriptionLabel.text = currentBearing
        case 2:
            cell.titleLabel.text = "LATITUDE"
            cell.descriptionLabel.text = currentLat
        case 3:
            cell.titleLabel.text = "LONGITUDE"
            cell.descriptionLabel.text = currentLong
        case 4:
            if !Setup.shared.gyroSelectedState{
                currentGyroX = "x:"
                currentGyroY = "y:"
                currentGyroZ = "z:"
            }
            cell.titleLabel.text = "GYROSCOPE"
            cell.descriptionLabel.text = currentGyroX
            cell.descriptionLabel2.text = currentGyroY
            cell.descriptionLabel3.text = currentGyroZ
            
        case 5:
            if !Setup.shared.accSelectedState{
                currentAccX = "x:"
                currentAccY = "y:"
                currentAccZ = "z:"
            }
            cell.titleLabel.text = "ACCELEROMETER"
            cell.descriptionLabel.text = currentAccX
            cell.descriptionLabel2.text = currentAccY
            cell.descriptionLabel3.text = currentAccZ
            
        case 6:
            if !Setup.shared.magSelectedState{
                currentMagX = "x:"
                currentMagY = "y:"
                currentMagZ = "z:"
            }
            cell.titleLabel.text = "MAGNETOMETER"
            cell.descriptionLabel.text = currentMagX
            cell.descriptionLabel2.text = currentMagY
            cell.descriptionLabel3.text = currentMagZ
        
        default:
            break
        }

        
        return cell
    }
    
}

extension DataViewController : UICollectionViewDelegate{
    
}


extension DataViewController: UIImagePickerControllerDelegate {
}

extension DataViewController: UINavigationControllerDelegate {
}
