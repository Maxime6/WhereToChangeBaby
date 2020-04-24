//
//  CustomCollectionViewCell.swift
//  WhereToChangeBaby
//
//  Created by Maxime on 13/12/2019.
//  Copyright © 2019 MaximeTanter. All rights reserved.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {

    // MARK: - Outlets
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var bagNameLabel: UILabel!
    @IBOutlet weak var checkMarkImageView: UIImageView!
    
    // MARK: - View Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUpCustomView()
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: - Class Methods
    
    func setUpCustomView() {
        cellView.layer.cornerRadius = 20
        cellView.layer.shadowColor = UIColor(ciColor: .black).cgColor
        cellView.layer.shadowOpacity = 0.3
        cellView.layer.shadowRadius = 3
        cellView.layer.shadowOffset = CGSize(width: 3, height: 3)

    }
    
    // MARK: - Properties
    
    var bag: Bag? {
        didSet {
            bagNameLabel.text = bag?.name
        }
    }
    
    var isEditingMode = false {
        didSet {
            checkMarkImageView.isHidden = !isEditingMode
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if isEditingMode {
                checkMarkImageView.isHighlighted = isSelected ? true : false
            }
        }
    }
    
}
