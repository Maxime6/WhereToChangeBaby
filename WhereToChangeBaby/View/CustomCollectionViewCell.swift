//
//  CustomCollectionViewCell.swift
//  WhereToChangeBaby
//
//  Created by Maxime on 13/12/2019.
//  Copyright © 2019 MaximeTanter. All rights reserved.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var bagNameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUpCustomView()
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setUpCustomView() {
        cellView.layer.cornerRadius = 20
        cellView.layer.shadowColor = UIColor(ciColor: .black).cgColor
        cellView.layer.shadowOpacity = 0.3
        cellView.layer.shadowRadius = 3
        cellView.layer.shadowOffset = CGSize(width: 3, height: 3)

    }
    
    var bag: Bag? {
        didSet {
            bagNameLabel.text = bag?.name
        }
    }
    
}
