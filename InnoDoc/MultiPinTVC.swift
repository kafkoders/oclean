//
//  MultiPinTVC.swift
//  InnoDoc
//
//  Created by Carlos on 19/03/2019.
//  Copyright © 2019 Carlos. All rights reserved.
//

import UIKit
import KUIPopOver

class MultiPinTVC: UITableViewController, KUIPopOverUsable {
    var pinData:[Pin]!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private lazy var size: CGSize = {
        let realSize = Double(pinData.count * 44) + 30
        self.tableView.isScrollEnabled = realSize > 250
        
        return CGSize(width: 270.0, height: (realSize > 250) ? 250.0 : realSize)
    }()
    
    var contentSize: CGSize {
        return size
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pinData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "questionTableID", for: indexPath)
        cell.textLabel?.text = pinData[indexPath.row].question
        cell.detailTextLabel?.text = pinData[indexPath.row].answer

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let pinDetailVC = storyboard.instantiateViewController(withIdentifier: "pinDetailView") as? PinDetailViewController {
            pinDetailVC.pin = pinData[indexPath.row]
            
            pinDetailVC.showPopoverWithNavigationController(sourceView: view, shouldDismissOnTap: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

}
