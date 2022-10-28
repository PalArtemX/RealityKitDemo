//
//  ARViewControllerExtension.swift
//  TestForMixar
//
//  Created by Artem Paliutin on 28/10/2022.
//

import ARKit


extension ARViewController: ARSessionDelegate {
    
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        for anchor in anchors {
            if let anchorName = anchor.name, anchorName == .constants.nameAnchorBox {
                placeObject(entityName: anchorName, anchor: anchor)
            }
        }
    }
    
}
