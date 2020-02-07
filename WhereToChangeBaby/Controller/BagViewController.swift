//
//  BagViewController.swift
//  WhereToChangeBaby
//
//  Created by Maxime on 05/01/2020.
//  Copyright © 2020 MaximeTanter. All rights reserved.
//

import UIKit

class BagViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bagNameLabel: UILabel!
    @IBOutlet weak var addIemBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var editBagNameButton: UIButton!
    
    private var bagList = Bag.fetchAll()
    var bagData: Bag?
    var items = [Item]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bagNameLabel.text = bagData?.name
        tableView.reloadData()
        setUpBagNameLabelParameters()
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
            Item.create(itemName: item, bag: self.bagData!)
            self.tableView.reloadData()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func editBagNameLabelButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Modifier le nom du sac", message: "", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.autocapitalizationType = .sentences
            textField.placeholder = "Nouveau nom"
            textField.text = ""
        }
        alert.addAction(UIAlertAction(title: "Modifier", style: .cancel, handler: { (uiAlertAction) in
            let textField = alert.textFields?[0].text
            guard let name = textField else { return }
            Bag.changeBagName(name: name)
            self.bagNameLabel.text = name
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func setUpBagNameLabelParameters() {
        bagNameLabel.layer.cornerRadius = 10
        bagNameLabel.layer.shadowColor = UIColor(ciColor: .black).cgColor
        bagNameLabel.layer.shadowOpacity = 0.3
        bagNameLabel.layer.shadowRadius = 3
        bagNameLabel.layer.shadowOffset = CGSize(width: 3, height: 3)
    }

}

extension BagViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let itemsList = bagData?.items?.allObjects as? [Item] else { return 0 }
        items = itemsList
        return items.count
//        return (bagData?.items!.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bagItemCell", for: indexPath)
        let itemEntities = bagData?.items?.allObjects as? [Item]
        if itemEntities == [] {
            cell.textLabel?.text = ""
        } else {
            cell.textLabel?.text = itemEntities?[indexPath.row].itemName
        }
        return cell
    }
    
}
extension BagViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if cell?.accessoryType == UITableViewCell.AccessoryType.none {
            cell?.accessoryType = .checkmark
            cell?.tintColor = UIColor(displayP3Red: 175/255, green: 82/255, blue: 222/255, alpha: 0.85)
        } else {
            cell?.accessoryType = .none
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let name = items[indexPath.row].itemName else { return }
            items.remove(at: indexPath.row)
            Item.deleteItemEntity(name: name)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        }
    }

}
