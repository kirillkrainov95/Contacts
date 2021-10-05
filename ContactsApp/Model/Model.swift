//
//  Model.swift
//  ContactsApp
//
//  Created by Kirill Kraynov on 9/17/21.
//

import Foundation
import UIKit
import RealmSwift

    // Модель сделана для методов при работе с БД и контроллерами
class Model {
    
    //MARK: - Переменные и константы
    
    let realm = try? Realm()
    
    // парсит таблицу из БД и является основным массивом при работе с данными
    var testContacts: Results<Item>? {
        return realm?.objects(Item.self)
    }
    // вспомогательный массив
    var helper: Results<Item>?
    
    // массив избранного
    var favoriteContacts: Results<Item>? {
        let likeFilter = NSPredicate(format: "isLiked = true")
        return testContacts?.filter(likeFilter)
    }
    
    // MARK: - Вспомогательные
    let heartPic = UIImage(systemName: "heart")
    let filledHeartPic = UIImage(systemName: "heart.fill")
    var sortAscending: Bool = true
    
    // MARK: - Методы

    
    // MARK: - Добавить контакт
    func addNewContact (
                        nameString: String,
                        surnameString: String,
                        phoneNumString: String,
                        emailString: String,
                        companyString: String,
                        birthDateString: String
                                                ) {
        
        
        
        
        
        
        let newObject = Item()
        //newObject.id = testContacts?.count ?? 0 //gatherIDs() //(testContacts?.count ?? 0) + 1
        newObject.name = nameString
        newObject.surname = surnameString
        newObject.phoneNumber = phoneNumString
        newObject.email = emailString
        newObject.company = companyString
        newObject.birthDate = birthDateString

        try? realm?.write {
            realm?.add(newObject)
        }
    }
    
    // MARK: - Редактировать контакт
    func updateContact(at index: Int,
                       nameString: String,
                       surnameString: String,
                       phoneNumString: String,
                       emailString: String,
                       companyString: String,
                       birthDateString: String) {
        do {
            try realm?.write {
                testContacts?[index].name = nameString
                testContacts?[index].surname = surnameString
                testContacts?[index].phoneNumber = phoneNumString
                testContacts?[index].email = emailString
                testContacts?[index].company = companyString
                testContacts?[index].birthDate = birthDateString
            }
        } catch {
            print("\(error)")
        }
    }
    
   
    
    // MARK: - Удалить контакт
    func deleteContact(at index: Int) {
        if let contact = testContacts?[index] {
            do {
                try realm?.write {
                    realm?.delete(contact)
                }
            } catch {
                print("\(error)")
            }
        }
    }
    
    // MARK: - Поиск
    func search(searchTextValue: String) {
        
        let predicates = ["name", "surname", "phoneNumber", "email", "company", "birthDate"].map { property in
          NSPredicate(format: "%K CONTAINS [c]%@", property, searchTextValue)
        }
        let predicate = NSCompoundPredicate(orPredicateWithSubpredicates: predicates)

        helper = testContacts?.filter(predicate)

    }
    
    // MARK: - Добавить в избранное
    func clickOnFavorite(at item: Int) {
        if let contact = testContacts?[item] {
            // блок do/catch
            do {
                // запись в объект по "индексу" item
                try realm?.write {
                    // переворачиваем первоначальное значение лайка
                    contact.isLiked = !(contact.isLiked)
                }
            } catch {
                // обрабатываем ошибки
                print("Error saving done status, \(error)")
            }
        }
    }

    
    //MARK: - Форматирование
    let maxNumberCount = 11
    let regex = try! NSRegularExpression(pattern: "[\\+\\s-\\(\\)]", options: .caseInsensitive)
    
    func format(phoneNumber: String, shouldRemoveLastDigit: Bool) -> String {
        guard !(shouldRemoveLastDigit && phoneNumber.count <= 2) else { return "+" }
        
        let range = NSString(string: phoneNumber).range(of: phoneNumber)
        var number = regex.stringByReplacingMatches(in: phoneNumber, options: [], range: range, withTemplate: "")
        
        if number.count > maxNumberCount {
            let maxIndex = number.index(number.startIndex, offsetBy: maxNumberCount)
            number = String(number[number.startIndex..<maxIndex])
        }
        
        if shouldRemoveLastDigit {
            let maxIndex = number.index(number.startIndex, offsetBy: number.count - 1)
            number = String(number[number.startIndex..<maxIndex])
        }
        
        let maxIndex = number.index(number.startIndex, offsetBy: number.count)
        let regRange = number.startIndex..<maxIndex
        
        if number.count < 7 {
            let pattern = "(\\d)(\\d{3})(\\d+)"
            number = number.replacingOccurrences(of: pattern, with: "$1 ($2) $3", options: .regularExpression, range: regRange)
        } else {
            let pattern = "(\\d)(\\d{3})(\\d{3})(\\d{2})(\\d+)"
            number = number.replacingOccurrences(of: pattern, with: "$1 ($2) $3-$4-$5", options: .regularExpression, range: regRange)
        }
        
        return "+" + number
    }
}

