//
//  SpotPhotoCollectionViewCell.swift
//  Snacktacular
//
//  Created by Claudine Haigian on 11/18/20.
//  Copyright © 2020 Claudine Haigian. All rights reserved.
//

import UIKit
import SDWebImage

class SpotPhotoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var photoImageView: UIImageView!
    
    var spot: Spot!
    var photo: Photo!{
        didSet{
            if let url = URL(string: self.photo.photoURL){
                self.photoImageView.sd_imageTransition = .fade
                self.photoImageView.sd_imageTransition?.duration = 0.2
                self.photoImageView.sd_setImage(with: url)
            } else {
                print("URL didn't work \(self.photo.photoURL)")
                self.photo.loadImage(spot: self.spot) { (success) in
                    self.photo.saveData(spot: self.spot) { (success) in
                        print("Image updated with URL \(self.photo.photoURL)")
                    }
                }
            }
        }
    }
}
