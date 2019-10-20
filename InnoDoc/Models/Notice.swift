//
//  Notice.swift
//  InnoDoc
//
//  Created by Carlos Martin de Arribas on 19/10/2019.
//  Copyright © 2019 Carlos. All rights reserved.
//

import Foundation

class Notice {
    var title: String!
    var description: String!
    var publicationDate: String!
    var newspaper: String?
    var image: String?
    var url: String?
    
    public init(title: String, description: String, publicationDate: String, newspaper: String, image: String, url: String) {
        self.title             = title
        self.description       = description
        self.publicationDate   = publicationDate
        self.newspaper         = newspaper
        self.image             = image
        self.url               = url
    }
    
    public init() {}
}
