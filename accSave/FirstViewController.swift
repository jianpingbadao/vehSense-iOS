//
//  FirstViewController.swift
//  accSave
//
//  Created by Jalil Sarwari on 5/29/18.
//  Copyright © 2018 Jalil Sarwari. All rights reserved.
//

import UIKit
import CoreMotion
import CoreLocation

class FirstViewController: UIViewController,CLLocationManagerDelegate {

    @IBOutlet weak var saveTextTest: UILabel!
    @IBOutlet weak var longLabel: UILabel!
    
    
    @IBOutlet weak var go: UIButton!
    @IBOutlet weak var acc: UILabel!
    @IBOutlet weak var stop: UIButton!
    var folderDestination = ""//used to save the current folder destination to able to locate the files in the future rootFolder/VehSenseData1982379384
    var rootFolder = ""// this will be directDirectory/vehSenseData
    var isCurrentlyRunning = false// used to see if the app is currently running, used in creating new directories
    
    let locationManager = CLLocationManager()
//    var prevDate = Date() // save date, so all components use the same date
    override func viewDidLoad() {
        super.viewDidLoad()
        let mainPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]//obtains the path to the user directory
        let directoryDicortPath = mainPath + "/VehSenseData"// this and the next line in the do statement creates a directory named VehSenseData
        do{
            try FileManager.default.createDirectory(atPath: directoryDicortPath, withIntermediateDirectories: true, attributes: nil)
        }
        catch {}
    }
    @IBAction func stopClick(_ sender: Any) {//clicking the stop
        locationManager.stopUpdatingHeading()
        isCurrentlyRunning = false
        locationManager.stopUpdatingLocation()
    }
    @IBAction func goClick(_ sender: Any) {
        
        if (CLLocationManager.headingAvailable()) {
            locationManager.headingFilter = 1
            locationManager.startUpdatingHeading()
            locationManager.delegate = self
            
        }
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        if(!isCurrentlyRunning){
            self.createNewDirectory()
            isCurrentlyRunning = true
        }
    }
    
    
    
    
    
    
    func createNewDirectory(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy_MM_dd_hh_mm_ss"//formats the time into the format we want
        let dateTime = formatter.string(from: Date())//saves the current time from Date()
        
        
        
        let mainPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]//finds the current path to the apps directory
        let directoryDicortPath = mainPath + "/VehSenseData/VehSenseData" + dateTime//creates a new path for the new folder including the current time
        rootFolder = mainPath + "/VehSenseData"
        folderDestination = "/VehSenseData" + dateTime// this will save the new path to the global variable to access the latest created folder
        do{
            try FileManager.default.createDirectory(atPath: directoryDicortPath, withIntermediateDirectories: true, attributes: nil)// create a new folder
        }
        catch {}
        
        guard let writePath = NSURL(fileURLWithPath: rootFolder).appendingPathComponent(folderDestination) else { return }
        let file = writePath.appendingPathComponent("gps.txt")
        let titleString = "timestamp \t system_time \t  \t lat \t \t  lon \t \t speed \t bearing \t provider"
        do {
            try "\(titleString)\n".write(to: file, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print(error)
        }
        
    }
    func write(_ text: String,to fileNamed: String,_ folder: String = "SavedFiles") {
        guard let writePath = NSURL(fileURLWithPath: rootFolder).appendingPathComponent(folder) else { return }
        let file = writePath.appendingPathComponent(fileNamed)
        do {
            let fileHandle = try FileHandle(forWritingTo: file)
            fileHandle.seekToEndOfFile()
            fileHandle.write(text.data(using: .utf8)!)
            fileHandle.closeFile()
        } catch {}
        
    }
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func compareTime(_ date1: Date,_ date2: Date)->Int{
        let calendar = Calendar.current
        
        let prevHour = calendar.component(.hour, from: date1)
        let prevMinute = calendar.component(.minute, from: date1)
        let prevSecond = calendar.component(.second, from: date1)
        
        let currHour = calendar.component(.hour, from: date2)
        let currMinute = calendar.component(.minute, from: date2)
        let currSecond = calendar.component(.second, from: date2)
        
        let previousTimeInSeconds = (((prevHour*60)+(prevMinute*60))+prevSecond)
        let curentTimeInSeconds = (((currHour*60)+(currMinute*60))+currSecond)
        let currentMinusPrevious = curentTimeInSeconds - previousTimeInSeconds
        
        return currentMinusPrevious
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        let latitude = String(locValue.latitude)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddhhmmss"//formats the time into the format we want
        let dateTime = formatter.string(from: Date())//saves the current time from Date()
        let longitude = String(locValue.longitude)
        let titleString = "timestamp \t system_time \t lat \t lon \t speed \t bearing \t provider"
        let newLine = dateTime + " \t " + formatter.string(from: Date()) + " \t " + latitude + " \t " + longitude + " \n"
        self.write(newLine,to: "/gps.txt" , folderDestination)
        saveTextTest.text = latitude
        longLabel.text = longitude
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateHeading heading: CLHeading) {
        self.acc.text =  String(heading.magneticHeading)
    }
}
