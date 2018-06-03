//
//  ViewController.swift
//  Showcase
//
//  Created by Admin on 27.09.16.
//  Copyright © 2016 EvilMint. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import Firebase
import SwiftKeychainWrapper

class ViewController: UIViewController {

    @IBOutlet weak var fbButton: MaterialButt!
    @IBOutlet weak var emailField: MaterialTF!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ne proverteno dlya 5s
        fbButton.titleLabel?.adjustsFontSizeToFitWidth = true
        fbButton.titleLabel?.lineBreakMode = .byClipping
        
      
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.stringForKey(KEY_UID) {
            performSegue(withIdentifier: "goToFeed", sender: nil)
            
        }
        
    }
    @IBOutlet weak var passField: MaterialTF!

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func fbButtPressed(_ sender: UIButton!) {
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("OCTO: Facebook login failed")
            } else if result?.isCancelled == true {
                print("OCTO: User canceled")
            } else {
                let accessToken = FBSDKAccessToken.current().tokenString
                print("OCTO: Success \(accessToken)")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }
    }
    
    func firebaseAuth(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("OCTO: error")
            } else {
                print("OCTO: success")
                if let user = user {
                    let userData = ["provider": credential.provider]
                   self.completeSign(id: user.uid, userData: userData)
                }
               
            }
        })
    }
    @IBAction func signinTapped(_ sender: AnyObject) {
        if let email = emailField.text, let pass = passField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: pass, completion: { (user, error) in
                if error == nil {
                    print("OCTO: Success firebase")
                    if let user = user {
                        let userData = ["provider": user.providerID]
                        self.completeSign(id: user.uid, userData: userData)
                    }
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: pass, completion: { (user, error) in
                        if error != nil {
                            print("OCTO: bad time")
                        } else {
                            if let user = user {
                            print("OCTO: good time")
                                let userData = ["provider": user.providerID]
                            self.completeSign(id: user.uid, userData: userData)
                            }
                        }
                    })
                }
            })
        }
        
        
    }
    
    
    func completeSign(id: String, userData: Dictionary<String, String>) {
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
        _ = KeychainWrapper.setString(id, forKey: KEY_UID)
        print("OCTO: Data saved")
        performSegue(withIdentifier: "goToFeed", sender: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first != nil {
            view.endEditing(true)
        }
        super.touchesBegan(touches, with: event)
    }
    
    
}

