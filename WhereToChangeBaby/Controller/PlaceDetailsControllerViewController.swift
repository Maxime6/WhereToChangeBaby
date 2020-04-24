//
//  PlaceDetailsControllerViewController.swift
//  WhereToChangeBaby
//
//  Created by Maxime on 19/04/2020.
//  Copyright © 2020 MaximeTanter. All rights reserved.
//

import UIKit

class PlaceDetailsControllerViewController: UIViewController {

    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var placeAddressLabel: UILabel!
    @IBOutlet weak var zoneLabel: UILabel!
    @IBOutlet weak var cleanlinessLabel: UILabel!
    @IBOutlet weak var changingTableLabel: UILabel!
    @IBOutlet weak var mattressLabel: UILabel!
    @IBOutlet weak var mattressProtectionLabel: UILabel!
    @IBOutlet weak var babyDiapersLabel: UILabel!
    @IBOutlet weak var wipesLabel: UILabel!
    @IBOutlet weak var childrensToiletLabel: UILabel!
    
    var place: Place?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("palce Infos: \(place)")
        setUpPlaceInfos()
    }

    func setUpPlaceInfos() {
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
    
    func setUpChangingTableInfo() {
        if place?.accessories.changingTable == true {
            changingTableLabel.textColor = UIColor(displayP3Red: 175/255, green: 82/255, blue: 222/255, alpha: 1.0)
            changingTableLabel.text = "Oui"
        } else {
            changingTableLabel.text = "Non"
        }
    }
    
    func setUpMattressInfo() {
        if place?.accessories.mattress == true {
            mattressLabel.textColor = UIColor(displayP3Red: 175/255, green: 82/255, blue: 222/255, alpha: 1.0)
            mattressLabel.text = "Oui"
        } else {
            mattressLabel.text = "Non"
        }
    }
    
    func setUpMattressProtectionInfo() {
        if place?.accessories.mattressProtection == true {
            mattressProtectionLabel.textColor = UIColor(displayP3Red: 175/255, green: 82/255, blue: 222/255, alpha: 1.0)
            mattressProtectionLabel.text = "Oui"
        } else {
            mattressProtectionLabel.text = "Non"
        }
    }
    
    func setUpBabyDiapersInfo() {
        if place?.accessories.babyDiapers == true {
            babyDiapersLabel.textColor = UIColor(displayP3Red: 175/255, green: 82/255, blue: 222/255, alpha: 1.0)
            babyDiapersLabel.text = "Oui"
        } else {
            babyDiapersLabel.text = "Non"
        }
    }
    
    func setUpWipesInfo() {
        if place?.accessories.wipes == true {
            wipesLabel.textColor = UIColor(displayP3Red: 175/255, green: 82/255, blue: 222/255, alpha: 1.0)
            wipesLabel.text = "Oui"
        } else {
            wipesLabel.text = "Non"
        }
    }
    
    func setUpChildrensToiletInfo() {
        if place?.accessories.childrensToilet == true {
            childrensToiletLabel.textColor = UIColor(displayP3Red: 175/255, green: 82/255, blue: 222/255, alpha: 1.0)
            childrensToiletLabel.text = "Oui"
        } else {
            childrensToiletLabel.text = "Non"
        }
    }

}
