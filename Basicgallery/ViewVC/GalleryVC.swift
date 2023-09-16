//
//  GalleryVC.swift
//  Basicgallery
//
//  Created by avinash on 15/09/23.
//

import UIKit
import Kingfisher
import Firebase
import GoogleSignIn

class GalleryVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblemail: UILabel!
    
    @IBOutlet weak var CollectionView: UICollectionView!
    
    var articlesArray: [Articles] = []
    var userModel: UserModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        UpdateUI()
        featchdata()
    }
    
    //MARK: - API CALLING
    func featchdata(){
        if let storedArticlesArray = UserModel.getStoreArrayFromUD() {
            articlesArray = storedArticlesArray
            CollectionView.reloadData()
        } else {
            getJson() { [self] (json) in
                DispatchQueue.main.sync {
                    if let articles = json.articles {
                        for article in articles {
                            self.articlesArray.append(article)
                            print(article.urlToImage)
                        }
                        CollectionView.reloadData()

                        UserModel.setStoreArrayToUD(storeList: self.articlesArray)
                    }
                }
            }
        }
        func getJson(completion: @escaping (Json4Swift_Base)-> ()) {
            let urlString = "https://newsapi.org/v2/everything?q=tesla&from=2023-08-16&sortBy=publishedAt&apiKey=593f5a82de084c33afe3c1955d829e8d"
            if let url = URL(string: urlString) {
                URLSession.shared.dataTask(with: url) {data, res, err in
                    if let data = data {
                        do {
                            let json: Json4Swift_Base = try JSONDecoder().decode(Json4Swift_Base.self, from: data)
                            completion(json)
                        } catch let error {
                            print(error.localizedDescription)
                        }
                    }
                }.resume()
            }
        }
    }
    
    func UpdateUI(){
        self.navigationItem.setHidesBackButton(true, animated: true)
        lblemail.text = UserModel.loadFromUserDefaults()?.fullName
        lblName.text = UserModel.loadFromUserDefaults()?.emailAddress
        if let userModel = UserModel.loadFromUserDefaults(), let profilePicURL = userModel.profilePicURL {
            profileImageView.kf.setImage(with: profilePicURL)
        }
        if let layout = CollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumInteritemSpacing = 10
            layout.minimumLineSpacing = 10
        }
    }
    
    @IBAction func logOutbtn(_ sender: Any) {
        GIDSignIn.sharedInstance.signOut()
        if let navigationController = self.navigationController {
            navigationController.popViewController(animated: true)
        }
    }
    
}
//MARK: - COLLECTIONVIEW
extension GalleryVC {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articlesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCollectionViewCell", for: indexPath) as! MyCollectionViewCell
        let article = articlesArray[indexPath.row]
        if let imageUrl = URL(string: article.urlToImage ?? "") {
            cell.imgCollection.kf.setImage(with: imageUrl)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

