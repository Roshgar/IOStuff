//
//  ViewController.swift
//  EpitechEisenhower
//
//  Created by fauquette fred on 25/09/17.
//  Copyright © 2017 Epitech. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit
import FBSDKCoreKit
import Firebase
import FirebaseDatabase


class LoginViewController: UIViewController, GIDSignInUIDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var googleConnectButton: GIDSignInButton!;
    @IBOutlet weak var connectButton: UIButton!
    var refDB : DatabaseReference!;
    var appDelegate : AppDelegate!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.appDelegate = AppDelegate()
        self.refDB = Database.database().reference()
        title = "Login"
        connectButton.layer.cornerRadius = 5
        GIDSignIn.sharedInstance().uiDelegate = self
        if (Auth.auth().currentUser != nil) {
            do {
                try Auth.auth().signOut()
            }   catch let signOutError as NSError{
                    print("Error signing out : %@", signOutError)
                }
            }
    }

    
    @IBAction func facebookLogin(sender: UIButton) {
        let fbLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                return
            }
            
            if (result?.isCancelled)! {
                return
            }
            
            guard let accessToken = FBSDKAccessToken.current() else {
                print("Failed to get access token")
                return
            }
            
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            Auth.auth().signIn(with: credential, completion: { (user, error) in
                if let error = error {
                    print("Login error: \(error.localizedDescription)")
                    let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okayAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                    return
                }
                self.appDelegate.tryAddUserToDB()
                let storyboard = UIStoryboard(name : "Main", bundle : nil)
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let viewController : HomeViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                let rootViewController = appDelegate.window!.rootViewController as! UINavigationController
                rootViewController.pushViewController(viewController, animated : true)
            })
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func googleConnect(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func logInFirebase(_ sender: Any) {
        if self.emailTextField.text == "" || self.passwordTextField.text == "" {
            
            //Alert to tell the user that there was an error because they didn't fill anything in the textfields because they didn't fill anything in
            
            let alertController = UIAlertController(title: "Error", message: "Please enter an email and password.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            
            Auth.auth().signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) { (user, error) in
                
                if error == nil {
                    //Go to the HomeViewController if the login is sucessful
                    let storyboard = UIStoryboard(name : "Main", bundle : nil)
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    let viewController : HomeViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                    let rootViewController = appDelegate.window!.rootViewController as! UINavigationController
                    rootViewController.pushViewController(viewController, animated : true)
                    
                    
                } else {
                    
                    //Tells the user that there is an error and then gets firebase to tell them the error
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    
    @IBAction func prepareforUnwind(segue: UIStoryboardSegue) {
        
    }
}

