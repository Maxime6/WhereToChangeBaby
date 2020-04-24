//
//  BagsListViewController.swift
//  WhereToChangeBaby
//
//  Created by Maxime on 13/12/2019.
//  Copyright © 2019 MaximeTanter. All rights reserved.
//

import UIKit

class BagsListViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak private var collectionView: UICollectionView!
    @IBOutlet weak private var createNewBagButton: UIButton!
    @IBOutlet weak private var trashButton: UIBarButtonItem!
    
    // MARK: - Properties
    private var bagList = Bag.fetchAll()
    var bagData: Bag?
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = editButtonItem
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let nib = UINib.init(nibName: "CustomCollectionViewCell", bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: "bagCell")

        createNewBagButtonSettings()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bagList = Bag.fetchAll()
        collectionView.reloadData()
    }
    
    // MARK: - Actions
    
    @IBAction private func trashButtonTapped(_ sender: Any) {
        if let selectedCells = collectionView.indexPathsForSelectedItems {
            let items = selectedCells.map { $0.item }.sorted().reversed()
            for item in items {
                guard let name = bagList[item].name else { return }
                bagList.remove(at: item)
                Bag.deleteEntity(name: name)
            }
            collectionView.deleteItems(at: selectedCells)
            trashButton.isEnabled = false
        }
    }
    
    // MARK: - Class Methods
    
    private func createNewBagButtonSettings() {
        createNewBagButton.layer.borderWidth = 2.0
        createNewBagButton.layer.cornerRadius = 18.0
        createNewBagButton.layer.borderColor = CGColor(srgbRed: 175/255, green: 82/255, blue: 222/255, alpha: 1.0)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "bagListToBag" {
            let bagVC = segue.destination as! BagViewController
            bagVC.bagData = bagData
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        collectionView.allowsMultipleSelection = editing
        let indexPaths = collectionView.indexPathsForVisibleItems
        for indexPath in indexPaths {
            let cell = collectionView.cellForItem(at: indexPath) as? CustomCollectionViewCell
            cell?.isEditingMode = editing
        }
    }



}

// MARK: - Extensions

extension BagsListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if bagList.count == 0 {
            let rect = CGRect(x: 0, y: 0, width: self.collectionView.bounds.width, height: self.collectionView.bounds.height)
            let label = UILabel(frame: rect)
            label.text = "Pas de sacs enregistrés."
            label.textAlignment = .center
            label.textColor = .gray
            collectionView.backgroundView = label
            return 0
        } else {
            self.collectionView.backgroundView = nil
            return bagList.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bagCell", for: indexPath) as? CustomCollectionViewCell else { return UICollectionViewCell() }
        cell.bag = bagList[indexPath.row]
        cell.isEditingMode = isEditing
        return cell
    }
}


extension BagsListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !isEditing {
            trashButton.isEnabled = false
            bagData = bagList[indexPath.row]
            self.performSegue(withIdentifier: "bagListToBag", sender: self)
        } else {
            trashButton.isEnabled = true
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let selectedItems = collectionView.indexPathsForSelectedItems, selectedItems.count == 0  {
            trashButton.isEnabled = false
        }
    }
    
}

extension BagsListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let side = (view.frame.width - 60) / 2
        return CGSize(width: side, height: side)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
}
