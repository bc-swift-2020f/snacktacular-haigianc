//
//  Spots.swift
//  Snacktacular
//
//  Created by Claudine Haigian on 11/2/20.
//  Copyright © 2020 Claudine Haigian. All rights reserved.
//

import Foundation
import Firebase

class Spots{
    var spotArray: [Spot] = []
    var db: Firestore!
    
    init(){
        db = Firestore.firestore()
    }
    
    func loadData(completed: @escaping () -> ()){
        db.collection("spots").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else{
                print("😡 ERROR: adding the snapshot listener \(error!.localizedDescription)")
                return completed()
            }
            self.spotArray = [] //clean out existing spotArray since new data will load
            //there are querySnapshot!.documents.count documents in the spots snapshot
            for document in querySnapshot!.documents{
                //youll have to be sure youve created a dictionary intializer in the singular class (Spot, below) that accpets a dictionary
                let spot = Spot(dictionary: document.data())
                spot.documentID = document.documentID
                self.spotArray.append(spot)
            }
            completed()
        }
    }
}
