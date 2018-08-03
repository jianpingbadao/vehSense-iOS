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
    
    var originalY : CGFloat?
    
    let topContainer : UIView = {
        let view = UIView()
        return view
    }()
    
    let bottomContainer : UIView = {
        let view = UIView()
        return view
    }()
    
    let stackView : UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.alignment = .center
        return stack
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
    
    let guestButton : UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "color2"), for: .normal)
        button.setTitle("Guest", for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.addTarget(self, action: #selector(SignInViewController.guestPressed(_:)), for: .touchUpInside)
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        setupLayout()
        
        let savedEmail = UserDefaults.standard.string(forKey: "email")
        if let email = savedEmail{
            emailField.text = email
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        originalY = passwordField.frame.origin.y
        if passwordField.isEditing{
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                self.emailField.isEnabled = false
                UIView.animate(withDuration: 0.1, animations: { () -> Void in
                    self.passwordField.frame.origin.y -= (keyboardSize.height/3)
                    self.emailField.alpha = 0
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if passwordField.isEditing{
            UIView.animate(withDuration: 0.1, animations: {
                self.emailField.alpha = 1
                self.passwordField.frame.origin.y = self.originalY!
                self.view.layoutIfNeeded()
            }) { (true) in
                self.emailField.isEnabled = true
            }
        }
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
                    UserDefaults.standard.set(self.emailField.text, forKey: "email")
                    let entryVC = self.storyboard?.instantiateViewController(withIdentifier: "entryVC") as! UITabBarController
                    self.present(entryVC, animated: true, completion: nil)
                }
                
            }
        }
    }
    
    @objc func guestPressed(_ sender : UIButton){
        let entryVC = self.storyboard?.instantiateViewController(withIdentifier: "entryVC") as! UITabBarController
        self.present(entryVC, animated: true, completion: nil)
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
        
        view.addSubview(bottomContainer)
        bottomContainer.translatesAutoresizingMaskIntoConstraints = false
        bottomContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        bottomContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        bottomContainer.topAnchor.constraint(equalTo: topContainer.safeAreaLayoutGuide.bottomAnchor).isActive = true
        bottomContainer.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.5).isActive = true
        
        bottomContainer.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: bottomContainer.safeAreaLayoutGuide.topAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: bottomContainer.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomContainer.safeAreaLayoutGuide.bottomAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: bottomContainer.safeAreaLayoutGuide.centerXAnchor).isActive = true
        
        stackView.addArrangedSubview(emailField)
        emailField.translatesAutoresizingMaskIntoConstraints = false
        emailField.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        emailField.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        emailField.heightAnchor.constraint(equalTo: stackView.safeAreaLayoutGuide.heightAnchor, multiplier: 0.2).isActive = true
        
        stackView.addArrangedSubview(passwordField)
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        passwordField.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        passwordField.heightAnchor.constraint(equalTo: stackView.safeAreaLayoutGuide.heightAnchor, multiplier: 0.2).isActive = true
        
        stackView.addArrangedSubview(signInButton)
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        signInButton.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        signInButton.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        signInButton.heightAnchor.constraint(equalTo: stackView.safeAreaLayoutGuide.heightAnchor, multiplier: 0.2).isActive = true
        
        stackView.addArrangedSubview(guestButton)
        guestButton.translatesAutoresizingMaskIntoConstraints = false
        guestButton.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        guestButton.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        guestButton.heightAnchor.constraint(equalTo: stackView.safeAreaLayoutGuide.heightAnchor, multiplier: 0.2).isActive = true
        
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
