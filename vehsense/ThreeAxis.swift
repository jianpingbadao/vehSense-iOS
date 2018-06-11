//
//  ThreeAxis.swift
//  vehsense
//
//  Created by Jalil Sarwari on 6/5/ 8.
//  Copyright © 2018 Weida Zhong. All rights reserved.
//
import CoreLocation
import Foundation
import CoreMotion
class ThreeAxis: FileSystem{
    let motion = CMMotionManager()
    let locationManager = CLLocationManager()
    var x = ""
    var y = ""
    var z = ""
    func Go(){
        self.createTxtFile()
        self.startGyros()
    }
    func Stop(){
        self.stopGyros()
    }
    func writeToTxt(){
        if let data = self.motion.accelerometerData {
            self.x = data.acceleration.x.description
            self.y = data.acceleration.y.description
            self.z = data.acceleration.z.description
            // Use the gyroscope data in your app.
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"//formats the time into the format we want
        write(String(FileSystem.timeStamp) + " \t ", to: "/raw_acc\(FileSystem.fileNumber).txt", FileSystem.folderDestination)
        write(formatter.string(from: Date()) + " \t ",to: "/raw_acc\(FileSystem.fileNumber).txt" , FileSystem.folderDestination)
        write(x + " \t ",to: "/raw_acc\(FileSystem.fileNumber).txt" , FileSystem.folderDestination)
        write(y + " \t ",to: "/raw_acc\(FileSystem.fileNumber).txt" , FileSystem.folderDestination)
        write(z +  " \n",to: "/raw_acc\(FileSystem.fileNumber).txt" , FileSystem.folderDestination)
        FileSystem.lineCount += 1
    }
    
    func createTxtFile(){
//        "timestamp","sys_time","abs_timestamp","raw_x_acc","raw_y_acc","raw_z_acc"
        guard let writePath = NSURL(fileURLWithPath: FileSystem.rootFolder).appendingPathComponent(FileSystem.folderDestination) else { return }
        let file = writePath.appendingPathComponent("raw_acc\(FileSystem.fileNumber).txt")
        let titleString = "timestamp, \t system_time, \t abs_timestamp, \t raw_x_acc, \t raw_y_acc, \t raw_z_acc"
        do {
            try "\(titleString)\n".write(to: file, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print(error)
        }
    }
    var timer = Timer()
    func startGyros() {
        
        if motion.isGyroAvailable {
            self.motion.gyroUpdateInterval = FileSystem.frequency
            self.motion.startGyroUpdates()
            
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
    }
    
    func stopGyros() {
        self.timer.invalidate()
        self.motion.stopGyroUpdates()
        
    }
}
