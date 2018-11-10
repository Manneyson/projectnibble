//
//  LoginViewController.swift
//  nibble
//
//  Created by Sawyer Billings on 10/25/18.
//  Copyright © 2018 sbilling. All rights reserved.
//

import UIKit
import Firebase
import MaterialComponents.MaterialButtons

class LoginViewController: UIViewController {
    
    // Page title
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Nibble Login"
        titleLabel.font = UIFont(name: "Avenir-Heavy", size: 24)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    // Name field
    let nameField: UITextField = {
        let nameField = UITextField()
        nameField.translatesAutoresizingMaskIntoConstraints = false
        nameField.font = UIFont(name: "Avenir-Heavy", size: 18)
        nameField.textColor = .black
        nameField.placeholder = "Full Name"
        return nameField
    }()
    
    // Email field
    let emailField: UITextField = {
        let emailField = UITextField()
        emailField.translatesAutoresizingMaskIntoConstraints = false
        emailField.font = UIFont(name: "Avenir-Heavy", size: 18)
        emailField.textColor = .black
        emailField.placeholder = "Email"
        return emailField
    }()
    
    // Password field
    let passwordField: UITextField = {
        let passwordField = UITextField()
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.font = UIFont(name: "Avenir-Heavy", size: 18)
        passwordField.textColor = .black
        passwordField.isSecureTextEntry = true
        passwordField.placeholder = "Password"
        return passwordField
    }()
    
    let loginButton: MDCRaisedButton = {
        let loginButton = MDCRaisedButton()
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.setTitle("Login", for: .normal)
        loginButton.addTarget(self, action: #selector(loginPressed(sender:)), for: .touchUpInside)
        loginButton.setElevation(ShadowElevation(rawValue: 12), for: .normal)
        loginButton.setTitleColor(.black, for: .normal)
        loginButton.backgroundColor = .white
        return loginButton
    }()
    
    let signupButton: MDCRaisedButton = {
        let signupButton = MDCRaisedButton()
        signupButton.translatesAutoresizingMaskIntoConstraints = false
        signupButton.setTitle("Sign Up", for: .normal)
        signupButton.addTarget(self, action: #selector(loginPressed(sender:)), for: .touchUpInside)
        signupButton.setElevation(ShadowElevation(rawValue: 12), for: .normal)
        signupButton.setTitleColor(.black, for: .normal)
        signupButton.backgroundColor = .white
        return signupButton
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Auth.auth().addStateDidChangeListener() { auth, user in
            if user != nil {
                self.performSegue(withIdentifier: "authenticatedSegue", sender: nil)
            }
        }
        
        layoutView()
    }
    
    @objc func closePressed(sender: UIButton?) {
        
        // This will dismiss us back to the first screen.
        // Pretty self explanatory right?
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func loginPressed(sender: Any?) {
        
        if (emailField.text != "" && passwordField.text != "") {
            Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!, completion: { (user, error) in
                if (error != nil) {
                    self.authError(type: .fail)
                }
            })
        } else {
            self.authError(type: .incomplete)
        }
    }
    
    // Function for handling different types of authentication errors
    func authError(type: AuthError) {
        if type == .incomplete {
            let alertController = UIAlertController(title: "Incomplete Login", message: "Please fill out all fields!", preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(ok)
            self.present(alertController, animated: true)
        } else {
            let alertController = UIAlertController(title: "Login Failed", message: "Incorrect email/password combination", preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(ok)
            self.present(alertController, animated: true)
        }
    }
    
    // This function gets reused throughout the app in different forms.
    // On each screen we build out elements and lay them out programatically based
    // on the positioning of one another. This makes our UI easily adaptable!
    func layoutView() {
        
        var marginGuide = view.layoutMarginsGuide
        if #available(iOS 11.0, *) {
            marginGuide = view.safeAreaLayoutGuide
        }
        
        var constraints = [NSLayoutConstraint]()
        
        view.addSubview(titleLabel)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(loginButton)
        view.addSubview(signupButton)
    
        
        constraints.append(NSLayoutConstraint(item: titleLabel,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: marginGuide,
                                              attribute: .top,
                                              multiplier: 1,
                                              constant: 30))
        constraints.append(NSLayoutConstraint(item: titleLabel,
                                              attribute: .centerX,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: .centerX,
                                              multiplier: 1,
                                              constant: 0))
        constraints.append(NSLayoutConstraint(item: titleLabel,
                                              attribute: .width,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: .width,
                                              multiplier: 0.7,
                                              constant: 0))
        constraints.append(NSLayoutConstraint(item: emailField,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: titleLabel,
                                              attribute: .bottom,
                                              multiplier: 1,
                                              constant: 40))
        constraints.append(NSLayoutConstraint(item: emailField,
                                              attribute: .centerX,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: .centerX,
                                              multiplier: 1,
                                              constant: 0))
        constraints.append(NSLayoutConstraint(item: emailField,
                                              attribute: .width,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: .width,
                                              multiplier: 0.7,
                                              constant: 0))
        constraints.append(NSLayoutConstraint(item: passwordField,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: emailField,
                                              attribute: .bottom,
                                              multiplier: 1,
                                              constant: 40))
        constraints.append(NSLayoutConstraint(item: passwordField,
                                              attribute: .centerX,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: .centerX,
                                              multiplier: 1,
                                              constant: 0))
        constraints.append(NSLayoutConstraint(item: passwordField,
                                              attribute: .width,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: .width,
                                              multiplier: 0.7,
                                              constant: 0))
        constraints.append(NSLayoutConstraint(item: loginButton,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: passwordField,
                                              attribute: .bottom,
                                              multiplier: 1,
                                              constant: 40))
        constraints.append(NSLayoutConstraint(item: loginButton,
                                              attribute: .centerX,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: .centerX,
                                              multiplier: 1,
                                              constant: 0))
        constraints.append(NSLayoutConstraint(item: loginButton,
                                              attribute: .width,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: .width,
                                              multiplier: 0.7,
                                              constant: 0))
        constraints.append(NSLayoutConstraint(item: signupButton,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: loginButton,
                                              attribute: .bottom,
                                              multiplier: 1,
                                              constant: 20))
        constraints.append(NSLayoutConstraint(item: signupButton,
                                              attribute: .centerX,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: .centerX,
                                              multiplier: 1,
                                              constant: 0))
        constraints.append(NSLayoutConstraint(item: signupButton,
                                              attribute: .width,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: .width,
                                              multiplier: 0.7,
                                              constant: 0))
        
        NSLayoutConstraint.activate(constraints)
    }
}
