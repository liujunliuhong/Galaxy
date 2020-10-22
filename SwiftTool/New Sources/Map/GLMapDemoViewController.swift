//
//  GLMapDemoViewController.swift
//  SwiftTool
//
//  Created by galaxy on 2020/10/21.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit
import MapKit

public class GLMapDemoViewController: UIViewController {
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }
}

extension GLMapDemoViewController {
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let startCoordinate = CLLocationCoordinate2D(latitude: 36.54, longitude: 110.25)
        let startName: String = "点点"
        
        let destinationCoordinate = CLLocationCoordinate2D(latitude: 39.54, longitude: 115.25)
        let destinationName: String = "Test End Point"

        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let gaode = UIAlertAction(title: "Gao De Map", style: .default) { (_) in
            GLMapManager.default.openGaoDeMap(currentPlace: startCoordinate,
                                              currentPlaceName: startName,
                                              destination: destinationCoordinate,
                                              destinationName: destinationName,
                                              navigationType: .driving)
        }
        let baidu = UIAlertAction(title: "Bai Du Map", style: .default) { (_) in
            GLMapManager.default.openBaiDuMap(currentPlace: startCoordinate,
                                              currentPlaceName: startName,
                                              destination: destinationCoordinate,
                                              destinationName: destinationName,
                                              coordinateType: .bd09ll,
                                              navigationType: .driving)
        }
        let _self = UIAlertAction(title: "System Map", style: .default) { (_) in
            GLMapManager.default.openSystemMap(currentPlace: startCoordinate,
                                               currentPlaceName: startName,
                                               destination: destinationCoordinate,
                                               destinationName: destinationName,
                                               directionsMode: MKLaunchOptionsDirectionsModeDriving,
                                               mapType: .standard,
                                               showsTrafficKey: true)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(gaode)
        alert.addAction(baidu)
        alert.addAction(_self)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
}
