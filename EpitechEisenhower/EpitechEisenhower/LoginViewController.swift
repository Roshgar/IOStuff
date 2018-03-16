//
//  ViewController.swift
//  EpitechEisenhower
//
//  Created by fauquette fred on 25/09/17.
//  Copyright © 2017 Epitech. All rights reserved.
//

import UIKit
import GoogleSignIn

class LoginViewController: UIViewController, GIDSignInUIDelegate {

    @IBOutlet weak var connectButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Login"
        connectButton.layer.cornerRadius = 5
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
        let googleSignInButton = GIDSignInButton()
        googleSignInButton.center = view.center
        view.addSubview(googleSignInButton)
        // Do any additional setup after loading the view, typically from a nib.
    }

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error != nil) {
            print("Google sign in error")
        }
        else {
            self.performSegue(withIdentifier: "showHome", sender: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func connect(_ sender: Any) {
        performSegue(withIdentifier: "showHome", sender: nil)
    }
    
}
