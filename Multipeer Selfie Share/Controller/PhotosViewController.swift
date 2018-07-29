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
    var medias: Results<MediaData>?
    var isAscending = false
    
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
        
        medias = RealmManager.shareInstance.readFromRealmWith(keyPath: realmTimestampKeyPath, isAscending: isAscending)
        self.collectionView.reloadData()
        self.collectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueToSetting {
            let settingsController = segue.destination as! SettingsController
            let layout = collectionView.collectionViewLayout as! CollectionViewSlantedLayout
            settingsController.collectionViewLayout = layout
        } else if segue.identifier == segueToDetails {
            let detailViewController = segue.destination as! PhotoDetailViewController
            guard let indexPath = sender as? IndexPath,
                  let medias = medias,
                  let data = medias[indexPath.row].mediaData else {return}
            detailViewController.mediaData = data
            detailViewController.detailDate = medias[indexPath.row].timestamp
        }
    }
    
    @objc private func handleBackButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func handleSettingButtonPressed() {
        performSegue(withIdentifier: segueToSetting, sender: self)
    }
    
    @objc private func handleSortButtonPressed() {
        toggleSort()
    }
    
    @objc private func handleDeleteAllButtonPressed() {
        
        SweetAlert().showAlert("Delete All Photos", subTitle: "Do you want to delete all photos in this photo album?", style: AlertStyle.success, buttonTitle:"Yes", buttonColor: UIColor.flatGreen(), otherButtonTitle:  "No", otherButtonColor: UIColor.flatGreen()) { (isOtherButton) -> Void in
            if isOtherButton == true {
                
                // CAUTION: this action deletes all photos stored in Realm
                RealmManager.shareInstance.deleteAllFromRealm()
                
                    self.collectionView.reloadData()
                    self.collectionView.collectionViewLayout.invalidateLayout()
                
                let _ = self.photoView.sweetAlert.showAlert("Deleted", subTitle: "File have been deleted", style: AlertStyle.success)
            }
            else {
                let _ = self.photoView.sweetAlert.showAlert("Cancelled", subTitle: "Action Cancelled", style: AlertStyle.error)
            }
        }
    }
    
    func toggleSort() {
        guard let mediaSorting = medias else {return}
        
        isAscending = isAscending == true ? false : true
        medias = mediaSorting.sorted(byKeyPath: realmTimestampKeyPath, ascending: isAscending)

        self.collectionView.reloadData()
        self.collectionView.collectionViewLayout.invalidateLayout()
    }
}
