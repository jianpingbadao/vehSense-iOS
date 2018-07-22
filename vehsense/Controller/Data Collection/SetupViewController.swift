//
//  SetupViewController.swift
//  vehsense
//
//  Created by Brian Green on 6/21/18.
//  Copyright © 2018 Weida Zhong. All rights reserved.
//


import UIKit


class SetupViewController: UIViewController, UITableViewDelegate{
    
    let options = ["Accelerometer", "Magnetometer", "Gyroscope","Video","OBD"]
    
    @IBOutlet weak var setupTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupTableView.delegate = self
        setupTableView.dataSource = self
    }
    
    
    @objc func switchAction(sender : UISwitch){
        switch sender.tag {
            
        case 0:
            Setup.shared.accSelectedState = !Setup.shared.accSelectedState
        case 1:
            Setup.shared.magSelectedState = !Setup.shared.magSelectedState
        case 2:
            Setup.shared.gyroSelectedState = !Setup.shared.gyroSelectedState
        case 3:
            Setup.shared.recSelectedState = !Setup.shared.recSelectedState
        case 4:
            Setup.shared.obdSelectedState = !Setup.shared.obdSelectedState
        default:
            break
        }
        updateSetup()
    }
}

func updateSetup(){
    if Accelerometer.shared.isOn{
        if Setup.shared.accSelectedState == false{
            Accelerometer.shared.stopAccelerometer()
            Accelerometer.shared.isOn = false
        }
    }
        
    else if !Accelerometer.shared.isOn{
        if Setup.shared.accSelectedState == true{
            Accelerometer.shared.startAccelerometer()
            Accelerometer.shared.isOn = true
        }
    }
    
    if Magnetometer.shared.isOn{
        if Setup.shared.magSelectedState == false{
            Magnetometer.shared.stopMagnetometer()
            Magnetometer.shared.isOn = false
        }
    }
        
    else if !Magnetometer.shared.isOn{
        if Setup.shared.magSelectedState == true{
            Magnetometer.shared.startMagnetometer()
            Magnetometer.shared.isOn = true
        }
    }
    
    if Gyroscope.shared.isOn{
        if Setup.shared.gyroSelectedState == false{
            Gyroscope.shared.stopGyroscope()
            Gyroscope.shared.isOn = false
        }
    }
        
    else if !Gyroscope.shared.isOn{
        if Setup.shared.gyroSelectedState == true{
            Gyroscope.shared.startGyroscope()
            Gyroscope.shared.isOn = true
        }
    }
}

extension SetupViewController : UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = setupTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SetupTableViewCell
        cell.titleLabel.text = options[indexPath.row]
        cell.optionSwitch.tag = indexPath.row
        cell.optionSwitch.setOn(Setup.shared.stateList()[indexPath.row], animated: true)
        cell.optionSwitch.addTarget(self, action: #selector(switchAction(sender:)), for: .valueChanged)
        return cell
    }
    
}
