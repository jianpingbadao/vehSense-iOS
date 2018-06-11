//
//  GPS.swift
//  vehsense
//
//  Created by Jalil Sarwari on 6/4/18.
//  Copyright © 2018 Weida Zhong. All rights reserved.
//

import Foundation
import CoreLocation

class GPS: FileSystem{
    let locationManager = CLLocationManager()
    
    func Go(){
        //This is what should happen when the go button is clicked
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        self.createTxtFile()
        self.startGPS()
        
    }
    
    func Stop(){
        self.stopGPS()
    }
    
    func writeToTxt(){
        let speed = locationManager.location?.speed.description
        let latitude = locationManager.location?.coordinate.latitude.description
        let longitude = locationManager.location?.coordinate.longitude.description
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"//formats the time into the format we want
        write(String(FileSystem.timeStamp) + " \t ", to: "/gps\(FileSystem.fileNumber).txt", FileSystem.folderDestination)
        write(formatter.string(from: Date()) + " \t ",to: "/gps\(FileSystem.fileNumber).txt" , FileSystem.folderDestination)
        write(latitude! + " \t ",to: "/gps\(FileSystem.fileNumber).txt" , FileSystem.folderDestination)
        write(longitude! + " \t ",to: "/gps\(FileSystem.fileNumber).txt" , FileSystem.folderDestination)
        write(speed! +  " \n",to: "/gps\(FileSystem.fileNumber).txt" , FileSystem.folderDestination)
        FileSystem.lineCount += 1
    }
    
    func createTxtFile(){
        guard let writePath = NSURL(fileURLWithPath: FileSystem.rootFolder).appendingPathComponent(FileSystem.folderDestination) else { return }
        let file = writePath.appendingPathComponent("gps\(FileSystem.fileNumber).txt")
        let titleString = "timestamp, \t system_time, \t  \t lat, \t \t  lon, \t \t speed, \t bearing, \t provider"
        do {
            try "\(titleString)\n".write(to: file, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print(error)
        }
    }
    var timer = Timer()
    func startGPS() {
        
            
            // Configure a timer to fetch the accelerometer data.
            self.timer = Timer(fire: Date(), interval: (FileSystem.frequency),
                               repeats: true, block: { (timer) in
                                // Get the gyro data.
                                if(FileSystem.lineCount == FileSystem.lineLimit){
                                    FileSystem.fileNumber += 1
                                    self.createTxtFile()
                                    FileSystem.lineCount = 0
                                }
                                self.writeToTxt()
                                
                                FileSystem.timeStamp += FileSystem.frequency
            })
            
            // Add the timer to the current run loop.
            RunLoop.current.add(self.timer, forMode: .defaultRunLoopMode)
        
    }
    
    func stopGPS() {
        self.timer.invalidate()
        locationManager.stopUpdatingLocation()
    }
}
