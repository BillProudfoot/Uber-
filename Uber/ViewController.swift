//
//  ViewController.swift
//  Uber
//
//  Created by Bill Proudfoot on 17/12/2017.
//  Copyright © 2017 Bill Proudfoot. All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var riderDriverSwitch: UISwitch!
    @IBOutlet weak var driverLabel: UILabel!
    @IBOutlet weak var riderLabel: UILabel!
    @IBOutlet weak var topButton: UIButton!
    @IBOutlet weak var bottomButton: UIButton!
    
    var signUpMode = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

   

    @IBAction func topTapped(_ sender: Any) {
        
        if emailTextField.text == "" || passwordTextField.text == "" {
            displayAlert(title: "Missing Information", message: "You must provide both an email and password")
            
        } else {
            
            if let email = emailTextField.text {
                if let password = passwordTextField.text {
            
            if signUpMode {
                // SIGN UP
                
                Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                    if error != nil {
                        self.displayAlert(title: "Error", message: error!.localizedDescription)
                    } else {
                        
                        if self .riderDriverSwitch.isOn {
                            //DRIVER
                            let req = Auth.auth().currentUser?.createProfileChangeRequest()
                            req?.displayName = "Driver"
                            req?.commitChanges(completion: nil)
                            self.performSegue(withIdentifier: "driverSegue", sender: nil)
                        } else {
                            //RIDER
                            let req = Auth.auth().currentUser?.createProfileChangeRequest()
                            req?.displayName = "Rider"
                            req?.commitChanges(completion: nil)
                            self.performSegue(withIdentifier: "riderSegue", sender: nil)
                        }
                    }
                })
            } else {
                // LOG IN
                
                Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                    if error != nil {
                        self.displayAlert(title: "Error", message: error!.localizedDescription)
                    } else {
                        if user?.displayName == "Driver" {
                            //DRIVER
                             self.performSegue(withIdentifier: "driverSegue", sender: nil)
                        } else {
                            //RIDER
                             self.performSegue(withIdentifier: "riderSegue", sender: nil)
                        }
                        
                            }
                        })
                    }
                }
            }
        }
    }
    
    func displayAlert(title:String, message:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func bottomTapped(_ sender: Any) {
        
        if signUpMode {
            
            topButton.setTitle("Log In", for: .normal)
            bottomButton.setTitle("Switch to Sign Up", for: .normal)
            riderLabel.isHidden = true
            driverLabel.isHidden = true
            riderDriverSwitch.isHidden = true
            signUpMode = false
            
        } else {
            
            topButton.setTitle("Sign Up", for: .normal)
            bottomButton.setTitle("Switch to Log In", for: .normal)
            riderLabel.isHidden = false
            driverLabel.isHidden = false
            riderDriverSwitch.isHidden = false
            signUpMode = true
        }
    }
}

