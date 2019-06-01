//
//  AccountViewController.swift
//  vehsense
//
//  Created by Brian Green on 8/1/18.
//  Copyright © 2018 Weida Zhong. All rights reserved.
//

import UIKit
import FirebaseAuth

class AccountViewController: UIViewController {
    
    let tableView : UITableView = {
        let table = UITableView()
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setupLayout()
    }
    
    
    func setupLayout(){
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }

}


extension AccountViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "defaultCell")
        cell.textLabel?.text = "Sign Out"
        cell.textLabel?.textColor = UIColor.blue
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            DataRecording.shared.stopRecording() //makes sure to reset recording state, should reset all states in future
            GPS.shared.isRecording = false
            
            if let username = Auth.auth().currentUser?.email{
                let alertController = UIAlertController(title: NSLocalizedString("\(username) has been signed out", comment: ""), message: NSLocalizedString("", comment: ""), preferredStyle: .alert)
                let action = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .cancel) { (_) in
                    self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
                }
                alertController.addAction(action)
                do{
                    try Auth.auth().signOut()
                    present(alertController, animated: true, completion: nil)
                    
                }
                catch{
                    print(error.localizedDescription)
                }

            } else{
                 self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
}
