//
//  ARViewExtension.swift
//  TestForMixar
//
//  Created by Artem Paliutin on 27/10/2022.
//

//import RealityKit
//import UIKit
//import ARKit
//
//extension ARView {
//    
//    
//    
     //MARK: - Delete Box
//    func enableLongPressGestureRecognizer() {
//        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressGesture))
//        self.addGestureRecognizer(longPressGestureRecognizer)
//    }
//
//    @objc func longPressGesture(_ recognizer: UILongPressGestureRecognizer) {
//        let tapLocation = recognizer.location(in: self)
//
//        if let entity = self.entity(at: tapLocation) {
//            if let anchorEntity = entity.anchor, anchorEntity.name == .constants.nameAnchorBox {
//                anchorEntity.removeFromParent()
//            }
//        }
//    }
    
    // MARK: - enableTapGestureRecognizer
//    func enableTapGestureRecognizer() {
//        let tapGestureRecognizerAddBox = UITapGestureRecognizer(target: self, action: #selector(tapGesture))
//        self.addGestureRecognizer(tapGestureRecognizerAddBox)
//    }
//    
//    @objc func tapGesture(_ recognizer: UITapGestureRecognizer) {
//        let tapLocation = recognizer.location(in: self)
//        let result = self.raycast(from: tapLocation, allowing: .estimatedPlane, alignment: .horizontal)
//        
//        if let entity = self.entity(at: tapLocation) as? ModelEntity {
//            let material = SimpleMaterial(color: .randomColor(), isMetallic: true)
//            entity.model?.materials = [material]
//        } else {
//            if let firstResult = result.first {
//                let anchor = ARAnchor(name: .constants.nameAnchorBox, transform: firstResult.worldTransform)
//                self.session.add(anchor: anchor)
//            }
//        }
//        
//        
//        
//    }
//}
