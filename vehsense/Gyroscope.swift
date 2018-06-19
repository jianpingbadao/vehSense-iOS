//
//  Gyroscope.swift
//  vehsense
//
//  Created by Jalil Sarwari on 6/5/18.
//  Copyright © 2018 Weida Zhong. All rights reserved.
//
import CoreLocation
import Foundation
import CoreMotion
class Gyroscope: FileSystem{
    var x = ""
    var y = ""
    var z = ""
    let locationManager = CLLocationManager()
    let motion = CMMotionManager()
    
    func Go(){
        self.createTxtFile()
        self.startGyros()
    }
    func Stop(){
        self.stopGyros()
    }
    func writeToTxt(){
        if let data = self.motion.gyroData {
            self.x = data.rotationRate.x.description
            self.y = data.rotationRate.y.description
            self.z = data.rotationRate.z.description
            // Use the gyroscope data in your app.
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"//formats the time into the format we want
        write(String(FileSystem.timeStamp) + " \t ", to: "/raw_gyro\(FileSystem.fileNumber).txt", FileSystem.folderDestination)
        write(formatter.string(from: Date()) + " \t ",to: "/raw_gyro.txt" , FileSystem.folderDestination)
        write(x + " \t ",to: "/raw_gyro\(FileSystem.fileNumber).txt" , FileSystem.folderDestination)
        write(y + " \t ",to: "/raw_gyro\(FileSystem.fileNumber).txt" , FileSystem.folderDestination)
        write(z +  " \n",to: "/raw_gyro\(FileSystem.fileNumber).txt" , FileSystem.folderDestination)
        FileSystem.lineCount += 1
    }
    
    func createTxtFile(){
//        "timestamp","sys_time","abs_timestamp","raw_x_gyro","raw_y_gyro","raw_z_gyro"
        guard let writePath = NSURL(fileURLWithPath: FileSystem.rootFolder).appendingPathComponent(FileSystem.folderDestination) else { return }
        let file = writePath.appendingPathComponent("raw_gyro\(FileSystem.fileNumber).txt")
        let titleString = "timestamp, \t sys_time, \t abs_timestamp, \t raw_x_gyro, \t raw_y_gyro, \t raw_z_gyro"
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
