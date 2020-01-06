//
//  BagsListViewController.swift
//  WhereToChangeBaby
//
//  Created by Maxime on 13/12/2019.
//  Copyright © 2019 MaximeTanter. All rights reserved.
//

import UIKit

class BagsListViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var createNewBagButton: UIButton!
    
    // Collectionview parameters
    private let sectionInsets = UIEdgeInsets(top: 30.0, left: 20.0, bottom: 20.0, right: 20.0)
    private let itemPerRow: CGFloat = 2
    
    private var bagList = Bag.fetchAll()
    var bagData: Bag?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    func createNewBagButtonSettings() {
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


}

extension BagsListViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bagList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bagCell", for: indexPath) as? CustomCollectionViewCell else { return UICollectionViewCell() }
        cell.bag = bagList[indexPath.row]
        return cell
    }
}


extension BagsListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let indexPath = collectionView.indexPathsForSelectedItems else { return }
        bagData = bagList[indexPath.count]
        self.performSegue(withIdentifier: "bagListToBag", sender: self)
    }
}

extension BagsListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemPerRow+1)
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.top
    }
    
}
