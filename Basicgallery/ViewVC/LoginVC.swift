//
//  LoginVC.swift
//  Basicgallery
//
//  Created by avinash on 14/09/23.
//

import UIKit
import GoogleSignIn


class LoginVC: UIViewController {
    @IBOutlet weak var btnGogle: GIDSignInButton!
    
    
    let signInConfig = GIDConfiguration.init(clientID: "682651071513-lkn210rdljs4895n3p4t3o6bt3ikv6rv.apps.googleusercontent.com")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBAction func btnLogin(_ sender: Any) {
        
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] user, error in
            
            
            if let error = error {
                print("Google Sign-In Error: \(error.localizedDescription)")
                return
            }
            
            if GIDSignIn.sharedInstance.currentUser == nil {
                // Handle the case where the user is not logged in
                print("Google Sign-In: User is not logged in")
                return
            }
            
            if let user = user?.user {
                let userModel = UserModel()
                userModel.userID = user.userID
                userModel.emailAddress = user.profile?.email
                userModel.userGoogleEmail = user.profile?.email
                userModel.fullName = user.profile?.name
                userModel.userGoogleName = user.profile?.name
                userModel.givenName = user.profile?.givenName
                userModel.familyName = user.profile?.familyName
                userModel.profilePicURL = user.profile?.imageURL(withDimension: 320)
                print(userModel.emailAddress)
                print(userModel.fullName!)
                print(userModel.userGoogleName!)
                print(userModel.profilePicURL!)
                print(userModel.userGoogleEmail!)
                print(userModel.givenName!)
                print(userModel.familyName!)
                UserModel.saveToUserDefaults(userModel: userModel)
                if let galleryVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GalleryVC") as? GalleryVC {
                    galleryVC.userModel = userModel
                    self.navigationController?.pushViewController(galleryVC, animated: true)
                }
            }
        }
    }
    
}
