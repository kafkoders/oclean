//
//  Example4View.swift
//  Malert_Example
//
//  Created by Vitor Mesquita on 19/07/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class PinDetailView: UIView {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        applyLayout()
    }
    
    private func applyLayout() {
        //TODO PUT AN IMAGE
        //imageView.image = UIImage.fromColor(color: UIColor(red:0.91, green:0.12, blue:0.39, alpha:1.0))

        imageView.backgroundColor = UIColor(red:0.65, green:0.11, blue:0.13, alpha:1.0)
        
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.light)
        titleLabel.text = "Question"
        titleLabel.numberOfLines = 0
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.2
        
        descriptionLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        descriptionLabel.textColor = UIColor.lightGray
        descriptionLabel.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam sit amet ante ut massa dignissim feugiat. Morbi eu faucibus diam. Nunc et nisl et tellus ultrices blandit. Proin pharetra hendrerit augue sed tempus. Aliquam vel nibh laoreet tortor euismod tempus. Integer et pharetra magna."
    }
    
    func loadQuestion(pin: Pin?) {
        if let pin = pin {
            titleLabel.text = pin.question
            descriptionLabel.text = pin.answer
        }
    }
    
    class func instantiateFromNib() -> PinDetailView {
        return Bundle.main.loadNibNamed("PinDetailView", owner: nil, options: nil)!.first as! PinDetailView
    }
}
