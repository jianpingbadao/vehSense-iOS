//
//  Gyroscope.swift
//  vehsense
//
//  Created by Brian Green on 6/27/18.
//  Copyright © 2018 Weida Zhong. All rights reserved.
//

import Foundation
import CoreMotion

class Gyroscope{
    
    static let shared = Gyroscope()
    
    var isOn = false
    
    private var frequency  = Setup.frequencyArray[0]
    
    var motionManager = CMMotionManager()
    
    let notificationName = Notification.Name.init(gyroscopeNotification)
    
    private init()
    {
        motionManager.gyroUpdateInterval = frequency
        
    }
    
    func getFrequency() -> Double{
        return frequency
    }
    
    func setFrequency(segmentIndex : Int){
        motionManager.gyroUpdateInterval = Setup.frequencyArray[segmentIndex]
        frequency = Setup.frequencyArray[segmentIndex]
    }
    
    func startGyroscope()
    {
        motionManager.startGyroUpdates(to: OperationQueue.current!) { (rawData, error) in
            if let gyroscopeData = rawData{
                //print("GYRO: \(self.motionManager.gyroUpdateInterval)")
                let data = ["gyroData" : gyroscopeData]
                NotificationCenter.default.post(name: self.notificationName, object: nil, userInfo: data)
            }
        }
    }
    
    func stopGyroscope()
    {
        motionManager.stopGyroUpdates()
    }
}
