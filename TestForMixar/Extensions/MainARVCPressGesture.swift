//
//  MainVCPressGesture.swift
//  TestForMixar
//
//  Created by Artem Paliutin on 30/10/2022.
//

import UIKit
import RealityKit
import ARKit


extension MainARViewController {
    
    // MARK: - LongPressGesture
    func enableLongPressGestureRecognizer() {
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressGesture))
        arView.addGestureRecognizer(longPressGestureRecognizer)
    }
    @objc private func longPressGesture(_ recognizer: UILongPressGestureRecognizer) {
        let tapLocation = recognizer.location(in: arView)

        if let entity = arView.entity(at: tapLocation) {
            if let anchorEntity = entity.anchor, anchorEntity.name == .constants.nameAnchorBox {
                anchorEntity.removeFromParent()
                isHiddenButtonMove()
            }
        }
    }
    
    
    // MARK: - TapGesture
    func enableTapGestureRecognizer() {
        let tapGestureRecognizerAddBox = UITapGestureRecognizer(target: self, action: #selector(tapGesture))
        arView.addGestureRecognizer(tapGestureRecognizerAddBox)
    }
    
    @objc func tapGesture(_ recognizer: UITapGestureRecognizer) {
        let tapLocation = recognizer.location(in: arView)
        let result = arView.raycast(from: tapLocation, allowing: .estimatedPlane, alignment: .horizontal)
        
        if let entity = arView.entity(at: tapLocation) as? ModelEntity {
            let material = SimpleMaterial(color: .randomColor(), isMetallic: true)
            entity.model?.materials = [material]
        } else {
            if let firstResult = result.first {
                let anchor = ARAnchor(name: .constants.nameAnchorBox, transform: firstResult.worldTransform)
                arView.session.add(anchor: anchor)
            }
        }
    }
    
}
