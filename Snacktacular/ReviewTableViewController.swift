//
//  ReviewTableViewController.swift
//  Snacktacular
//
//  Created by Claudine Haigian on 11/10/20.
//  Copyright © 2020 Claudine Haigian. All rights reserved.
//

import UIKit
import Firebase

private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .none
    return dateFormatter
}()

class ReviewTableViewController: UITableViewController {
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var postedByLabel: UILabel!
    @IBOutlet weak var buttonsBackgroundView: UIView!
    @IBOutlet weak var reviewTitleField: UITextField!
    @IBOutlet weak var reviewDateLabel: UILabel!
    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet var starButtonCollection: [UIButton]!
    
    var review: Review!
    var spot: Spot!
    var rating = 0 {
        didSet {
            for starButton in starButtonCollection {
                let imageName = (starButton.tag < rating ? "star.fill" : "star")
                starButton.setImage(UIImage(systemName: imageName), for: .normal)
                starButton.tintColor = (starButton.tag < rating ? .systemRed : .darkText)
            }
            print(">> new rating \(rating)")
            review.rating = rating
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard spot != nil else{
            print("ERROR: No spot passed to ReviewTableViewController.swift")
            return
        }
        if review == nil {
            review = Review()
        }
        updateUserInterface()
    }
    
    func updateUserInterface() {
        nameLabel.text = spot.name
        addressLabel.text = spot.address
        reviewTitleField.text = review.title
        reviewTextView.text = review.text
        rating = review.rating //will update rating stars on load
        reviewDateLabel.text = "posted: \(dateFormatter.string(from: review.date))"
        if review.documentID == "" { //this is a new review
            addBordersToEditableObject()
        } else {
            if review.reviewUserID == Auth.auth().currentUser?.uid{ //review posted by current user
                self.navigationItem.leftItemsSupplementBackButton = false
                saveBarButton.title = "Update"
                addBordersToEditableObject()
                deleteButton.isHidden = false
            } else { //review posted by a different user
                saveBarButton.hide()
                cancelBarButton.hide()
                postedByLabel.text = "Posted by: \(review.reviewUserEmail)"
                for starButton in starButtonCollection {
                    starButton.backgroundColor = .white
                    starButton.isEnabled = false
                }
                reviewTitleField.isEnabled = false
                reviewTitleField.borderStyle = .none
                reviewTextView.isEditable = false
                reviewTitleField.backgroundColor = .white
                reviewTextView.backgroundColor = .white
            }
        }
    }
    
    func updateFromUserInterface() {
        review.title = reviewTitleField.text!
        review.text = reviewTextView.text!
    }
    
    func addBordersToEditableObject(){
        reviewTitleField.addBorder(width: 0.5, radius: 5.0, color: .black)
        reviewTextView.addBorder(width: 0.5, radius: 5.0, color: .black)
        buttonsBackgroundView.addBorder(width: 0.5, radius: 5.0, color: .black)
    }
    
    func leaveViewController(){
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode{
            dismiss(animated: true, completion: nil)
        } else{
            navigationController?.popViewController(animated: true)
        }
    }

    @IBAction func reviewTitleChanged(_ sender: UITextField) {
    }
    
    @IBAction func reviewTitleDonePressed(_ sender: UITextField) {
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        leaveViewController()
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        updateFromUserInterface()
        review.saveData(spot: spot) { (success) in
            if success {
                self.leaveViewController()
            } else {
                print("😡 ERROR: Can't unwind segue from Review because of review saving error.")
            }
        }
    }
    
    
    @IBAction func starButtonPressed(_ sender: UIButton) {
        rating = sender.tag + 1
        
    }
    
}