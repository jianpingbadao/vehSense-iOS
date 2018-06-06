//
//  FileSystem.swift
//  vehsense
//
//  Created by Jalil Sarwari on 6/4/18.
//  Copyright © 2018 Weida Zhong. All rights reserved.
//

import Foundation

class FileSystem{
    static var folderDestination = "Jalil"//used to save the current folder destination to able to locate the files in the future rootFolder/VehSenseData1982379384
    static var rootFolder = ""// this will be directDirectory/vehSenseData
    
     init(){
        let mainPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]//obtains the path to the user directory
        let directoryDicortPath = mainPath + "/VehSenseDataLAKJ"// this and the next line in the do statement creates a directory named VehSenseData
        do{
            try FileManager.default.createDirectory(atPath: directoryDicortPath, withIntermediateDirectories: true, attributes: nil)
        }
        catch {}
    }
    
    func createNewDirectory(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy_MM_dd_HH_mm_ss"//formats the time into the format we want
        let dateTime = formatter.string(from: Date())//saves the current time from Date()
        //creates a new Directory
        let mainPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]//finds the current path to the apps directory
        let directoryDicortPath = mainPath + "/VehSenseData/VehSenseData" + dateTime//creates a new path for the new folder including the current time
        FileSystem.rootFolder = mainPath + "/VehSenseData"
        FileSystem.folderDestination = "/VehSenseData" + dateTime// this will save the new path to the global variable to access the latest created folder
        do{
            try FileManager.default.createDirectory(atPath: directoryDicortPath, withIntermediateDirectories: true, attributes: nil)// create a new folder
        }
        catch {}
    }
    
    func write(_ text: String,to fileNamed: String,_ folder: String = "SavedFiles") {
        
        guard let writePath = NSURL(fileURLWithPath: FileSystem.rootFolder).appendingPathComponent(FileSystem.folderDestination) else { return }
        
        let file = writePath.appendingPathComponent(fileNamed)
        do {
            let fileHandle = try FileHandle(forWritingTo: file)
            fileHandle.seekToEndOfFile()
            fileHandle.write(text.data(using: .utf8)!)
            fileHandle.closeFile()
        } catch {}
        
    }
}
