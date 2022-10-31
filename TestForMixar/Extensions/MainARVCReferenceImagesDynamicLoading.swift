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
    func loadImageFrom(url: URL, completionHandler: @escaping (UIImage) -> ()) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        completionHandler(image)
                    }
                }
            }
        }
    }
    
    func addReferenceImagesDynamicLoad() {
        if let url = URL(string: urlReferenceImages) {
            self.loadImageFrom(url: url) { result in
                let arReferenceImage = ARReferenceImage(result.cgImage!, orientation: CGImagePropertyOrientation.up, physicalWidth: 4)
                arReferenceImage.name = "crystal"
                self.dynamicReferenceImages.insert(arReferenceImage)
                self.setupConfiguration()
            }
        }
    }
}
