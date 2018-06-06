//
//  ThreeAxis.swift
//  vehsense
//
//  Created by Jalil Sarwari on 6/5/18.
//  Copyright © 2018 Weida Zhong. All rights reserved.
//
import CoreLocation
import Foundation
class ThreeAxis: FileSystem{
    let locationManager = CLLocationManager()
    
    func Go(){
        self.createTxtFile()
    }
    func Stop(){
    }
    func writeToTxt(){
//        let x = locationManager.heading?.x.description
//        let y = locationManager.heading?.y.description
//        let z = locationManager.heading?.z.description
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyyMMddHHmmss"//formats the time into the format we want
//        let dateTime = formatter.string(from: Date())//saves the current time from Date()
//        write(dateTime + " \t ", to: "/gps.txt", FileSystem.folderDestination)
//        write(formatter.string(from: Date()) + " \t ",to: "/gps.txt" , FileSystem.folderDestination)
//        write(x? + " \t ",to: "/gps.txt" , FileSystem.folderDestination)
//        write(y? + " \t ",to: "/gps.txt" , FileSystem.folderDestination)
//        write(z? +  " \n",to: "/gps.txt" , FileSystem.folderDestination)
    }
    
    func createTxtFile(){
//        "timestamp","sys_time","abs_timestamp","raw_x_acc","raw_y_acc","raw_z_acc"
        guard let writePath = NSURL(fileURLWithPath: FileSystem.rootFolder).appendingPathComponent(FileSystem.folderDestination) else { return }
        let file = writePath.appendingPathComponent("raw_acc.txt")
        let titleString = "timestamp, \t system_time, \t abs_timestamp, \t raw_x_acc, \t raw_y_acc, \t raw_z_acc"
        do {
            try "\(titleString)\n".write(to: file, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print(error)
        }
    }
}
