//
//  DataRecording.swift
//  vehsense
//
//  Created by Brian Green on 7/11/18.
//  Copyright © 2018 Weida Zhong. All rights reserved.
//

import Foundation
import CoreLocation
import CoreMotion

class DataRecording{
    
    static let shared = DataRecording()
    
    private var isRecording = false
    
    private let dateFormatter = DateFormatter()
    private var startTime : String?
    private var endTime : String?
    
    var recordingState = false
    
    private var mphList = [Double]()
    private var bearingList = [Double]()
    private var latList = [Double]()
    private var longList = [Double]()
    private var locationTimeList = [Double]()
    
    private var gyroXList = [Double]()
    private var gyroYList = [Double]()
    private var gyroZList = [Double]()
    private var gyroTimeList = [Double]()
    
    private var accXList = [Double]()
    private var accYList = [Double]()
    private var accZList = [Double]()
    private var accTimeList = [Double]()
    
    private var magXList = [Double]()
    private var magYList = [Double]()
    private var magZList = [Double]()
    private var magTimeList = [Double]()
    
    private init () {
        NotificationCenter.default.addObserver(self, selector: #selector(DataRecording.updateLocation(notification:)), name: Notification.Name.init(gpsNotification), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(DataViewController.updateGyroscope(notification:)), name: Notification.Name.init(gyroscopeNotification), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(DataViewController.updateAccelerometer(notification:)), name: Notification.Name.init(accelerometerNotification), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(DataViewController.updateMagnetometer(notification:)), name: Notification.Name.init(magnetometerNotification), object: nil)
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
    }
    
    
    @objc private func updateLocation(notification : Notification){
        guard let location = notification.userInfo?["location"] as? CLLocation else { return }
        
        if isRecording{
            let mph = location.speed < 0 ? 0 : location.speed * 2.23694
            mphList.append(mph)
            
            latList.append(Double(location.coordinate.latitude))
            longList.append(Double(location.coordinate.longitude))
            bearingList.append(Double(location.course))
            
            locationTimeList.append(NSDate().timeIntervalSince1970)
        }
    }
    
    @objc private func updateGyroscope(notification : Notification)
    {
        guard let gyroData = notification.userInfo?["gyroData"] as? CMGyroData else { return }
        
        if isRecording{
            gyroXList.append(gyroData.rotationRate.x)
            gyroYList.append(gyroData.rotationRate.y)
            gyroZList.append(gyroData.rotationRate.z)
            
            gyroTimeList.append(NSDate().timeIntervalSince1970)
            
        }
    }
    
    @objc private func updateAccelerometer(notification : Notification)
    {
        guard let accData = notification.userInfo?["accData"] as? CMAccelerometerData else { return }
        
        if isRecording{
            accXList.append(accData.acceleration.x)
            accYList.append(accData.acceleration.y)
            accZList.append(accData.acceleration.z)
            
            accTimeList.append(NSDate().timeIntervalSince1970)

        }
        
    }
    
    @objc private func updateMagnetometer(notification : Notification)
    {
        guard let magData = notification.userInfo?["magData"] as? CMMagnetometerData else { return }
        
        if isRecording{
            magXList.append(magData.magneticField.x)
            magYList.append(magData.magneticField.y)
            magZList.append(magData.magneticField.z)
            
            magTimeList.append(NSDate().timeIntervalSince1970)
        }
        
    }

    func startRecording(){
        
        startTime = dateFormatter.string(from: NSDate() as Date)
        isRecording = true
        recordingState = true

    }
    
    func stopRecording(){
        
        endTime = dateFormatter.string(from: NSDate() as Date)
        isRecording = false
        recordingState = false
        
        let driveSession = DriveSession(context: PersistenceManager.shared.context)
        
        driveSession.mphList = mphList
        driveSession.bearingList = bearingList
        driveSession.latitudeList = latList
        driveSession.longitudeList = longList
        driveSession.locationTimeList = locationTimeList
        
        driveSession.gyroXList = gyroXList
        driveSession.gyroYList = gyroYList
        driveSession.gyroZList = gyroZList
        driveSession.gyroTimeList = gyroTimeList
        
        driveSession.accXList = accXList
        driveSession.accYList = accYList
        driveSession.accZList = accZList
        driveSession.accTimeList = accTimeList
        
        driveSession.magXList = magXList
        driveSession.magYList = magYList
        driveSession.magZList = magZList
        driveSession.magTimeList = magTimeList
        
        driveSession.sessionStartTime = startTime
        driveSession.sessionEndTime = endTime

        PersistenceManager.shared.saveContext()
        
    }

}
