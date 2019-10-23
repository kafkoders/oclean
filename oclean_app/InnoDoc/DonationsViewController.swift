//
//  DonationsViewController.swift
//  oclean
//
//  Created by Carlos Martin de Arribas on 20/10/2019.
//  Copyright © 2019 Carlos. All rights reserved.
//

import UIKit
import MBProgressHUD

class DonationsViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        for case let button as UIButton in self.scrollView.subviews {
            //button.layer.
            button.layer.cornerRadius = button.frame.width/2
        }
    }
    
    
    @IBAction func payWithCard(_ sender: Any) {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = .indeterminate
        hud.label.text = "Contacting with bank"
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            hud.label.text = "Paying with card"
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                hud.mode = .text
                hud.label.text = "Transaction Success"
            }
        }
    }
    
    @IBAction func payWithBlockchain(_ sender: Any) {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = .indeterminate
        hud.label.text = "Making transaction"
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            hud.mode = .text
            hud.label.text = "Transaction Success"
        }
    }
    
    @IBAction func selectButton(_ sender: Any) {
        let button = sender as! UIButton
        button.backgroundColor = UIColor.blue
    }
}
