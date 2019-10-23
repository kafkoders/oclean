//
//  Example4View.swift
//  Malert_Example
//
//  Created by Vitor Mesquita on 19/07/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

//import BatteryView

class PinDetailView: UIView {
    
    @IBOutlet weak var batteryView: UIView! //BatteryView!
    @IBOutlet weak var fillingPercenLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        applyLayout()
        
        self.bringSubviewToFront(self.fillingPercenLabel)
    }
    
    private func applyLayout() {
//        batteryView.lowThreshold = 70
//
//        batteryView.highLevelColor = .red
//        batteryView.lowLevelColor  = .green
    }
    
    func loadQuestion(pin: Pin?) {
        if let pin = pin {
            //batteryView.level = pin.fillingPercentage
            fillingPercenLabel.text = "\(pin.fillingPercentage)%"
        }
    }
    
    class func instantiateFromNib() -> PinDetailView {
        return Bundle.main.loadNibNamed("PinDetailView", owner: nil, options: nil)!.first as! PinDetailView
    }
}
