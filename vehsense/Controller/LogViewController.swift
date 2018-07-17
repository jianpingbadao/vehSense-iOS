//
//  LogViewController.swift
//  vehsense
//
//  Created by Brian Green on 7/11/18.
//  Copyright © 2018 Weida Zhong. All rights reserved.
//

import UIKit
import CoreData

class LogViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var sessionList = [DriveSession]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        do{
            let driveSessions = try PersistenceManager.shared.context.fetch(DriveSession.fetchRequest()) as! [DriveSession]
            
            for session in driveSessions{
                if !sessionList.contains(session){
                    sessionList.append(session)
                }
            }
            tableView.reloadData()
        }
            
        catch{
            print(error.localizedDescription)
        }
        
    }

}



extension LogViewController : UITableViewDelegate{
    
}

extension LogViewController : UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sessionList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "logCell", for: indexPath) as! LogTableViewCell
        cell.sessionTimestamp.text = sessionList[indexPath.row].sessionStartTime
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let driveSessionViewController = self.storyboard?.instantiateViewController(withIdentifier: "driveSessionViewController") as! DriveSessionViewController
        tableView.deselectRow(at: indexPath, animated: true)
        driveSessionViewController.driveSession = sessionList[indexPath.row]
        
        self.navigationController?.pushViewController(driveSessionViewController, animated: true)
        
    }
}

