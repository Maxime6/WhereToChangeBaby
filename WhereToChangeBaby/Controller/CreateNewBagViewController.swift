//
//  CreateNewBagViewController.swift
//  WhereToChangeBaby
//
//  Created by Maxime on 20/12/2019.
//  Copyright © 2019 MaximeTanter. All rights reserved.
//

import UIKit

class CreateNewBagViewController: UIViewController {

    @IBOutlet weak var addItemBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bagNameTextField: UITextField!
    @IBOutlet weak var createBagButton: UIButton!
    
    var itemsList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpCreateButton()
        setUpBagNameTextField()
    }
    
    func setUpCreateButton() {
        createBagButton.layer.cornerRadius = 18.0
        createBagButton.layer.borderWidth = 2
        createBagButton.layer.borderColor = CGColor(srgbRed: 175/255, green: 82/255, blue: 222/255, alpha: 1.0)
    }
    
    func setUpBagNameTextField() {
        
    }

    @IBAction func addItem(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Ajouter un élément", message: "", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Elément"
            textField.text = ""
        }
        alert.addAction(UIAlertAction(title: "Ajouter", style: .cancel, handler: { (uiAlertAction) in
            let textField = alert.textFields?[0].text
            guard let item = textField else { return }
            self.itemsList.append(item)
            self.tableView.reloadData()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        bagNameTextField.resignFirstResponder()
    }
    
}

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
}
