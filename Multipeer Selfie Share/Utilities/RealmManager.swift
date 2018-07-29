//
//  RealmManager.swift
//  Multipeer Selfie Share
//
//  Created by ruijia lin on 7/28/18.
//  Copyright © 2018 ruijia lin. All rights reserved.
//

import Foundation
import RealmSwift

class RealmManager {
    
    private var realm: Realm
    
    static let shareInstance = RealmManager()
    
            let backgroundQueue = DispatchQueue(label: "com.multipeerSelfie.realm.queue",
                                                qos: .background,
                                                target: nil)
    
    private init() {
        realm = try! Realm()
    }
    
    func readFromRealm() -> Results<MediaData> {
        return realm.objects(MediaData.self)
    }
    
    func readFromRealmWith(keyPath: String, isAscending: Bool) -> Results<MediaData>{
        return realm.objects(MediaData.self).sorted(byKeyPath: keyPath, ascending: isAscending)
    }
    
    func wrtieToRealm(object: MediaData) {
            do {
                try self.realm.write {
                    self.realm.add(object)
                }
            } catch {
                print("failed to write to realm")
            }
    }
    
    func deleteAllFromRealm() {
        do {
            try realm.write {
                realm.deleteAll()
            }
        } catch {
            print("failed to delete all from realm")
        }
    }
    
    func deleteFromRealm(object: MediaData) {
        do {
            try realm.write {
                realm.delete(object)
            }
        } catch {
            print("failed to delete object from realm")
        }
    }
    
    
    
    
    //    func writeToRealm(mediaData: MediaData) {
    //        // instantiate realm object and write image data to realm object
    //        let backgroundQueue = DispatchQueue(label: "com.multipeerSelfie.realm.queue",
    //                                            qos: .background,
    //                                            target: nil)
    //
    //        backgroundQueue.async {
    //            do {
    //                let realm = try Realm()
    //                do {
    //                    try realm.write {
    //                        realm.add(mediaData)
    //                    }
    //                } catch {
    //                    print("Failed to write to Realm")
    //                }
    //            } catch {
    //                print("Failed to get default Realm")
    //            }
    //        }
    //    }
    //
    //    func readFromSortedRealm(keyPath: String, isAscending: Bool) -> Results<MediaData>?{
    //        do {
    //            let realm = try Realm()
    //            return realm.objects(MediaData.self).sorted(byKeyPath: keyPath, ascending: isAscending)
    //        } catch {
    //            print("failed to create realm object")
    //        }
    //
    //        return nil
    //    }
    //
    //    func deleteRealmFile(){
    //        do {
    //            try FileManager.default.removeItem(at: Realm.Configuration.defaultConfiguration.fileURL!)
    //        } catch {
    //            print("error in deletion")
    //        }
    //    }
}
