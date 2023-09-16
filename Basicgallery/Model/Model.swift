//
//  Model.swift
//  Basicgallery
//
//  Created by avinash on 15/09/23.
//

import Foundation
import UIKit


let sStoreArray = "storeArray"
let sUserDefault = UserDefaults.standard

class UserModel : Codable {
    var userID: String?
    var emailAddress: String?
    var userGoogleEmail: String?
    var fullName: String?
    var userGoogleName: String?
    var givenName: String?
    var familyName: String?
    var profilePicURL: URL?
}


class RoundView:UIView{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = self.bounds.size.height/2
        self.layer.masksToBounds = true
        self.clipsToBounds = true
    }
}

extension UserModel {
    
    static func saveToUserDefaults(userModel: UserModel) {
        let userDefaults = UserDefaults.standard
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(userModel) {
            userDefaults.set(encodedData, forKey: "userModel")
            userDefaults.synchronize()
        }
    }
    
    static func loadFromUserDefaults() -> UserModel? {
            let userDefaults = UserDefaults.standard
            let decoder = JSONDecoder()
            if let userData = userDefaults.data(forKey: "userModel"),
               let userModel = try? decoder.decode(UserModel.self, from: userData) {
                return userModel
            }
            return nil
        }
}

extension UserModel{
    
    static func setStoreArrayToUD(storeList : [Articles] ){
        do{
            let storeArrayData = try JSONEncoder().encode(storeList)
            sUserDefault.setValue(storeArrayData, forKey:sStoreArray)
            sUserDefault.synchronize()
        }catch{
            print("ERROR UserDStore SET :: \(error.localizedDescription)")
        }
    }
  
    static func getStoreArrayFromUD() -> [Articles]?{
        if let storeArray = sUserDefault.value(forKey: sStoreArray) as? Data{
            do {
                let storeList : [Articles] = try JSONDecoder().decode([Articles].self, from: storeArray)
                return storeList
            }catch{
                DispatchQueue.main.async {
                    print("ERROR UserDStore GET: : \(error.localizedDescription)")
                }
                return nil
            }
        }

        return nil
    }
    
}
