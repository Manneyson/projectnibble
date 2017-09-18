/*
 * Copyright (c) 2015 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import FirebaseAuth
import Firebase

class LoginViewController: UIViewController {
  
  // MARK: Constants
  let loginToList = "LoginToList"

    var identifiers : [String] = []
    var restaurants : [String] = []
    var restaurant = ""
  
  // MARK: Outlets
  @IBOutlet weak var textFieldLoginEmail: UITextField!
  @IBOutlet weak var textFieldLoginPassword: UITextField!
  
    @IBOutlet weak var restaurantLogin: UIButton!
    @IBOutlet weak var signUp: UIButton!
    @IBOutlet var bgView: UIView!
    @IBOutlet weak var login: UIButton!
  // MARK: Actions
    
    @IBAction func loginDidTouch(_ sender: AnyObject) {
        Auth.auth().signIn(withEmail: textFieldLoginEmail.text!,
                               password: textFieldLoginPassword.text!)
    }
  
  @IBAction func signUpDidTouch(_ sender: AnyObject) {
    let alert = UIAlertController(title: "Register",
                                  message: "Please provide us with an email and password",
                                  preferredStyle: .alert)
    let cancelAction = UIAlertAction(title: "Cancel", style: .default)
    
    let saveAction = UIAlertAction(title: "Register",
                                   style: .default) { action in
                                    // 1
                                    let emailField = alert.textFields![0]
                                    let passwordField = alert.textFields![1]
                                    
                                    // 2
                                    Auth.auth().createUser(withEmail: emailField.text!,
                                                               password: passwordField.text!) { user, error in
                                                                if error == nil {
                                                                    // 3
                                                                    Auth.auth().signIn(withEmail: self.textFieldLoginEmail.text!,
                                                                                           password: self.textFieldLoginPassword.text!)
                                                                }
                                    }
                                    
        }
    alert.addTextField { textEmail in
        textEmail.placeholder = "Email"
    }
    
    alert.addTextField { textPassword in
        textPassword.isSecureTextEntry = true
        textPassword.placeholder = "Password"
    }
    
    alert.addAction(cancelAction)
    alert.addAction(saveAction)
    
    present(alert, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        login.backgroundColor = UIColor.white
        bgView.backgroundColor = UIColor(patternImage: UIImage(named:"bgLogin")!)
        signUp.layer.borderColor = UIColor.white.cgColor
        restaurantLogin.layer.borderColor = UIColor.clear.cgColor
        restaurantLogin.addTarget(self, action: #selector(restaurantLoginDidTouch(_:)), for: .touchUpInside)
                
        //Query restaurants
        let items = Database.database().reference().child("restaurantAccounts")
        items.observe(.value, with: { snapshot in
            for item in snapshot.children.allObjects as! [DataSnapshot] {
                let object = item.value as? [String: AnyObject]
                self.identifiers.append((object?["id"] as? String)!)
                self.restaurants.append((object?["restaurant"] as? String)!)
            }
        })


        
        // 1
        Auth.auth().addStateDidChangeListener() { auth, user in
            // 2
            if user != nil {
                // 3
                self.performSegue(withIdentifier: self.loginToList, sender: nil)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "restaurantSegue" {
            if let toViewController = segue.destination as? RestaurantOrderTableViewController {
                toViewController.restaurant = self.restaurant
            }
        }
    }
  
}

extension LoginViewController: UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == textFieldLoginEmail {
      textFieldLoginPassword.becomeFirstResponder()
    }
    if textField == textFieldLoginPassword {
      textField.resignFirstResponder()
    }
    return true
  }
    

    func restaurantLoginDidTouch(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Restaurant Login",
                                      message: "Please enter your PolarEats identification #",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Login",
                                       style: .default) { action in
                                        // 1
                                        let id = alert.textFields![0]
                                        
                                        if (self.identifiers.contains(id.text!)) {
                                            self.restaurant = self.restaurants[self.identifiers.index(of: id.text!)!]
                                            self.performSegue(withIdentifier: "restaurantSegue", sender: nil)
                                        }
                                        
        }
        
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alert.addTextField { id in
            id.placeholder = "Identification Number"
        }
        
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        
        present(alert, animated: true, completion: nil)
    }

  
}
