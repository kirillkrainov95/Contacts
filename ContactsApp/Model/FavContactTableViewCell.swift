//
//  FavContactTableViewCell.swift
//  ContactsApp
//
//  Created by Kirill Kraynov on 9/26/21.
//

import UIKit
import RealmSwift

// MARK: - Кастомная ячейка избранного

class FavContactTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var favNameSurnameLabel: UILabel!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    var cellItemNumber: Int = Int()

    
    let model = Model()
    
    var data: Item? {
        didSet {
            guard let favoriteData = data else {
                return
            }
            favNameSurnameLabel.text = "\(favoriteData.surname ?? "(не указано)"), \(favoriteData.name ?? "(не указано)")"
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
