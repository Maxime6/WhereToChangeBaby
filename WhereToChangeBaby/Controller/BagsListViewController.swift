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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let nib = UINib.init(nibName: "CustomCollectionViewCell", bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: "bagCell")

    }


}

extension BagsListViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bagCell", for: indexPath) as? CustomCollectionViewCell else { return UICollectionViewCell() }
        return cell
    }
}


extension BagsListViewController: UICollectionViewDelegate {
    
}
