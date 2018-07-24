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
    
    @IBOutlet var photoView: PhotoView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewLayout: CollectionViewSlantedLayout!
    var photos: Results<Photo>!
    let reuseIdentifier = "photoId"
    var ascending = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionViewLayout.isFirstCellExcluded = true
        collectionViewLayout.isLastCellExcluded = true
        
        photoView.backButton.addTarget(self, action: #selector(handleBackButtonPressed), for: .touchUpInside)
        photoView.connectButton.addTarget(self, action: #selector(handleSettingButtonPressed), for: .touchUpInside)
        photoView.flashButton.addTarget(self, action: #selector(handleSortButtonPressed), for: .touchUpInside)
        photoView.timerButton.addTarget(self, action: #selector(handleDeleteAllButtonPressed), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        toggleSort()
        
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
            guard let indexPath = sender as? IndexPath, let data = photos[indexPath.row].photoData, let date = photos[indexPath.row].timestamp else {return}
            detailViewController.imageData = data
            detailViewController.detailDate = date
        }
    }
    
    @objc private func handleBackButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func handleSettingButtonPressed() {
        performSegue(withIdentifier: "segueToSetting", sender: self)
    }
    
    @objc private func handleSortButtonPressed() {
        toggleSort()
    }
    
    @objc private func handleDeleteAllButtonPressed() {
        
        SweetAlert().showAlert("Delete All Photos", subTitle: "Do you want to delete all photos in this photo album?", style: AlertStyle.success, buttonTitle:"Yes", buttonColor: UIColor.flatGreen(), otherButtonTitle:  "No", otherButtonColor: UIColor.flatGreen()) { (isOtherButton) -> Void in
            if isOtherButton == true {
                
                // CAUTION: this action deletes all photos stored in Realm
                self.deleteRealmFile()
                do {
                    let realm = try Realm()
                    self.photos = realm.objects(Photo.self)
                    self.collectionView.reloadData()
                    self.collectionView.collectionViewLayout.invalidateLayout()
                } catch {
                    print("failed to create realm object")
                }
                
                let _ = self.photoView.sweetAlert.showAlert("Deleted", subTitle: "Photos have been deleted", style: AlertStyle.success)
            }
            else {
                let _ = self.photoView.sweetAlert.showAlert("Cancelled", subTitle: "Action Cancelled", style: AlertStyle.error)
            }
        }
    }
    
    private func deleteRealmFile(){
        do {
            try FileManager.default.removeItem(at: Realm.Configuration.defaultConfiguration.fileURL!)
        } catch {
            print("deorr delete")
        }
    }
    
    func toggleSort() {
        do {
            let realm = try Realm()
            if ascending == true {
                photos = realm.objects(Photo.self).sorted(byKeyPath: "timestamp", ascending: false)
            ascending = false
            }else {
                photos = realm.objects(Photo.self).sorted(byKeyPath: "timestamp", ascending: true)
                ascending = true
            }
            self.collectionView.reloadData()
            self.collectionView.collectionViewLayout.invalidateLayout()
        } catch {
            print("failed to create realm object")
        }
    }
}
