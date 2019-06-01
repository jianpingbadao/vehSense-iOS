//
//  DriveSessionViewController.swift
//  vehsense
//
//  Created by Brian Green on 7/16/18.
//  Copyright © 2018 Weida Zhong. All rights reserved.
//

import UIKit

enum Session : String{
    case Location = "Location"
    case Accelerometer = "Accelerometer"
    case Gyroscope = "Gyroscope"
    case Magnetometer = "Magnetometer"
}

class DriveSessionViewController: UIViewController {
   
    @IBOutlet weak var tableView: UITableView!
    var driveSession : DriveSession!
    var attributeList = [Session]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        sessionAnalysis()
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    func sessionAnalysis(){
        if driveSession.locale != nil{
            attributeList.append(Session.Location)
        }
        if driveSession.accelerometer != nil{
            attributeList.append(Session.Accelerometer)
        }
        if driveSession.gyroscope != nil{
            attributeList.append(Session.Gyroscope)
        }
        if driveSession.magnetometer != nil{
            attributeList.append(Session.Magnetometer)
        }
    }
    
}


extension DriveSessionViewController : UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = attributeList[indexPath.row].rawValue
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
        
        switch attributeList[indexPath.row]{
        case .Location:
            spreadsheetViewController.data.append((driveSession.locale?.timeList)!)
            spreadsheetViewController.data.append((driveSession.locale?.mph)!)
            spreadsheetViewController.data.append((driveSession.locale?.lat)!)
            spreadsheetViewController.data.append((driveSession.locale?.long)!)
            spreadsheetViewController.data.append((driveSession.locale?.bearing)!)

        case .Accelerometer:
            spreadsheetViewController.data.append((driveSession.accelerometer?.timeList)!)
            spreadsheetViewController.data.append((driveSession.accelerometer?.x)!)
            spreadsheetViewController.data.append((driveSession.accelerometer?.y)!)
            spreadsheetViewController.data.append((driveSession.accelerometer?.z)!)

        case .Gyroscope:
            spreadsheetViewController.data.append((driveSession.gyroscope?.timeList)!)
            spreadsheetViewController.data.append((driveSession.gyroscope?.x)!)
            spreadsheetViewController.data.append((driveSession.gyroscope?.y)!)
            spreadsheetViewController.data.append((driveSession.gyroscope?.z)!)

        case .Magnetometer:
            spreadsheetViewController.data.append((driveSession.magnetometer?.timeList)!)
            spreadsheetViewController.data.append((driveSession.magnetometer?.x)!)
            spreadsheetViewController.data.append((driveSession.magnetometer?.y)!)
            spreadsheetViewController.data.append((driveSession.magnetometer?.z)!)
        }
        
        if attributeList[indexPath.row] == .Location{
            spreadsheetViewController.header = ["Timestamp","Mph","Lat","Long","Bearing"]
        } else { spreadsheetViewController.header = ["Timestamp","x","y","z"] }

        self.navigationController?.pushViewController(spreadsheetViewController, animated: true)
    }
    
}

