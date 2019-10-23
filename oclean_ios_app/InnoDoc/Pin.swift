//
//  Pin.swift
//  InnoDoc
//
//  Created by Carlos on 11/03/2019.
//  Copyright © 2019 Carlos. All rights reserved.
//

import UIKit
import MapKit

private let clusterID = "clusterIdentifier"

class Pin: NSObject, MKAnnotation {
    var id: String
    var fillingPercentage: Int
    var coordinate: CLLocationCoordinate2D
    
    init(id: String, fillingPercentage: Int, coordinate: CLLocationCoordinate2D) {
        self.id = id
        self.fillingPercentage = fillingPercentage
        self.coordinate = coordinate
    }
}

class PinAnnotationView: MKMarkerAnnotationView {
    init(annotation: MKAnnotation?, reuseIdentifier: String?, status: Bool) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        clusteringIdentifier = "pinClID"
        
        if status {
            markerTintColor = .red
        } else {
            markerTintColor = .green
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        displayPriority = .defaultLow
        
        //markerTintColor = UIColor.red
    }
}

class ClusterPinView: MKMarkerAnnotationView {
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        collisionMode = .circle
        centerOffset = CGPoint(x: 0, y: -10) // Offset center point to animate better with marker annotations
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        
        if let cluster = annotation as? MKClusterAnnotation {
            let wholePins = cluster.memberAnnotations
            
            if wholePins.count > 0 {
                displayPriority = .defaultHigh
            } else {
                displayPriority = .defaultLow
            }
        }
    }
}
