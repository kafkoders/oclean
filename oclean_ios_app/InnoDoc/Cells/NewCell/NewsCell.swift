//
//  NewsCell.swift
//  oclean
//
//  Created by Carlos Martin de Arribas on 19/10/2019.
//  Copyright © 2019 Carlos. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {
    @IBOutlet weak var titleLabelV: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var newspaperLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var noticeImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
