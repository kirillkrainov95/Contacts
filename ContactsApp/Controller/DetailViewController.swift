//
//  DetailViewController.swift
//  ContactsApp
//
//  Created by Kirill Kraynov on 9/17/21.
//

import UIKit
import RealmSwift

// MARK: - Экран деталей
class DetailViewController: UIViewController {
    

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var surnameLabel: UILabel!
    
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var companyLabel: UILabel!
    
    @IBOutlet weak var birthDateLabel: UILabel!
    
    var alert = UIAlertController()
    let model = Model()
    var receivedIndex: Int = Int()
    var fromFavs: Bool = false
    //var localIndexPath: IndexPath = IndexPath()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
    }
    
    func loadData(){
        
        if fromFavs == true {
            nameLabel.text = model.favoriteContacts?[receivedIndex].name
            surnameLabel.text = model.favoriteContacts?[receivedIndex].surname
            phoneNumberLabel.text = model.favoriteContacts?[receivedIndex].phoneNumber
            emailLabel.text = model.favoriteContacts?[receivedIndex].email
            companyLabel.text = model.favoriteContacts?[receivedIndex].company
            birthDateLabel.text = model.favoriteContacts?[receivedIndex].birthDate
        
            if model.favoriteContacts?[receivedIndex].isLiked == true {
                likeButton.image = model.filledHeartPic
            } else {
                likeButton.image = model.heartPic
            }
        }
        
        if fromFavs == false {
            nameLabel.text = model.testContacts?[receivedIndex].name
            surnameLabel.text = model.testContacts?[receivedIndex].surname
            phoneNumberLabel.text = model.testContacts?[receivedIndex].phoneNumber
            emailLabel.text = model.testContacts?[receivedIndex].email
            companyLabel.text = model.testContacts?[receivedIndex].company
            birthDateLabel.text = model.testContacts?[receivedIndex].birthDate
        
            if model.testContacts?[receivedIndex].isLiked == true {
                likeButton.image = model.filledHeartPic
            } else {
                likeButton.image = model.heartPic
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showEditingScreen" {
            guard let destViewController = segue.destination as? EditingModeViewController else {
                return
            }
            destViewController.operationName = "Редактировать контакт"
            destViewController.sharedIndex = receivedIndex
            destViewController.fromFavs = fromFavs
            destViewController.editingModeIsOn = true
        }
    }

    @IBOutlet weak var likeButton: UIBarButtonItem!
    
    @IBAction func unwindToCurrentController(segue: UIStoryboardSegue) {
        loadData()
    }
    
    @IBAction func editingButtonPressed(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func likeButtonPressed(_ sender: UIBarButtonItem) {
        model.clickOnFavorite(at: receivedIndex)
        
        if likeButton.image == model.heartPic {
            likeButton.image = model.filledHeartPic
        } else {
            likeButton.image = model.heartPic
        }
        
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIBarButtonItem) {
        confirmContactDeleting()
    }
    
    //MARK: - Алерт
    func confirmContactDeleting() {
        
        
        alert = UIAlertController(title: "Контакт будет удален. Вы уверены?", message: nil, preferredStyle: .alert)
        
        
        let cancelAlertAction = UIAlertAction(title: "Нет", style: .cancel, handler: nil)
        
        let confirmAlertAction = UIAlertAction(title: "Да", style: .default) { (createAlert) in
            self.model.deleteContact(at: self.receivedIndex)
            self.performSegue(withIdentifier: "unwindBackToMainList", sender: self)

        }
        alert.addAction(cancelAlertAction)
        alert.addAction(confirmAlertAction)
        present(alert, animated: true, completion: nil)
        
    }
    

}
