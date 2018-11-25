//
//  MeVC.swift
//  breakpoint
//
//  Created by Mac on 11/1/18.
//  Copyright © 2018 CO.KrystynaKruchcovska. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import GoogleSignIn

let MAXIMUM_PHOTO_SIZE:Int64 = 1024*1024*10

class MeVC: UIViewController {
    
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handlerSelectProfileImgView)))
        profileImg.isUserInteractionEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.emailLbl.text = Auth.auth().currentUser?.email
        
        if Auth.auth().currentUser?.photoURL != nil {
            showSpinner()
        }else{
            hideSpinner()
        }
        
        setUpProfilePhoto()
    }
    
    func setUpProfilePhoto() {
        
        if Auth.auth().currentUser != nil {
            
            ImageService.instance.getImage(ForUserID: (Auth.auth().currentUser?.uid)!) { (image) in
                if let image = image {
                    
                    self.profileImg.image = image
                }
                
                self.hideSpinner()
            }
            
        }
    }
    
    func showSpinner() {
        spinner.isHidden = false
        spinner.startAnimating()
    }
    
    func hideSpinner() {
        self.spinner.isHidden = true
        self.spinner.stopAnimating()
    }
    
    
    @IBAction func signOutBtnWasPressed(_ sender: Any) {
        
        let logOutPopUp = UIAlertController(title: "Logout?", message: "Are you sure you want to log out? ", preferredStyle: .actionSheet)
        let logoutAction = UIAlertAction(title: "Logout?", style: .destructive) { (buttonTapped) in
            
            if (self.isSignedInWithGoogle()) {
                self.signOutFromGoogle()
            } else {
                self.signOutFromAuth()
            }
            
        }
        
        logOutPopUp.addAction(logoutAction)
        present(logOutPopUp, animated: true, completion: nil)
    }
    
    func showUserLogoutUI() {
        let authVC = self.storyboard?.instantiateViewController(withIdentifier: "AuthVC") as? AuthVC
        self.profileImg.image = UIImage(named: "defaultProfileImage")
        self.present(authVC!, animated: true, completion: nil)
    }
    
    func signOutFromGoogle() {
        GIDSignIn.sharedInstance().signOut()
    }
    
    func signOutFromAuth() {
        do {
            try Auth.auth().signOut()
            self.showUserLogoutUI()
        } catch {
            
        }
    }
    
    func isSignedInWithGoogle() -> Bool {
        guard let _ = GIDSignIn.sharedInstance()?.currentUser else {
            return false
        }
        
        return true
    }
    
    
}
