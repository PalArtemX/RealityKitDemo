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
    
    let addBoxButton: UIButton = {
        let button = UIButton(configuration: .borderedTinted())
        button.configuration?.image = UIImage(systemName: "plus.square.dashed")
        button.configuration?.title = "Box"
        button.tintColor = .green
        button.addTarget(.none, action: #selector(addBox), for: .touchUpInside)
        return button
    }()
    
    let removeAllBoxes: UIButton = {
        let button = UIButton(configuration: .borderedTinted())
        button.configuration?.image = UIImage(systemName: "trash.square")
        button.configuration?.title = "All"
        button.tintColor = .red
        button.addTarget(.none, action: #selector(removeAllAnchors), for: .touchUpInside)
        return button
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        arView = ARView(frame: view.bounds)
        view.addSubview(arView)
        
        addGestureRecognizers()
        addSubviewForARView()
        setupConstraints()
        
    }
    
    // MARK: - Setup Methods
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            addBoxButton.centerXAnchor.constraint(equalTo: arView.centerXAnchor),
            addBoxButton.bottomAnchor.constraint(equalTo: arView.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            
            removeAllBoxes.leadingAnchor.constraint(equalTo: addBoxButton.trailingAnchor, constant: 10),
            removeAllBoxes.bottomAnchor.constraint(equalTo: arView.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }
    
    private func addSubviewForARView() {
        let subviews = [addBoxButton, removeAllBoxes]
        subviews.forEach { subview in
            subview.translatesAutoresizingMaskIntoConstraints = false
            arView.addSubview(subview)
        }
    }
    
    
    // MARK: - Add Gesture Recognizers
    private func addGestureRecognizers() {
        arView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapSwitchColorBox)))
        arView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handleTapRemoveBox)))
    }
    
    
    // MARK: - Tap Methods
    @objc func handleTapSwitchColorBox(_ recognizer: UITapGestureRecognizer) {
        guard let view = self.view else { return }
        
        let tapLocation = recognizer.location(in: view)
        
        if let entity = arView.entity(at: tapLocation) as? ModelEntity {
            let material = SimpleMaterial(color: .randomColor(), isMetallic: true)
            entity.model?.materials = [material]
        }
    }
    
    @objc func handleTapRemoveBox(_ recognizer: UITapGestureRecognizer) {
        guard let view = self.view else { return }
        
        let tapLocation = recognizer.location(in: view)
        
        if let entity = arView.entity(at: tapLocation) as? ModelEntity {
            entity.anchor?.removeChild(entity)
        }
    }
    
    @objc func addBox() {
        let anchor = AnchorEntity(plane: .horizontal)
        let material = SimpleMaterial(color: .systemRed, isMetallic: true)
        
        let box = ModelEntity(mesh: .generateBox(size: 0.1), materials: [material])
        box.generateCollisionShapes(recursive: true)
        box.transform = Transform(pitch: 0, yaw: 1, roll: 0)
        
        arView.installGestures(.all, for: box)
        
        anchor.addChild(box)
        arView.scene.addAnchor(anchor)
    }
    
    @objc func removeAllAnchors() {
        arView.scene.anchors.removeAll()
    }
    
    
    
    
}
