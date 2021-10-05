//
//  FavoriteContactsViewController.swift
//  ContactsApp
//
//  Created by Kirill Kraynov on 9/26/21.
//

import UIKit
import RealmSwift

//MARK: - Избранное
class FavoriteContactsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.favoriteContacts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = favoriteContactsTableView.dequeueReusableCell(withIdentifier: "FavContactPreviewCell", for: indexPath) as? FavContactTableViewCell,
              let favoriteItem = model.favoriteContacts?[indexPath.row] else {
              
            return UITableViewCell()
        }
        
        cell.data = favoriteItem
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let destViewController = storyboard?.instantiateViewController(withIdentifier: "StDetailViewController") as? DetailViewController else {
            return
        }
        // передаём id из массива контактов
        destViewController.receivedIndex = indexPath.row //model.favoriteContacts?[indexPath.row].id ?? 0
        destViewController.fromFavs = true
        navigationController?.pushViewController(destViewController, animated: true)
        favoriteContactsTableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Variables
    let model = Model()
    
    //MARK: - Outlets and actions
    
    @IBOutlet weak var favoriteContactsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        favoriteContactsTableView.dataSource = self
        favoriteContactsTableView.delegate = self
        
        //model.showFavoriteContacts()
    
        let xibCell = UINib(nibName: "FavContactTableViewCell", bundle: nil)
        
        favoriteContactsTableView.register(xibCell, forCellReuseIdentifier: "FavContactPreviewCell")
        
        favoriteContactsTableView.reloadData()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        favoriteContactsTableView.reloadData()
    }

}
