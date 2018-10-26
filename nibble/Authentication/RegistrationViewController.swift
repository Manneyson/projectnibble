//
//  RegistrationViewController.swift
//  StartMySaas
//
//  Created by Sawyer Billings on 8/24/18.
//  Copyright © 2018 EclipseCode. All rights reserved.
//

import UIKit
import Firebase
import MaterialComponents.MaterialButtons


class RegistrationViewController: UIViewController {

    // Close button
    let close: UIButton = {
        let close = UIButton()
        close.translatesAutoresizingMaskIntoConstraints = false
        close.addTarget(self, action: #selector(closePressed(sender:)), for: .touchUpInside)
        close.setBackgroundImage(UIImage(named: "close"), for: .normal)
        return close
    }()
    
    // Page title
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Register for Renty"
        titleLabel.font = UIFont(name: "Avenir-Heavy", size: 24)
        titleLabel.textColor = .black
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
    
    // Venmo username field
    let venmo: UITextField = {
        let venmo = UITextField()
        venmo.translatesAutoresizingMaskIntoConstraints = false
        venmo.font = UIFont(name: "Avenir-Heavy", size: 18)
        venmo.textColor = .black
        venmo.placeholder = "Venmo Username"
        return venmo
    }()
    
    // Phone field
    let phone: UITextField = {
        let phone = UITextField()
        phone.translatesAutoresizingMaskIntoConstraints = false
        phone.font = UIFont(name: "Avenir-Heavy", size: 18)
        phone.textColor = .black
        phone.placeholder = "Phone Number"
        phone.keyboardType = .phonePad
        return phone
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
    
    let registerButton: MDCRaisedButton = {
        let registerButton = MDCRaisedButton()
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.setTitle("Register", for: .normal)
        registerButton.addTarget(self, action: #selector(registerPressed(sender:)), for: .touchUpInside)
        registerButton.setElevation(ShadowElevation(rawValue: 12), for: .normal)
        registerButton.setTitleColor(.black, for: .normal)
        registerButton.backgroundColor = .white
        return registerButton
    }()
    
    // Enumerator for handling different cases of authentication failure.
    enum AuthError {
        case incomplete, fail
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Place a listener on the "state" of the user. As soon as we have
        // a successful registration from Firebase, this will trigger and send
        // our users to the home page! Cool right?
        
        Auth.auth().addStateDidChangeListener() { auth, user in
            if user != nil {
                self.performSegue(withIdentifier: "AuthSuccess", sender: nil)
            }
        }
        
        layoutView()
    }
    
    // You've seen it before. This function dismisses the current view. 
    @objc func closePressed(sender: UIButton?) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func registerPressed(sender: Any?) {
        if (nameField.text != "" && emailField.text != "" && passwordField.text != "" && venmo.text != ""
                && phone.text != "") {
        //self.registerButton.loadingIndicator(show: true)
        Auth.auth().createUser(withEmail: emailField.text!,
                               password: passwordField.text!) { user, error in
                                if error == nil {
                                    //write user to users
                                    let db = Firestore.firestore()
                                    let email = self.emailField.text!
                                    let venmo = self.venmo.text!
                                    let phone = self.phone.text!
                                    let name = self.nameField.text!
                                    db.collection("users").document(email.lowercased()).setData([
                                        "email": email.lowercased(),
                                        "venmo": venmo,
                                        "phone": phone,
                                        "name": name
                                    ]) { err in
                                        if err != nil {
                                            self.authError(type: .fail)
                                        } else {
                                            print("Document successfully written!")
                                        }
                                    }
                                    Auth.auth().signIn(withEmail: self.emailField.text!,
                                                       password: self.passwordField.text!)
                                } else {
                                    print(error.debugDescription)
                                    //self.registerButton.loadingIndicator(show: false)
                                    self.authError(type: .fail)
                                }
                            }
        } else {
            //self.registerButton.loadingIndicator(show: false)
            self.authError(type: .incomplete)
        }
    }
    
    // Function for handling different types of authentication errors
    func authError(type: AuthError) {
        if type == .incomplete {
            let alertController = UIAlertController(title: "Incomplete Registration Form", message: "Please fill out all required fields!", preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(ok)
            self.present(alertController, animated: true)
        } else {
            let alertController = UIAlertController(title: "Registration Failed", message: "Make sure your email address is valid and your password is of secure length.", preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(ok)
            self.present(alertController, animated: true)
        }
    }
    
    // This function gets reused throughout the app in different forms.
    // On each screen we build out elements and lay them out programatically based
    // on the positioning of one another. This makes our UI easily adaptable!
    func layoutView() {
        
        var constraints = [NSLayoutConstraint]()
        
        view.addSubview(close)
        view.addSubview(titleLabel)
        view.addSubview(nameField)
        view.addSubview(venmo)
        view.addSubview(phone)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(registerButton)
        
        constraints.append(NSLayoutConstraint(item: close,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: .top,
                                              multiplier: 1,
                                              constant: 20))
        constraints.append(NSLayoutConstraint(item: close,
                                              attribute: .leading,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: .leading,
                                              multiplier: 1,
                                              constant: 20))
        constraints.append(NSLayoutConstraint(item: close,
                                              attribute: .height,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: .height,
                                              multiplier: 0,
                                              constant: 40))
        constraints.append(NSLayoutConstraint(item: close,
                                              attribute: .width,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: .width,
                                              multiplier: 0,
                                              constant: 40))
        
        constraints.append(NSLayoutConstraint(item: titleLabel,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: close,
                                              attribute: .bottom,
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
        constraints.append(NSLayoutConstraint(item: nameField,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: titleLabel,
                                              attribute: .bottom,
                                              multiplier: 1,
                                              constant: 40))
        constraints.append(NSLayoutConstraint(item: nameField,
                                              attribute: .centerX,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: .centerX,
                                              multiplier: 1,
                                              constant: 0))
        constraints.append(NSLayoutConstraint(item: nameField,
                                              attribute: .width,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: .width,
                                              multiplier: 0.7,
                                              constant: 0))
        constraints.append(NSLayoutConstraint(item: venmo,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: nameField,
                                              attribute: .bottom,
                                              multiplier: 1,
                                              constant: 40))
        constraints.append(NSLayoutConstraint(item: venmo,
                                              attribute: .centerX,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: .centerX,
                                              multiplier: 1,
                                              constant: 0))
        constraints.append(NSLayoutConstraint(item: venmo,
                                              attribute: .width,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: .width,
                                              multiplier: 0.7,
                                              constant: 0))
        constraints.append(NSLayoutConstraint(item: phone,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: venmo,
                                              attribute: .bottom,
                                              multiplier: 1,
                                              constant: 40))
        constraints.append(NSLayoutConstraint(item: phone,
                                              attribute: .centerX,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: .centerX,
                                              multiplier: 1,
                                              constant: 0))
        constraints.append(NSLayoutConstraint(item: phone,
                                              attribute: .width,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: .width,
                                              multiplier: 0.7,
                                              constant: 0))
        constraints.append(NSLayoutConstraint(item: emailField,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: phone,
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
        constraints.append(NSLayoutConstraint(item: registerButton,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: passwordField,
                                              attribute: .bottom,
                                              multiplier: 1,
                                              constant: 40))
        constraints.append(NSLayoutConstraint(item: registerButton,
                                              attribute: .centerX,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: .centerX,
                                              multiplier: 1,
                                              constant: 0))
        constraints.append(NSLayoutConstraint(item: registerButton,
                                              attribute: .width,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: .width,
                                              multiplier: 0.7,
                                              constant: 0))
        
        NSLayoutConstraint.activate(constraints)
    }
    
}
