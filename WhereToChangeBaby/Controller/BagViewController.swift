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
    
    private var bagList = Bag.fetchAll()
    var bagData: Bag?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bagNameLabel.text = bagData?.name
    }

}

extension BagViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bagItemCell", for: indexPath)
        return cell
    }
    
}
extension BagViewController: UITableViewDelegate {
    
}
