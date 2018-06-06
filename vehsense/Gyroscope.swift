//
//  Gyroscope.swift
//  vehsense
//
//  Created by Jalil Sarwari on 6/5/18.
//  Copyright © 2018 Weida Zhong. All rights reserved.
//
import CoreLocation
import Foundation
class Gyroscope: FileSystem{
    let locationManager = CLLocationManager()
    
    
    func Go(){
        self.createTxtFile()
    }
    func Stop(){
    }
    func writeToTxt(){
        let speed = locationManager.location?.speed.description
        let latitude = locationManager.location?.coordinate.latitude.description
        let longitude = locationManager.location?.coordinate.longitude.description
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"//formats the time into the format we want
        let dateTime = formatter.string(from: Date())//saves the current time from Date()
        write(dateTime + " \t ", to: "/gps.txt", FileSystem.folderDestination)
        write(formatter.string(from: Date()) + " \t ",to: "/gps.txt" , FileSystem.folderDestination)
        write(latitude! + " \t ",to: "/gps.txt" , FileSystem.folderDestination)
        write(longitude! + " \t ",to: "/gps.txt" , FileSystem.folderDestination)
        write(speed! +  " \n",to: "/gps.txt" , FileSystem.folderDestination)
    }
    
    func createTxtFile(){
//        "timestamp","sys_time","abs_timestamp","raw_x_gyro","raw_y_gyro","raw_z_gyro"
        guard let writePath = NSURL(fileURLWithPath: FileSystem.rootFolder).appendingPathComponent(FileSystem.folderDestination) else { return }
        let file = writePath.appendingPathComponent("raw_gyro.txt")
        let titleString = "timestamp, \t sys_time, \t abs_timestamp, \t raw_x_gyro, \t raw_y_gyro, \t raw_z_gyro"
        do {
            try "\(titleString)\n".write(to: file, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print(error)
        }
    }
}
