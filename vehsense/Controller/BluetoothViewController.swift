//
//  BluetoothViewController.swift
//  vehsense
//
//  Created by Brian Green on 6/24/18.
//  Copyright © 2018 Weida Zhong. All rights reserved.
//

import UIKit
import CoreBluetooth

class BluetoothViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var bluetoothTableView: UITableView!
    var deviceArray = [CBPeripheral]()
    
    var centralManager : CBCentralManager!
    var currentPeripheral : CBPeripheral?
    
    var currentRow : IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        centralManager = CBCentralManager(delegate: self, queue: nil)
        bluetoothTableView.dataSource = self
        bluetoothTableView.delegate = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension BluetoothViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deviceArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = bluetoothTableView.dequeueReusableCell(withIdentifier: "bluetoothCell", for: indexPath) as! BluetoothTableViewCell
        cell.deviceName.text = deviceArray[indexPath.row].name ?? "no name"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        currentRow = indexPath
        
        if let currentPeripheral = currentPeripheral{
            if currentPeripheral.isEqual(deviceArray[indexPath.row]){
                let alertMessage = "Do you want to disconnect from \(currentPeripheral.name ?? "no name")?"
                let alert = UIAlertController(title: "Disconnect", message: alertMessage, preferredStyle: .alert)
                let yes = UIAlertAction(title: "Yes", style: .destructive) { (action) in
                    self.centralManager.cancelPeripheralConnection(currentPeripheral)
                }
                let no = UIAlertAction(title: "No", style: .destructive, handler: nil)
                
                alert.addAction(yes)
                alert.addAction(no)
                present(alert, animated: true, completion: nil)
            }
        }
            
        else{
            
            let alertMessage = "Do you want to connect to \(deviceArray[indexPath.row].name ?? "no name")?"
            let alert = UIAlertController(title: "Connect", message: alertMessage, preferredStyle: .alert)
            
            let yes = UIAlertAction(title: "Yes", style: .destructive) { (action) in
                self.centralManager.connect(self.deviceArray[indexPath.row], options: nil)
                
            }
            let no = UIAlertAction(title: "No", style: .destructive, handler: nil)
            
            alert.addAction(yes)
            alert.addAction(no)
            present(alert, animated: true, completion: nil)
        }
        
        bluetoothTableView.deselectRow(at: indexPath, animated: true)
    }
}


extension BluetoothViewController : CBCentralManagerDelegate{
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == CBManagerState.poweredOn{
            central.scanForPeripherals(withServices: nil, options: nil)
        }else{
            navigationController?.popViewController(animated: true)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if !deviceArray.contains(peripheral){
            deviceArray.append(peripheral)
            self.bluetoothTableView.reloadData()
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        let currentCell = bluetoothTableView.cellForRow(at:self.currentRow!) as! BluetoothTableViewCell
        currentCell.connectionStatusLabel.text = "Connected"
        currentCell.connectionStatusLabel.textColor = UIColor.green
        currentPeripheral = peripheral
        currentPeripheral?.discoverServices(nil)
        currentPeripheral?.delegate = self
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        let currentCell = bluetoothTableView.cellForRow(at:self.currentRow!) as! BluetoothTableViewCell
        currentCell.connectionStatusLabel.text = "Not Connected"
        currentCell.connectionStatusLabel.textColor = UIColor.red
        currentPeripheral = nil
        central.scanForPeripherals(withServices: nil, options: nil)
    }
    
    
}

extension BluetoothViewController : CBPeripheralDelegate{
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
      
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
    }
    
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
    }
    
    func updatecharacteristic(char : CBCharacteristic){

    }

}
