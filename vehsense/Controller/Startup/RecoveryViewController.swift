//
//  RecoveryViewController.swift
//  vehsense
//
//  Created by Brian Green on 8/1/18.
//  Copyright © 2018 Weida Zhong. All rights reserved.
//

import UIKit
import FirebaseAuth

class RecoveryViewController: UIViewController {
    
    let topContainer : UIView = {
        let view = UIView()
        return view
    }()
    
    
    let recoveryLabel : UILabel = {
        let label = UILabel()
        label.text = "Reset Password"
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        return label
    }()
    
    let emailField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "enter email address"
        textField.textAlignment = .center
        textField.borderStyle  = .roundedRect
        textField.textColor = .black
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.black.cgColor
        return textField
    }()
    
    let recoveryButton : UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "color1"), for: .normal)
        button.setTitle("Send Email", for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.addTarget(self, action: #selector(RecoveryViewController.recoveryPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    let cancelButton : UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel!.numberOfLines = 1
        button.titleLabel!.adjustsFontSizeToFitWidth = true
        button.titleLabel!.lineBreakMode = .byClipping
        button.addTarget(self, action: #selector(RecoveryViewController.cancelPressed(_:)), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.delegate = self
        view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:))))
        setupLayout()
    }
    
    @objc func recoveryPressed(_ sender : UIButton){
        
        guard let email = emailField.text else {
            createAlert(result: .failed, message: "Invalid email")
            return
        }
        
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if let error = error{
                self.createAlert(result: .failed, message: error.localizedDescription)
            } else{
                self.createAlert(result: .success, message: "Password reset sent")
            }
        }
    }
    
    @objc func cancelPressed(_ sender : UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    func createAlert(result : AuthResult, message : String){
        var action : UIAlertAction
        
        let alertController = UIAlertController(title: NSLocalizedString(message, comment: ""), message: NSLocalizedString("", comment: ""), preferredStyle: .alert)
        
        switch result {
            
        case .failed:
            action = UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .cancel, handler: nil)
            
        case .success:
            action = UIAlertAction(title: NSLocalizedString("return home", comment: ""), style: .cancel) { (_) in
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func setupLayout(){
        view.backgroundColor = .white
        
        view.addSubview(topContainer)
        topContainer.translatesAutoresizingMaskIntoConstraints = false
        topContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        topContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        topContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        topContainer.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.5).isActive = true
        
        topContainer.addSubview(recoveryLabel)
        recoveryLabel.translatesAutoresizingMaskIntoConstraints = false
        recoveryLabel.widthAnchor.constraint(equalTo: topContainer.safeAreaLayoutGuide.widthAnchor).isActive = true
        recoveryLabel.heightAnchor.constraint(equalTo: topContainer.safeAreaLayoutGuide.heightAnchor, multiplier: 0.7).isActive = true
        recoveryLabel.centerXAnchor.constraint(equalTo: topContainer.safeAreaLayoutGuide.centerXAnchor).isActive = true
        recoveryLabel.centerYAnchor.constraint(equalTo: topContainer.safeAreaLayoutGuide.centerYAnchor).isActive = true
        
        view.addSubview(emailField)
        emailField.translatesAutoresizingMaskIntoConstraints = false
        emailField.topAnchor.constraint(equalTo: recoveryLabel.safeAreaLayoutGuide.bottomAnchor, constant: 20).isActive = true
        emailField.centerXAnchor.constraint(equalTo: topContainer.safeAreaLayoutGuide.centerXAnchor).isActive = true
        emailField.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8).isActive = true
        emailField.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.1).isActive = true
        
        
        view.addSubview(recoveryButton)
        recoveryButton.translatesAutoresizingMaskIntoConstraints = false
        recoveryButton.topAnchor.constraint(equalTo: emailField.safeAreaLayoutGuide.bottomAnchor, constant: 8).isActive = true
        recoveryButton.centerXAnchor.constraint(equalTo: emailField.safeAreaLayoutGuide.centerXAnchor).isActive = true
        recoveryButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8).isActive = true
        recoveryButton.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.1).isActive = true
        
        view.addSubview(cancelButton)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
        cancelButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
        
        
    }

}

extension RecoveryViewController : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
