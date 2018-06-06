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
        if motionManager.isGyroAvailable {
            motionManager.startDeviceMotionUpdates()
            
            motionManager.gyroUpdateInterval = 1
            guard let currentQueue = OperationQueue.current else { return }
            motionManager.startGyroUpdates(to: currentQueue) { (gyroData, error) in
                
                // Do Something, call function, etc
                if let rotation = gyroData?.rotationRate {
                    print(rotation)
                    self.accelorometerLabel.text = (rotation.x.description)
                    self.latitudeLabel.text = (rotation.y.description)
                    self.longitudeLabel.text = (rotation.z.description)
                }
                
                if error != nil {
                    print("\(error)")
                }
            }
        }
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
    var timer = Timer()
    func startGyros() {
        if motion.isGyroAvailable {
            self.motion.gyroUpdateInterval = 1.0 / 10.0
            self.motion.startGyroUpdates()
            
            // Configure a timer to fetch the accelerometer data.
            self.timer = Timer(fire: Date(), interval: (1.0/60.0),
                               repeats: true, block: { (timer) in
                                // Get the gyro data.
                                if let data = self.motion.gyroData {
                                    let x = data.rotationRate.x
                                    let y = data.rotationRate.y
                                    let z = data.rotationRate.z
                                    self.accelorometerLabel.text = ("x " + x.description)
                                    self.longitudeLabel.text = ("y " + y.description)
                                    self.latitudeLabel.text = ("z " + z.description)
                                    
                                    // Use the gyroscope data in your app.
                                }
            })
            
            // Add the timer to the current run loop.
            RunLoop.current.add(self.timer, forMode: .defaultRunLoopMode)
        }
    }
    
    func stopGyros() {
        if self.timer != nil {
            self.timer.invalidate()
            
            self.motion.stopGyroUpdates()
        }
    }
    
}

