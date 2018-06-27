//
//  ViewController.swift
//  vehsense
//
//  Created by Weida Zhong on 5/27/18.
//  Copyright © 2018 Weida Zhong. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    @IBOutlet weak var accelorometerLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var stop: UIButton!
    @IBOutlet weak var go: UIButton!
    
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
        stop.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func StopClick(_ sender: Any) {
        locationManager.stopUpdatingHeading()
        isCurrentlyRunning = false
        locationManager.stopUpdatingLocation()
        stop.isHidden = true
        go.isHidden = false
    }
    @IBAction func GoClick(_ sender: Any) {
        stop.isHidden = false
        go.isHidden = true
        self.locationManager.requestAlwaysAuthorization()
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        if(!isCurrentlyRunning){
            self.createNewDirectory()
            isCurrentlyRunning = true
            self.writeToGPS()
        }
    }
    func createNewDirectory(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy_MM_dd_hh_mm_ss"//formats the time into the format we want
        let dateTime = formatter.string(from: Date())//saves the current time from Date()
        //creates a new Directory
        let mainPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]//finds the current path to the apps directory
        let directoryDicortPath = mainPath + "/VehSenseData/VehSenseData" + dateTime//creates a new path for the new folder including the current time
        rootFolder = mainPath + "/VehSenseData"
        folderDestination = "/VehSenseData" + dateTime// this will save the new path to the global variable to access the latest created folder
        do{
            try FileManager.default.createDirectory(atPath: directoryDicortPath, withIntermediateDirectories: true, attributes: nil)// create a new folder
        }
        catch {}
        //creates gps.txt
        guard let writePath = NSURL(fileURLWithPath: rootFolder).appendingPathComponent(folderDestination) else { return }
        let file = writePath.appendingPathComponent("gps.txt")
        let titleString = "timestamp \t system_time \t  \t lat \t \t  lon \t \t speed \t bearing \t provider"
        do {
            try "\(titleString)\n".write(to: file, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print(error)
        }
    }
    func writeToGPS(){
        let speed = locationManager.location?.speed.description
        let latitude = locationManager.location?.coordinate.latitude.description
        let longitude = locationManager.location?.coordinate.longitude.description
        let formatter = DateFormatter()
        longitudeLabel.text = longitude
        latitudeLabel.text = latitude
        formatter.dateFormat = "yyyyMMddhhmmss"//formats the time into the format we want
        let dateTime = formatter.string(from: Date())//saves the current time from Date()
        self.write(dateTime + " \t ",to: "/gps.txt" , folderDestination)
        self.write(formatter.string(from: Date()) + " \t ",to: "/gps.txt" , folderDestination)
        self.write(latitude! + " \t ",to: "/gps.txt" , folderDestination)
        self.write(longitude! + " \t ",to: "/gps.txt" , folderDestination)
        self.write(speed! +  " \n",to: "/gps.txt" , folderDestination)
    }
    
    
    
    
    
    
    func write(_ text: String,to fileNamed: String,_ folder: String = "SavedFiles") {
        
        guard let writePath = NSURL(fileURLWithPath: rootFolder).appendingPathComponent(folder) else { return }
        NSLog(rootFolder)
        let file = writePath.appendingPathComponent(fileNamed)
        do {
            let fileHandle = try FileHandle(forWritingTo: file)
            fileHandle.seekToEndOfFile()
            fileHandle.write(text.data(using: .utf8)!)
            fileHandle.closeFile()
        } catch {}
        
    }
    
}

