//
//  SetupViewController.swift
//  vehsense
//
//  Created by Brian Green on 6/21/18.
//  Copyright © 2018 Weida Zhong. All rights reserved.
//


import UIKit


class SetupViewController: UIViewController{
    
    let options = ["Accelerometer", "Magnetometer", "Gyroscope","Video","OBD"]
    
    @IBOutlet weak var setupTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupTableView.delegate = self
        setupTableView.dataSource = self
        setupTableView.register(SetupTableHeaderView.self, forHeaderFooterViewReuseIdentifier: "headerView")
        setupTableView.register(ExpandedTableViewCell.self, forCellReuseIdentifier: "expandableCell")
        
        setupTableView.separatorStyle = .none
    }
    
    
    
    @objc func setFrequency(sender : UISegmentedControl){
        switch sender.tag{
        case 0:
            Accelerometer.shared.setFrequency(segmentIndex: sender.selectedSegmentIndex)
        case 1:
            Magnetometer.shared.setFrequency(segmentIndex: sender.selectedSegmentIndex)
        case 2:
            Gyroscope.shared.setFrequency(segmentIndex: sender.selectedSegmentIndex)
        default:
            break
        }
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
        setupTableView.reloadSections(IndexSet([0]), with: .automatic)
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

}


extension SetupViewController : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section < 3{
            return 1
        } else { return 0 }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableView.frame.height/5
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = setupTableView.dequeueReusableHeaderFooterView(withIdentifier: "headerView") as! SetupTableHeaderView
        header.titleLabel.text = options[section]
        header.optionSwitch.tag = section
        header.optionSwitch.setOn(Setup.shared.stateList()[section], animated: false)
        header.optionSwitch.addTarget(self, action: #selector(switchAction(sender:)), for: .valueChanged)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let standardHeight = tableView.frame.height/5
        
        switch indexPath.section {
        case 0:
            if Setup.shared.accSelectedState{
                return standardHeight
            } else { return 0 }
        case 1:
            if Setup.shared.magSelectedState{
                return standardHeight
            } else { return 0 }
        case 2:
            if Setup.shared.gyroSelectedState{
                return standardHeight
            } else { return 0 }
            
        default:
            return tableView.frame.height/5
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section < 3{
            let cell = setupTableView.dequeueReusableCell(withIdentifier: "expandableCell", for: indexPath) as! ExpandedTableViewCell
            cell.frequencySegment.tag = indexPath.section
            cell.frequencySegment.addTarget(self, action: #selector(setFrequency(sender:)) , for: .valueChanged)
            
            if indexPath.section == 0{
                cell.frequencySegment.selectedSegmentIndex =  Setup.frequencyArray.index(of: Accelerometer.shared.getFrequency())!
            }
            else if indexPath.section == 1{
                cell.frequencySegment.selectedSegmentIndex =  Setup.frequencyArray.index(of: Magnetometer.shared.getFrequency())!
            } else {
                cell.frequencySegment.selectedSegmentIndex =  Setup.frequencyArray.index(of: Gyroscope.shared.getFrequency())!
            }
            
            return cell
        }
        return UITableViewCell()
    }
    
 
}
