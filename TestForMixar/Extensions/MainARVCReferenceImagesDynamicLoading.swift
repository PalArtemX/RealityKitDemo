//
//  MainARVCReferenceImagesDynamicLoading.swift
//  TestForMixar
//
//  Created by Artem Paliutin on 31/10/2022.
//

import UIKit
import ReplayKit
import ARKit


extension MainARViewController {
    
    func addReferenceImagesDynamicLoad() {
        if let url = URL(string: urlReferenceImages) {
            let networkingManager = NetworkingManager()
            networkingManager.loadImage(url: url) { result in
                let arReferenceImage = ARReferenceImage(result.cgImage!, orientation: CGImagePropertyOrientation.up, physicalWidth: 4)
                arReferenceImage.name = "crystal"
                self.dynamicReferenceImages.insert(arReferenceImage)
                self.setupConfiguration()
            }
        }
    }
    
}
