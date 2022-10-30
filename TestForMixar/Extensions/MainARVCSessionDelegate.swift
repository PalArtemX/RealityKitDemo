//
//  ARViewControllerExtension.swift
//  TestForMixar
//
//  Created by Artem Paliutin on 28/10/2022.
//

import ARKit
import RealityKit
import Combine

extension MainARViewController: ARSessionDelegate {
    
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        for anchor in anchors {
            print("Anchor: \(String(describing: anchor.name?.description))")
            if let anchorName = anchor.name, anchorName == .constants.nameAnchorBox {
                placeBox(entityName: anchorName, anchor: anchor)
            }
        }
    }
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        guard let imageAnchor = anchors.first as? ARImageAnchor, let _ = imageAnchor.referenceImage.name else {
            return
        }
        let anchorEntity = AnchorEntity(anchor: imageAnchor)
        
        let _ = ModelEntity.loadModelAsync(named: .constants.nameModelCrystal)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("🌉 Image recognized")
                case .failure(let error):
                    print("⚠️ Error: \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] object in
                anchorEntity.addChild(object)
                self?.arView.scene.anchors.append(anchorEntity)
            }
            .store(in: &cancellable)
        doubleSpeedMoveBox = true
        imageRecognized.isHidden = false
    }
    
    
}
