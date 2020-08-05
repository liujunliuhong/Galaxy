//
//  SwiftyMapTestViewController.swift
//  SwiftTool
//
//  Created by apple on 2020/8/5.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit
import MapKit

// dependency 'UIKit'
public class SwiftyMapTestViewController: UIViewController {

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }
}

extension SwiftyMapTestViewController {
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let coordinate = CLLocationCoordinate2D(latitude: 39.54, longitude: 115.25)
        let destinationName: String = "Test End Point"

        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let gaode = UIAlertAction(title: "Gao De", style: .default) { (_) in
            SwiftyOpenMapNavigation(type: .gaode(navigationType: .driving), destination: coordinate, destinationName: destinationName)
        }
        let baidu = UIAlertAction(title: "Bai Du", style: .default) { (_) in
            SwiftyOpenMapNavigation(type: .baidu(coordinateType: .bd09ll, navigationType: .driving), destination: coordinate, destinationName: destinationName)
        }
        let _self = UIAlertAction(title: "Self", style: .default) { (_) in
            SwiftyOpenMapNavigation(type: .`self`(directionsMode: MKLaunchOptionsDirectionsModeDriving, mapType: .standard, showsTrafficKey: true), destination: coordinate, destinationName: destinationName)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(gaode)
        alert.addAction(baidu)
        alert.addAction(_self)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
}
