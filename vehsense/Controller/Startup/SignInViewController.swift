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
    
    //Stores original location of password text field so view knows where to put it back when animation is finished
    var passwordOrigin : CGFloat? { didSet { passwordOrigin = oldValue ?? passwordOrigin } }
    var passwordDestination : CGFloat? { didSet { passwordDestination = oldValue ?? passwordDestination } }
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        AppUtility.lockOrientation(.portrait)
        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
    }
    

    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //Check Orientation class
        AppUtility.lockOrientation(.all)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.delegate = self
        passwordField.delegate = self
        view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:))))
        
        //notified when keyboard appears on screen
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    
        setupLayout()
        
        let savedEmail = UserDefaults.standard.string(forKey: "email")
        if let email = savedEmail{
            emailField.text = email
        }
        
    }
    
    //responsible for animating password field when keyboard shows
    @objc func keyboardWillShow(notification: NSNotification) {
        self.passwordOrigin = self.passwordField.frame.origin.y
        if passwordField.isEditing{
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                if let origin = self.passwordOrigin{
                    self.passwordDestination =  origin - (keyboardSize.height/3)
                    self.emailField.isEnabled = false
                    UIView.animate(withDuration: 0.1, animations: { () -> Void in
                        if let destination = self.passwordDestination{
                            self.passwordField.frame.origin.y = destination
                            self.emailField.alpha = 0
                            self.view.layoutIfNeeded()
                        }
                    })
                }
            }
        }
    }
    
    //responsible for animating password field when keyboard shows
    @objc func keyboardWillHide(notification: NSNotification) {
        if passwordField.isEditing{
            self.emailField.isEnabled = false
            UIView.animate(withDuration: 0.1, animations: {
                self.emailField.alpha = 1
                if let origin = self.passwordOrigin{
                    self.passwordField.frame.origin.y = origin
                }
                
                self.view.layoutIfNeeded()
            }) { (true) in
                self.emailField.isEnabled = true
            }
        }
    }
    
    //responsible for signing in, network request is put on another thread for best practice
    @objc func signInPressed(sender : UIButton){
        
        guard let text = emailField.text else { return }
        
        let email = text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard let password = passwordField.text else { return }
        
        DispatchQueue.global(qos: .userInteractive).async {
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                
                DispatchQueue.main.async {
                    if let error = error{
                        Alert.showAlert(vc: self, message: error.localizedDescription)
                    } else{
                        if user == nil{
                            Alert.showAlert(vc: self, message: "User error")
                        } else{
                            UserDefaults.standard.set(self.emailField.text, forKey: "email")
                            let entryVC = self.storyboard?.instantiateViewController(withIdentifier: "entryVC") as! UITabBarController
                            self.present(entryVC, animated: true, completion: nil)
                            self.passwordField.text = ""
                        }
                    }
                    
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
