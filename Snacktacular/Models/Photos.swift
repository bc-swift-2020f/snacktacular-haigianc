//
//  Photos.swift
//  Snacktacular
//
//  Created by Claudine Haigian on 11/18/20.
//  Copyright © 2020 Claudine Haigian. All rights reserved.
//

import Foundation
import Firebase

class Photos {
    var photoArray: [Photo] = []
    var db: Firestore!
    
    init (){
        db = Firestore.firestore()
    }
    
    func loadData(spot: Spot, completed: @escaping () -> ()){
        guard spot.documentID != "" else {
            return
        }
        db.collection("spots").document(spot.documentID).collection("photos").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else{
                print("😡 ERROR: adding the snapshot listener \(error!.localizedDescription)")
                return completed()
            }
            self.photoArray = [] //clean out existing photoArray since new data will load
            //there are querySnapshot!.documents.count documents in the spots snapshot
            for document in querySnapshot!.documents{
                //youll have to be sure youve created a dictionary intializer in the singular class (Spot, below) that accpets a dictionary
                let photo = Photo(dictionary: document.data())
                photo.documentID = document.documentID
                self.photoArray.append(photo)
            }
            completed()
        }
    }
    
}
