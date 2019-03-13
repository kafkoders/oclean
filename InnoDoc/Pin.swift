//
//  Pin.swift
//  InnoDoc
//
//  Created by Carlos on 11/03/2019.
//  Copyright © 2019 Carlos. All rights reserved.
//

import UIKit
import MapKit

class Pin: NSObject, MKAnnotation {
    var id: Int
    var user: String
    var question: String
    var answer: String
    var coordinate: CLLocationCoordinate2D
    
    init(id: Int, username: String, question: String, answer: String, coordinate: CLLocationCoordinate2D) {
        self.id = id
        self.user = username
        self.answer = answer
        self.question = question
        self.coordinate = coordinate
    }
}
