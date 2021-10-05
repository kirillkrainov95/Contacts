//
//  Item.swift
//  ContactsApp
//
//  Created by Kirill Kraynov on 9/26/21.
//

import Foundation
import RealmSwift

// MARK: - Модель объекта для Realm

class Item: Object {

    @objc dynamic var name: String? = "John"
    @objc dynamic var surname: String? = "Appleseed"
    @objc dynamic var phoneNumber: String? = "+1(444)678-90-45"
    @objc dynamic var email: String? = "johnappleseed@apple.com"
    @objc dynamic var birthDate: String? = "14.09.1985"
    @objc dynamic var company: String? = "Apple Inc."
    @objc dynamic var isLiked: Bool = false
    
    override class func primaryKey() -> String? {
        return "name"
    }
}
