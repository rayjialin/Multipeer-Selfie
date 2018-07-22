//
//  PhotosViewController.swift
//  Multipeer Selfie Share
//
//  Created by ruijia lin on 7/15/18.
//  Copyright © 2018 ruijia lin. All rights reserved.
//

import UIKit
import RealmSwift

import CollectionViewSlantedLayout

class PhotosViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewLayout: CollectionViewSlantedLayout!
    var photos: Results<Photo>!
    let reuseIdentifier = "photoId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController?.isNavigationBarHidden = true
        collectionViewLayout.isFirstCellExcluded = true
        collectionViewLayout.isLastCellExcluded = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        do {
            let realm = try Realm()
            photos = realm.objects(Photo.self).sorted(byKeyPath: "timestamp", ascending: false)
        } catch {
            print("failed to create realm object")
        }
        
        self.collectionView.reloadData()
        self.collectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToSetting" {
            let settingsController = segue.destination as! SettingsController
            let layout = collectionView.collectionViewLayout as! CollectionViewSlantedLayout
            settingsController.collectionViewLayout = layout
        } else if segue.identifier == "segueToDetails" {
            let detailViewController = segue.destination as! PhotoDetailViewController
            guard let indexPath = sender as? IndexPath, let data = photos[indexPath.row].photoData else {return}
            detailViewController.imageData = data
        }
    }
    
    @IBAction func handleBackButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
