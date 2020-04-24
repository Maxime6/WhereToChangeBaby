//
//  PlaceDetailsControllerViewController.swift
//  WhereToChangeBaby
//
//  Created by Maxime on 19/04/2020.
//  Copyright © 2020 MaximeTanter. All rights reserved.
//

import UIKit

class PlaceDetailsControllerViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak private var placeNameLabel: UILabel!
    @IBOutlet weak private var placeAddressLabel: UILabel!
    @IBOutlet weak private var zoneLabel: UILabel!
    @IBOutlet weak private var cleanlinessLabel: UILabel!
    @IBOutlet weak private var changingTableLabel: UILabel!
    @IBOutlet weak private var mattressLabel: UILabel!
    @IBOutlet weak private var mattressProtectionLabel: UILabel!
    @IBOutlet weak private var babyDiapersLabel: UILabel!
    @IBOutlet weak private var wipesLabel: UILabel!
    @IBOutlet weak private var childrensToiletLabel: UILabel!
    
    // MARK: - Properties
    
    var place: Place?
    
    // MARK: - View Lyfe Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpPlaceInfos()
    }
    
    // MARK: - Actions
    
    @IBAction func backBarButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Class Methods
    
    private func setUpPlaceInfos() {
        placeNameLabel.text = place?.name
        placeAddressLabel.text = place?.address
        zoneLabel.text = place?.zone.rawValue
        cleanlinessLabel.text = place?.cleanliness.description
        setUpChangingTableInfo()
        setUpMattressInfo()
        setUpMattressProtectionInfo()
        setUpBabyDiapersInfo()
        setUpWipesInfo()
        setUpChildrensToiletInfo()
        
    }
    
    private func setUpChangingTableInfo() {
        if place?.accessories.changingTable == true {
            changingTableLabel.textColor = UIColor(displayP3Red: 175/255, green: 82/255, blue: 222/255, alpha: 1.0)
            changingTableLabel.text = "Oui"
        } else {
            changingTableLabel.text = "Non"
        }
    }
    
    private func setUpMattressInfo() {
        if place?.accessories.mattress == true {
            mattressLabel.textColor = UIColor(displayP3Red: 175/255, green: 82/255, blue: 222/255, alpha: 1.0)
            mattressLabel.text = "Oui"
        } else {
            mattressLabel.text = "Non"
        }
    }
    
    private func setUpMattressProtectionInfo() {
        if place?.accessories.mattressProtection == true {
            mattressProtectionLabel.textColor = UIColor(displayP3Red: 175/255, green: 82/255, blue: 222/255, alpha: 1.0)
            mattressProtectionLabel.text = "Oui"
        } else {
            mattressProtectionLabel.text = "Non"
        }
    }
    
    private func setUpBabyDiapersInfo() {
        if place?.accessories.babyDiapers == true {
            babyDiapersLabel.textColor = UIColor(displayP3Red: 175/255, green: 82/255, blue: 222/255, alpha: 1.0)
            babyDiapersLabel.text = "Oui"
        } else {
            babyDiapersLabel.text = "Non"
        }
    }
    
    private func setUpWipesInfo() {
        if place?.accessories.wipes == true {
            wipesLabel.textColor = UIColor(displayP3Red: 175/255, green: 82/255, blue: 222/255, alpha: 1.0)
            wipesLabel.text = "Oui"
        } else {
            wipesLabel.text = "Non"
        }
    }
    
    private func setUpChildrensToiletInfo() {
        if place?.accessories.childrensToilet == true {
            childrensToiletLabel.textColor = UIColor(displayP3Red: 175/255, green: 82/255, blue: 222/255, alpha: 1.0)
            childrensToiletLabel.text = "Oui"
        } else {
            childrensToiletLabel.text = "Non"
        }
    }

}
