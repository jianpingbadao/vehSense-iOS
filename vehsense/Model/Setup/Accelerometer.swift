//
//  Accelerometer.swift
//  vehsense
//
//  Created by Brian Green on 6/27/18.
//  Copyright © 2018 Weida Zhong. All rights reserved.
//

import Foundation
import CoreMotion

class Accelerometer{
    
    static let shared = Accelerometer()
    
    var isOn = false
    
    private var frequency  = Setup.frequencyArray[0]
    
    var motionManager = CMMotionManager()
    
    let notificationName = Notification.Name.init(accelerometerNotification)
    
    private init(){
        motionManager.accelerometerUpdateInterval = frequency
    }
    
    func getFrequency() -> Double{
        return  frequency
    }
    
    func setFrequency(segmentIndex : Int){
        motionManager.accelerometerUpdateInterval = Setup.frequencyArray[segmentIndex]
        frequency = Setup.frequencyArray[segmentIndex]
    }
    
    func startAccelerometer(){
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (rawData, error) in
            if let accData = rawData
            {
                print("ACC: \(self.motionManager.accelerometerUpdateInterval)")
                let data = ["accData" : accData]
                NotificationCenter.default.post(name: self.notificationName, object: nil, userInfo: data)
            }
        }
    }
    
    func stopAccelerometer(){
        motionManager.stopAccelerometerUpdates()
    }
    
    
}
