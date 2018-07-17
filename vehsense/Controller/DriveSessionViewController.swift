//
//  DriveSessionViewController.swift
//  vehsense
//
//  Created by Brian Green on 7/16/18.
//  Copyright © 2018 Weida Zhong. All rights reserved.
//

import UIKit

class DriveSessionViewController: UIViewController {
   
    @IBOutlet weak var tableView: UITableView!
    var driveSession : DriveSession!
    var attributeList = ["Location", "Accelerometer", "Gyroscope", "Magnetometer"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
}


extension DriveSessionViewController : UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = attributeList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attributeList.count
    }
    
}


extension DriveSessionViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let spreadsheetViewController = self.storyboard?.instantiateViewController(withIdentifier: "spreadsheetViewController") as! SpreadsheetViewController
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            spreadsheetViewController.header = ["Timestamp","Mph","Lat","Long","Bearing"]
            spreadsheetViewController.data.append(driveSession.locationTimeList!)
            spreadsheetViewController.data.append(driveSession.mphList!)
            spreadsheetViewController.data.append(driveSession.latitudeList!)
            spreadsheetViewController.data.append(driveSession.longitudeList!)
            spreadsheetViewController.data.append(driveSession.bearingList!)
        
        case 1:
            spreadsheetViewController.header = ["Timestamp","x","y","z"]
            spreadsheetViewController.data.append(driveSession.accTimeList!)
            spreadsheetViewController.data.append(driveSession.accXList!)
            spreadsheetViewController.data.append(driveSession.accYList!)
            spreadsheetViewController.data.append(driveSession.accZList!)
        
        case 2:
            spreadsheetViewController.header = ["Timestamp","x","y","z"]
            spreadsheetViewController.data.append(driveSession.gyroTimeList!)
            spreadsheetViewController.data.append(driveSession.gyroXList!)
            spreadsheetViewController.data.append(driveSession.gyroYList!)
            spreadsheetViewController.data.append(driveSession.gyroZList!)
        
        case 3:
            spreadsheetViewController.header = ["Timestamp","x","y","z"]
            spreadsheetViewController.data.append(driveSession.magTimeList!)
            spreadsheetViewController.data.append(driveSession.magXList!)
            spreadsheetViewController.data.append(driveSession.magYList!)
            spreadsheetViewController.data.append(driveSession.magZList!)
            
        default:
            break
        }
        

        self.navigationController?.pushViewController(spreadsheetViewController, animated: true)
    }
    
}

