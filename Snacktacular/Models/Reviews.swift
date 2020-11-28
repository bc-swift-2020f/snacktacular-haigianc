//
//  Reviews.swift
//  Snacktacular
//
//  Created by Claudine Haigian on 11/12/20.
//  Copyright © 2020 Claudine Haigian. All rights reserved.
//

import Foundation
import Firebase

class Reviews {
    var reviewArray: [Review] = []
    var db: Firestore!
    
    init (){
        db = Firestore.firestore()
    }
    
    func loadData(spot: Spot, completed: @escaping () -> ()){
        guard spot.documentID != "" else {
            return
        }
        db.collection("spots").document(spot.documentID).collection("reviews").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else{
                print("😡 ERROR: adding the snapshot listener \(error!.localizedDescription)")
                return completed()
            }
            self.reviewArray = [] //clean out existing spotArray since new data will load
            //there are querySnapshot!.documents.count documents in the spots snapshot
            for document in querySnapshot!.documents{
                //youll have to be sure youve created a dictionary intializer in the singular class (Spot, below) that accpets a dictionary
                let review = Review(dictionary: document.data())
                review.documentID = document.documentID
                self.reviewArray.append(review)
            }
            completed()
        }
    }
    
}
