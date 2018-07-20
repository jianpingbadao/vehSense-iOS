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
    
    @IBOutlet weak var gpsSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateSwitch), name: .UIApplicationWillEnterForeground, object: nil)
    }
    
    
    @objc func updateSwitch(){
        if GPS.shared.isAuth() == false{
            gpsIsOff()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        settingsTableView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool)
    {
        if Settings.shared.gpsState == true{
            GPS.shared.turnOn()
        }
            
        else if Settings.shared.gpsState == false{
            GPS.shared.turnOff()
        }
    }
    
    @objc func switchAction(sender : UISwitch)
    {
        if GPS.shared.isAuth() == false{
            if Settings.shared.gpsState == false{
                let alertController = UIAlertController(title: NSLocalizedString("Enable location services to use this feature", comment: ""), message: NSLocalizedString("", comment: ""), preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
                let settingsAction = UIAlertAction(title: NSLocalizedString("Settings", comment: ""), style: .default) { (UIAlertAction) in
                    UIApplication.shared.openURL(NSURL(string: UIApplicationOpenSettingsURLString)! as URL)
                }
                
                alertController.addAction(cancelAction)
                alertController.addAction(settingsAction)
                self.present(alertController, animated: true, completion: nil)
            }
            gpsIsOff()
        }
        
        else{ Settings.shared.gpsState = !Settings.shared.gpsState
            
        }
    }
    
    func gpsIsOff(){
        Settings.shared.gpsState = false
        gpsSwitch.isOn = false
        GPS.shared.turnOff()
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
            cell.selectionStyle = .none
            
            gpsSwitch = cell.gpsSwitch
            cell.gpsSwitch.isOn = Settings.shared.gpsState
            
            if GPS.shared.isRecording{
                cell.gpsSwitch.isEnabled = false
            } else { cell.gpsSwitch.isEnabled = true }
            
            
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
