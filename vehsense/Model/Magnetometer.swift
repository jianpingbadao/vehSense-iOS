//
//  Magnetometer.swift
//  vehsense
//
//  Created by Brian Green on 6/27/18.
//  Copyright © 2018 Weida Zhong. All rights reserved.
//

import Foundation
import CoreMotion

class Magnetometer{
    
    static let shared = Magnetometer()
    
    var motionManager = CMMotionManager()
    
    let notificationName = Notification.Name.init(magnetometerNotification)
    
    private init()
    {
        motionManager.magnetometerUpdateInterval = 0.2
        
    }
    
    func startMagnetometer()
    {
        motionManager.startMagnetometerUpdates(to: OperationQueue.current!) { (rawData, error) in
            if let magData = rawData
            {
                let data = ["magData" : magData]
                NotificationCenter.default.post(name: self.notificationName, object: nil, userInfo: data)
                
            }
        }
    }
    
    func stopMagnetometer()
    {
        motionManager.stopMagnetometerUpdates()
    }
}
