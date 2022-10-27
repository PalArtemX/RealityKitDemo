//
//  ARViewController.swift
//  TestForMixar
//
//  Created by Artem Paliutin on 27/10/2022.
//


import UIKit
import RealityKit

class ARViewController: UIViewController {

    private var arView: ARView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        arView = ARView(frame: view.bounds)
        view.addSubview(arView)
        
        arView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapSwitchColorBox)))
        
        addBox()
        
        
        
    }
    
    @objc func handleTapSwitchColorBox(_ recognizer: UITapGestureRecognizer) {
        guard let view = self.view else { return }
        
        let tapLocation = recognizer.location(in: view)
        
        if let entity = arView.entity(at: tapLocation) as? ModelEntity {
            let material = SimpleMaterial(color: .blue, isMetallic: true)
            entity.model?.materials = [material]
        }
    }
    
    func addBox() {
        let anchor = AnchorEntity(plane: .horizontal)
        
        let material = SimpleMaterial(color: .systemRed, isMetallic: true)
        let box = ModelEntity(mesh: .generateBox(size: 0.2), materials: [material])
        box.generateCollisionShapes(recursive: true)
        arView.installGestures(.all, for: box)
        box.transform = Transform(pitch: 0, yaw: 1, roll: 0)
        anchor.addChild(box)
        
        arView.scene.addAnchor(anchor)

    }
    
    

}
