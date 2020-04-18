//
//  CreateNewBagViewController.swift
//  WhereToChangeBaby
//
//  Created by Maxime on 20/12/2019.
//  Copyright © 2019 MaximeTanter. All rights reserved.
//

import UIKit

class CreateNewBagViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak private var addItemBarButtonItem: UIBarButtonItem!
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var bagNameTextField: UITextField!
    @IBOutlet weak private var createBagButton: UIButton!
    
    //MARK: - Properties
    private var itemsList = [String]()
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpCreateButton()
        setUpBagNameTextField()
    }
    
    //MARK: - Class Methods
    private func setUpCreateButton() {
        createBagButton.layer.cornerRadius = 18.0
        createBagButton.layer.borderWidth = 2
        createBagButton.layer.borderColor = CGColor(srgbRed: 175/255, green: 82/255, blue: 222/255, alpha: 1.0)
    }
    
    private func setUpBagNameTextField() {
        
    }
    
    private func createBagObject() {
        let bagName = bagNameTextField.text!
        let items = itemsList
        Bag.create(name: bagName, items: items)
        print(items)
    }

    //MARK: - Actions
    @IBAction private func addItem(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Ajouter un élément", message: "", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Elément"
            textField.text = ""
        }
        alert.addAction(UIAlertAction(title: "Annuler", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Ajouter", style: .cancel, handler: { (uiAlertAction) in
            let textField = alert.textFields?[0].text
            guard let item = textField else { return }
            self.itemsList.append(item)
            self.tableView.reloadData()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction private func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        bagNameTextField.resignFirstResponder()
    }
    
    @IBAction private func createBagButtonTapped(_ sender: UIButton) {
        createBagObject()
        navigationController?.popViewController(animated: true)
    }
    
}

//MARK: - Extensions

extension CreateNewBagViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        cell.textLabel?.text = itemsList[indexPath.row]
        return cell
    }
    
}

extension CreateNewBagViewController: UITableViewDelegate {
    
}

extension CreateNewBagViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        bagNameTextField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        return updatedText.count <= 20
    }
}
