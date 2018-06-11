//
//  ViewController.swift
//  vehsense
//
//  Created by Weida Zhong on 5/27/18.
//  Copyright © 2018 Weida Zhong. All rights reserved.
//

import UIKit
import CoreLocation
import CoreMotion
class ViewController: UIViewController {
    @IBOutlet weak var accelorometerLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var stop: UIButton!
    @IBOutlet weak var go: UIButton!
    
    let locationManager = CLLocationManager()
    var isCurrentlyRunning = false// used to see if the app is currently running, used in creating new directories
    let fileSystem = FileSystem()
    let gps = GPS()
    let gyro = Gyroscope()
    let axis = ThreeAxis()
    let motion = CMMotionManager()
    let motionManager = CMMotionManager()
    
    //    var prevDate = Date() // save date, so all components use the same date
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stop.isHidden = true
//        if motionManager.isGyroAvailable {
//            motionManager.startDeviceMotionUpdates()
//
//            motionManager.gyroUpdateInterval = 1
//            guard let currentQueue = OperationQueue.current else { return }
//            motionManager.startGyroUpdates(to: currentQueue) { (gyroData, error) in
//
//                // Do Something, call function, etc
//                if let rotation = gyroData?.rotationRate {
//                    print(rotation)
//                    self.accelorometerLabel.text = (rotation.x.description)
//                    self.latitudeLabel.text = (rotation.y.description)
//                    self.longitudeLabel.text = (rotation.z.description)
//                }
//                if error != nil {
//                    print("\(error)")
//                }
//            }
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func StopClick(_ sender: Any) {
        isCurrentlyRunning = false
        stop.isHidden = true
        go.isHidden = false
        gps.Stop()
        gyro.Stop()
        axis.Stop()
    }
    @IBAction func GoClick(_ sender: Any) {
        stop.isHidden = false
        go.isHidden = true
        if(!isCurrentlyRunning){
            fileSystem.createNewDirectory()
            gps.Go()
            gyro.Go()
            axis.Go()
            isCurrentlyRunning = true
        }
        
    }
    
    
}

