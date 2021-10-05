//
//  ContactTableViewCell.swift
//  ContactsApp
//
//  Created by Kirill Kraynov on 9/17/21.
//

import UIKit
import RealmSwift

// MARK: - Кастомная ячейка основого списка

class ContactTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var nameSurnameLabel: UILabel!
    
    let model = Model()
    
    var data: Item? {
        didSet {
            guard let unwrData = data else {
                return
            }
            nameSurnameLabel.text = "\(unwrData.surname ?? "(не указано)"), \(unwrData.name ?? "(не указано)")"
            
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
