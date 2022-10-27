//
//  ARViewExtension.swift
//  TestForMixar
//
//  Created by Artem Paliutin on 27/10/2022.
//

import RealityKit
import UIKit
import ARKit

extension ARView {
    
    // MARK: - Delete Box
    func enableLongTouchBoxDelete() {
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressBox))
        self.addGestureRecognizer(longPressGestureRecognizer)
    }
    
    @objc func handleLongPressBox(_ recognizer: UILongPressGestureRecognizer) {
        let location = recognizer.location(in: self)
        
        if let entity = self.entity(at: location) {
            if let anchorEntity = entity.anchor, anchorEntity.name == "BoxAnchor" {
                anchorEntity.removeFromParent()
            }
        }
    }
    
    
    // MARK: - Switch Color Box
    func enableColorSwitchingByTouch() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handlePressGestureBox))
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func handlePressGestureBox(_ recognizer: UILongPressGestureRecognizer) {
        let tapLocation = recognizer.location(in: self)

        if let entity = self.entity(at: tapLocation) as? ModelEntity {
            let material = SimpleMaterial(color: .randomColor(), isMetallic: true)
            entity.model?.materials = [material]
        }
    }
    
    
}
