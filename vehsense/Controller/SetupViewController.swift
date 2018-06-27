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
        case 4:
            print("OBD")

        default:
            break
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
        cell.optionSwitch.addTarget(self, action: #selector(switchAction(sender:)), for: .valueChanged)
        return cell
    }
    
}
