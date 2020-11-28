//
//  SnackUsers.swift
//  Snacktacular
//
//  Created by Claudine Haigian on 11/28/20.
//  Copyright © 2020 Claudine Haigian. All rights reserved.
//

import Foundation
import Firebase

class SnackUsers{
    var userArray: [SnackUser] = []
    var db: Firestore!
    
    init(){
        db = Firestore.firestore()
    }
    
    func loadData(completed: @escaping () -> ()){
        db.collection("users").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else{
                print("😡 ERROR: adding the snapshot listener \(error!.localizedDescription)")
                return completed()
            }
            self.userArray = [] //clean out existing userArray since new data will load
            //there are querySnapshot!.documents.count documents in the spots snapshot
            for document in querySnapshot!.documents{
                //youll have to be sure youve created a dictionary intializer in the singular class (Spot, below) that accpets a dictionary
                let snackUser = SnackUser(dictionary: document.data())
                snackUser.documentID = document.documentID
                self.userArray.append(snackUser)
            }
            completed()
        }
    }
}
