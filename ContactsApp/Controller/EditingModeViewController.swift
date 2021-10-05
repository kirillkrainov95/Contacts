//
//  AddContactViewController.swift
//  ContactsApp
//
//  Created by Kirill Kraynov on 9/26/21.
//

import UIKit
import RealmSwift

// MARK: - Редактирование/добавление
class EditingModeViewController: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(operationName)
        
        operationNameLabel.text = operationName
        
        phoneNumberTextField.keyboardType = .numberPad
        phoneNumberTextField.delegate = self
        
        if editingModeIsOn == true && fromFavs == true {
            nameTextField.text = model.favoriteContacts?[sharedIndex].name
            surnameTextField.text = model.favoriteContacts?[sharedIndex].surname
            birthDateTextField.text = model.favoriteContacts?[sharedIndex].birthDate
            emailTextField.text = model.favoriteContacts?[sharedIndex].email
            companyTextField.text = model.favoriteContacts?[sharedIndex].company
            phoneNumberTextField.text = model.favoriteContacts?[sharedIndex].phoneNumber
            
        } else if editingModeIsOn == true && fromFavs == false {
            nameTextField.text = model.testContacts?[sharedIndex].name
            surnameTextField.text = model.testContacts?[sharedIndex].surname
            birthDateTextField.text = model.testContacts?[sharedIndex].birthDate
            emailTextField.text = model.testContacts?[sharedIndex].email
            companyTextField.text = model.testContacts?[sharedIndex].company
            phoneNumberTextField.text = model.testContacts?[sharedIndex].phoneNumber
        }
            
        if editingModeIsOn == false {
            nameTextField.text = ""
            surnameTextField.text = ""
            birthDateTextField.text = ""
            emailTextField.text = ""
            companyTextField.text = ""
            phoneNumberTextField.text = ""
        }

    }
    
    // MARK: - Аутлеты
    @IBOutlet weak var operationNameLabel: UILabel!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var surnameTextField: UITextField!
    
    @IBOutlet weak var birthDateTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var companyTextField: UITextField!
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    // MARK: - Экшены
    
    @IBAction func emailTextFieldInput(_ sender: UITextField) {
        let text = emailTextField.text ?? ""

        
        if text.isValidEmail() {
            emailTextField.textColor = UIColor.black
        } else {
            emailTextField.textColor = .red
        }
        
        print(text.count)
    }
    
    
    // MARK: - Локальные переменные и константы
    var operationName: String = ""
    var sharedIndex: Int = Int()
    var fromFavs: Bool = false
    var editingModeIsOn: Bool = false
    let model = Model()

    
    // MARK: - Navigation
    
    // Сохранить и выйти
    @IBAction func doneButtonPressed(_ sender: Any) {
        
        // MARK: - ВАЖНО!
        if editingModeIsOn == false {
            //idHelper = (model.testContacts?.count ?? 0) + 1
            model.addNewContact(nameString: nameTextField.text ?? "", surnameString: surnameTextField.text ?? "", phoneNumString: phoneNumberTextField.text ?? "", emailString: emailTextField.text ?? "", companyString: companyTextField.text ?? "", birthDateString: birthDateTextField.text ?? "")
            
            performSegue(withIdentifier: "unwindBackWithSegue", sender: self)
        }
        
        if editingModeIsOn == true {
            model.updateContact(at: sharedIndex,
                            nameString: nameTextField.text ?? "",
                            surnameString: surnameTextField.text ?? "",
                            phoneNumString: phoneNumberTextField.text ?? "",
                            emailString: emailTextField.text ?? "",
                            companyString: companyTextField.text ?? "",
                            birthDateString: birthDateTextField.text ?? "")
    
        performSegue(withIdentifier: "unwindBackWithSegue", sender: self)
        }
    }
    // Кнопка отмены
    @IBAction func cancelButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "unwindBackWithSegue", sender: self)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == phoneNumberTextField {
            let fullString = (textField.text ?? "") + string
            textField.text = model.format(phoneNumber: fullString, shouldRemoveLastDigit: range.length == 1)
        }
        return false
    }
    
    //MARK: - Алерт
    


}


extension String {
    //MARK: -  Валидация почты
    func isValidEmail() -> Bool {
        let inputRegEx = "[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[A-Za-z]{2,64}"
        let inputpred = NSPredicate(format: "SELF MATCHES %@", inputRegEx)
        return inputpred.evaluate(with:self)
    }
}
