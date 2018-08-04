//
//  RegisterViewController.swift
//  vehsense
//
//  Created by Brian Green on 7/31/18.
//  Copyright © 2018 Weida Zhong. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

enum AuthResult{
    case success
    case failed
}

class RegisterViewController: UIViewController {
    
    var databaseReference : DatabaseReference?
    
    let topContainer : UIView = {
        let view = UIView()
        return view
    }()
    
    
    let registerLabel : UILabel = {
        let label = UILabel()
        label.text = "Register"
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
    
    let passwordField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "enter password"
        textField.textAlignment = .center
        textField.borderStyle  = .roundedRect
        textField.textColor = .black
        textField.isSecureTextEntry = true
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.black.cgColor
        return textField
    }()
    
    let confirmField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "confirm password"
        textField.textAlignment = .center
        textField.borderStyle  = .roundedRect
        textField.textColor = .black
        textField.isSecureTextEntry = true
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.black.cgColor
        return textField
    }()
    
    let registerButton : UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "color1"), for: .normal)
        button.setTitle("Register", for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.addTarget(self, action: #selector(RegisterViewController.registerPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    let cancelButton : UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel!.numberOfLines = 1
        button.titleLabel!.adjustsFontSizeToFitWidth = true
        button.titleLabel!.lineBreakMode = .byClipping
        button.addTarget(self, action: #selector(RegisterViewController.cancelPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        AppUtility.lockOrientation(.portrait)
        // Or to rotate and lock
        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Don't forget to reset when view is being removed
        AppUtility.lockOrientation(.all)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        databaseReference = Database.database().reference()
        
        emailField.delegate = self
        passwordField.delegate = self
        confirmField.delegate = self
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:))))
        setupLayout()
        
    }
    
    //responsible for registering, network request is put on another thread for best practice
    @objc func registerPressed(_ sender : UIButton){
        
        guard let email = emailField.text else {
            Alert.showAlert(vc: self, message: "Enter an email address")
            return
        }
        guard let password = passwordField.text else {
            Alert.showAlert(vc: self, message: "Password is nil")
            return
        }
        guard let confirmedPassword = confirmField.text else {
            Alert.showAlert(vc: self, message: "Confirm password is nil")
            return
        }
        
        if password != confirmedPassword {
            Alert.showAlert(vc: self, message: "Passwords are not the same")
            return
        }
        
        DispatchQueue.global(qos: .userInteractive).async {
            Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                
                DispatchQueue.main.async {
                    if let error = error{
                        Alert.showAlert(vc: self, message: error.localizedDescription)
                    } else{
                        if result == nil {
                            Alert.showAlert(vc: self, message: "User error")
                            return
                        } else {
                            Alert.alertWithAction(vc: self, message: "Success", userAction: {
                                self.dismiss(animated: true, completion: nil)
                            })
                        }
                    }
                    
                }
            }
        }
        
    }
    
    @objc func cancelPressed(_ sender : UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupLayout(){
        view.backgroundColor = .white
        
        view.addSubview(topContainer)
        topContainer.translatesAutoresizingMaskIntoConstraints = false
        topContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        topContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        topContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        topContainer.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.2).isActive = true
        
        topContainer.addSubview(registerLabel)
        registerLabel.translatesAutoresizingMaskIntoConstraints = false
        registerLabel.widthAnchor.constraint(equalTo: topContainer.safeAreaLayoutGuide.widthAnchor, multiplier: 0.7).isActive = true
        registerLabel.heightAnchor.constraint(equalTo: topContainer.safeAreaLayoutGuide.heightAnchor, multiplier: 0.7).isActive = true
        registerLabel.centerXAnchor.constraint(equalTo: topContainer.safeAreaLayoutGuide.centerXAnchor).isActive = true
        registerLabel.centerYAnchor.constraint(equalTo: topContainer.safeAreaLayoutGuide.centerYAnchor).isActive = true
        
        view.addSubview(emailField)
        emailField.translatesAutoresizingMaskIntoConstraints = false
        emailField.topAnchor.constraint(equalTo: topContainer.safeAreaLayoutGuide.bottomAnchor, constant: 15).isActive = true
        emailField.centerXAnchor.constraint(equalTo: topContainer.safeAreaLayoutGuide.centerXAnchor).isActive = true
        emailField.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8).isActive = true
        emailField.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.1).isActive = true
        
        view.addSubview(passwordField)
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.topAnchor.constraint(equalTo: emailField.safeAreaLayoutGuide.bottomAnchor, constant: 8).isActive = true
        passwordField.centerXAnchor.constraint(equalTo: emailField.safeAreaLayoutGuide.centerXAnchor).isActive = true
        passwordField.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8).isActive = true
        passwordField.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.1).isActive = true
        
        view.addSubview(confirmField)
        confirmField.translatesAutoresizingMaskIntoConstraints = false
        confirmField.topAnchor.constraint(equalTo: passwordField.safeAreaLayoutGuide.bottomAnchor, constant: 8).isActive = true
        confirmField.centerXAnchor.constraint(equalTo: passwordField.safeAreaLayoutGuide.centerXAnchor).isActive = true
        confirmField.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8).isActive = true
        confirmField.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.1).isActive = true
        
        view.addSubview(registerButton)
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.topAnchor.constraint(equalTo: confirmField.safeAreaLayoutGuide.bottomAnchor, constant: 8).isActive = true
        registerButton.centerXAnchor.constraint(equalTo: confirmField.safeAreaLayoutGuide.centerXAnchor).isActive = true
        registerButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8).isActive = true
        registerButton.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.1).isActive = true
        
        view.addSubview(cancelButton)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
        cancelButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
        
        
    }

}

extension RegisterViewController : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
