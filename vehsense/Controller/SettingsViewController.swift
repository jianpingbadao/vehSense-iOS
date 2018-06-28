//
//  SettingsViewController.swift
//  vehsense
//
//  Created by Brian Green on 6/24/18.
//  Copyright © 2018 Weida Zhong. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var settingsTableView: UITableView!
    
    let settingsArray = ["GPS","Bluetooth", "Account"]
    let settingsIconArray = [#imageLiteral(resourceName: "gpsIcon"),#imageLiteral(resourceName: "bluetoothIcon"),#imageLiteral(resourceName: "accountIcon")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        settingsTableView.delegate = self
        settingsTableView.dataSource = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if GPS.shared.isLocating{
            if GPS.shared.selectedState == false{
                GPS.shared.stopLocating()
                GPS.shared.isLocating = false
            }
        }
        else if !GPS.shared.isLocating{
            if GPS.shared.selectedState == true{
                GPS.shared.startLocating()
                GPS.shared.isLocating = true
            }
        }
        
    }
    
    @objc func switchAction(sender : UISwitch)
    {
        GPS.shared.selectedState = !GPS.shared.selectedState
        
    }
    
}

extension SettingsViewController : UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0{
            let cell = settingsTableView.dequeueReusableCell(withIdentifier: "gpsCell", for: indexPath) as! GPSTableViewCell
            cell.settingLabel.text = settingsArray[indexPath.row]
            cell.settingIcon.image = settingsIconArray[indexPath.row]
            cell.gpsSwitch.isOn = GPS.shared.selectedState
            cell.gpsSwitch.addTarget(self, action: #selector(switchAction(sender:)), for: .valueChanged)
            return cell
        
        } else {
            let cell = settingsTableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as! SettingsTableViewCell
            cell.settingLabel.text = settingsArray[indexPath.row]
            cell.settingIcon.image = settingsIconArray[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            tableView.deselectRow(at: indexPath, animated: true)
        case 1:
            tableView.deselectRow(at: indexPath, animated: true)
            performSegue(withIdentifier: "bluetoothSegue", sender: self)
        
        case 2:
            tableView.deselectRow(at: indexPath, animated: true)
        default:
            break
        }
    }
    
    
}
