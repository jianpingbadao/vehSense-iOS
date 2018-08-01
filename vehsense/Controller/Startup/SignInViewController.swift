//
//  SignInViewController.swift
//  vehsense
//
//  Created by Brian Green on 6/18/18.
//  Copyright © 2018 Weida Zhong. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController {
    
    let topContainer : UIView = {
        let view = UIView()
        return view
    }()
    
    let logo : UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "logo")
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    let logoTitle : UILabel = {
        let label = UILabel()
        label.text = "vehSense"
        label.font = UIFont.boldSystemFont(ofSize: 16)
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
    
    let signInButton : UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "color1"), for: .normal)
        button.setTitle("Sign In", for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.addTarget(self, action: #selector(SignInViewController.signInPressed(sender:)), for: .touchUpInside)
        return button
    }()
    
    let forgotButton : UIButton = {
        let button = UIButton()
        button.setTitle("Forgot password?", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel!.numberOfLines = 1
        button.titleLabel!.adjustsFontSizeToFitWidth = true
        button.titleLabel!.lineBreakMode = .byClipping
        button.addTarget(self, action: #selector(SignInViewController.recoveryPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    let registerButton : UIButton = {
        let button = UIButton()
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel!.numberOfLines = 1
        button.titleLabel!.adjustsFontSizeToFitWidth = true
        button.titleLabel!.lineBreakMode = .byClipping
        button.addTarget(self, action: #selector(SignInViewController.registerPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.delegate = self
        passwordField.delegate = self
        view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:))))
        setupLayout()
    }
    
    @objc func signInPressed(sender : UIButton){
        
        guard let email = emailField.text else { return }
        guard let password = passwordField.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error{
                self.createAlert(result: .failed, message: error.localizedDescription)
            } else{
                if user == nil{
                    self.createAlert(result: .failed, message: "Error")
                } else{
                    let entryVC = self.storyboard?.instantiateViewController(withIdentifier: "entryVC") as! UITabBarController
                    self.present(entryVC, animated: true, completion: nil)
                }
            }
        }
    }
    
    @objc func registerPressed(_ sender : UIButton){
        let registerVC = RegisterViewController()
        present(registerVC, animated: true, completion: nil)
    }
    
    @objc func recoveryPressed(_ sender : UIButton){
        let recoveryVC = RecoveryViewController()
        present(recoveryVC, animated: true, completion: nil)
    }
    
    func createAlert(result : AuthResult, message : String){
        var action : UIAlertAction
        
        let alertController = UIAlertController(title: NSLocalizedString(message, comment: ""), message: NSLocalizedString("", comment: ""), preferredStyle: .alert)
        
        switch result {
            
        case .failed:
            action = UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .cancel, handler: nil)
            
        case .success:
            action = UIAlertAction(title: NSLocalizedString("Sign in", comment: ""), style: .cancel) { (_) in
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func setupLayout(){
        view.addSubview(topContainer)
        topContainer.translatesAutoresizingMaskIntoConstraints = false
        topContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        topContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        topContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        topContainer.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.4).isActive = true
        
        topContainer.addSubview(logo)
        logo.translatesAutoresizingMaskIntoConstraints = false
        logo.centerXAnchor.constraint(equalTo: topContainer.safeAreaLayoutGuide.centerXAnchor).isActive = true
        logo.centerYAnchor.constraint(equalTo: topContainer.safeAreaLayoutGuide.centerYAnchor).isActive = true
        logo.heightAnchor.constraint(equalTo: topContainer.safeAreaLayoutGuide.heightAnchor, multiplier: 0.7).isActive = true
        logo.widthAnchor.constraint(equalTo: topContainer.safeAreaLayoutGuide.widthAnchor, multiplier: 0.7).isActive = true
        
        topContainer.addSubview(logoTitle)
        logoTitle.translatesAutoresizingMaskIntoConstraints = false
        logoTitle.topAnchor.constraint(equalTo: logo.bottomAnchor).isActive = true
        logoTitle.widthAnchor.constraint(equalTo: topContainer.safeAreaLayoutGuide.widthAnchor, multiplier: 0.5).isActive = true
        logoTitle.centerXAnchor.constraint(equalTo: logo.safeAreaLayoutGuide.centerXAnchor).isActive = true
        
        view.addSubview(emailField)
        emailField.translatesAutoresizingMaskIntoConstraints = false
        emailField.topAnchor.constraint(equalTo: topContainer.safeAreaLayoutGuide.bottomAnchor, constant: 20).isActive = true
        emailField.centerXAnchor.constraint(equalTo: topContainer.safeAreaLayoutGuide.centerXAnchor).isActive = true
        emailField.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8).isActive = true
        emailField.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.1).isActive = true
        
        view.addSubview(passwordField)
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.topAnchor.constraint(equalTo: emailField.safeAreaLayoutGuide.bottomAnchor, constant: 8).isActive = true
        passwordField.centerXAnchor.constraint(equalTo: emailField.safeAreaLayoutGuide.centerXAnchor).isActive = true
        passwordField.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8).isActive = true
        passwordField.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.1).isActive = true
        
        view.addSubview(signInButton)
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        signInButton.topAnchor.constraint(equalTo: passwordField.safeAreaLayoutGuide.bottomAnchor, constant: 8).isActive = true
        signInButton.centerXAnchor.constraint(equalTo: passwordField.safeAreaLayoutGuide.centerXAnchor).isActive = true
        signInButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8).isActive = true
        signInButton.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.1).isActive = true
        
        view.addSubview(forgotButton)
        forgotButton.translatesAutoresizingMaskIntoConstraints = false
        forgotButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
        forgotButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
        
        view.addSubview(registerButton)
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
        registerButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        
    }

}

extension SignInViewController : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
