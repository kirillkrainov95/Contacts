//
//  ViewController.swift
//  ContactsApp
//
//  Created by Kirill Kraynov on 9/17/21.
//

import UIKit
import RealmSwift

// MARK: - Основной список
class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    // MARK: - UITableViewDelegate & UITableViewDataSource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.helper?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = mainListTableView.dequeueReusableCell(withIdentifier: "ContactPreviewCell", for: indexPath) as? ContactTableViewCell,
              let item = model.helper?[indexPath.row] else {
              
            return UITableViewCell()
        }
        
        cell.data = item
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let destViewController = storyboard?.instantiateViewController(withIdentifier: "StDetailViewController") as? DetailViewController else {
            return
        }
        destViewController.receivedIndex = indexPath.row
        navigationController?.pushViewController(destViewController, animated: true)
        mainListTableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Searchbar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        model.search(searchTextValue: searchText)
        
        if searchBar.text?.count == 0 {
            model.helper = model.testContacts
        }
        mainListTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        model.helper = model.testContacts
        if searchBar.text?.count == 0 {
            model.helper = model.testContacts
        }
        mainListTableView.reloadData()
    }
    
    // MARK: - Variables
    var model = Model()
    var searchController = UISearchController()

    // MARK: - Outlets and Actions
    
    @IBOutlet weak var mainListTableView: UITableView!
    
    
    
    @IBAction func addContactButtonPressed(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func favoriteContactsButtonPressed(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func unwindToCurrentController(segue: UIStoryboardSegue) {
        mainListTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        model.helper = model.testContacts
 
        print(model.realm?.configuration.fileURL)
        
        mainListTableView.delegate = self
        mainListTableView.dataSource = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Введите имя или фамилию..."
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        let xibCell = UINib(nibName: "ContactTableViewCell", bundle: nil)
        
        mainListTableView.register(xibCell, forCellReuseIdentifier: "ContactPreviewCell")
        
        mainListTableView.reloadData()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        mainListTableView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showAddingScreen" {
            
            guard let destViewController = segue.destination as? EditingModeViewController else {
                return
            }
            
            destViewController.operationName = "Добавить контакт"
        }

    }
}

