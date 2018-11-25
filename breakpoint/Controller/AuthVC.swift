//
//  AuthVC.swift
//  breakpoint
//
//  Created by Mac on 10/31/18.
//  Copyright © 2018 CO.KrystynaKruchcovska. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKLoginKit

class AuthVC: UIViewController,GIDSignInUIDelegate, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var facebookBtn: FBSDKLoginButton!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        //facebookBtn.delegate = self
        //facebookBtn.readPermissions = ["public_profile", "email"]
        GIDSignIn.sharedInstance().uiDelegate = self
        //GIDSignIn.sharedInstance().signIn()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if Auth.auth().currentUser != nil{
            dismiss(animated: true, completion: nil)
        }
    }

    @IBAction func emailSignInWasPressed(_ sender: Any) {
        let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginVC")
        present(loginVC!, animated: true, completion: nil)
    }
    
    @IBAction func googleSignInWasPressed(_ sender: GIDSignInButton) {
        GIDSignIn.sharedInstance().signIn()
    
    }
    
 
    @IBAction func facebookSignInWasPressed(_ sender: FBSDKLoginButton) {
        
    }
    
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil{
            print(error)
            return
        }
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "/me", parameters: ["fields" : "id, email, name"])
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            if ((error) != nil) {
                FBSDKLoginManager().logOut()
            } else {
                if let idfb : NSString = (result! as AnyObject).value(forKey: "id") as? NSString {
                    print("ID FROM FACEBOOK: \(idfb)")
                }
                if let name : NSString = (result! as AnyObject).value(forKey: "name") as? NSString {
                    print("NAME IN FACEBOOK: \(name)")
                }
                if let email : NSString = (result! as AnyObject).value(forKey: "email") as? NSString {
                    print("EMAIL IN FACEBOOK: \(email)")
                }
            }
        })
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did log out of facebook")
    }
    

}




