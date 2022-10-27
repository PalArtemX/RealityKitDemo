//
//  ARViewController.swift
//  TestForMixar
//
//  Created by Artem Paliutin on 27/10/2022.
//


import UIKit
import RealityKit
import ARKit

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
        arView = ARView()
        
        arView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(arView)
        
        addSubviewForARView()
        setupConstraints()
        
        arView.enableLongTouchBoxDelete()
        arView.enableColorSwitchingByTouch()
    }
    
  
    
    // MARK: - Setup Methods
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            arView.topAnchor.constraint(equalTo: view.topAnchor),
            arView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            arView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            arView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
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
    
    
    
    // MARK: - Tap Methods
    @objc private func addBox() {
        let box = MeshResource.generateBox(size: 0.1)
        let material = SimpleMaterial(color: .systemRed, isMetallic: true)
        let modelEntity = ModelEntity(mesh: box, materials: [material])
        let anchorEntity = AnchorEntity(plane: .horizontal)
        anchorEntity.name = "BoxAnchor"
        anchorEntity.addChild(modelEntity)
        arView.scene.addAnchor(anchorEntity)
        modelEntity.generateCollisionShapes(recursive: true)
        arView.installGestures(.all, for: modelEntity)
    }
    
    @objc private func removeAllAnchors() {
        arView.scene.anchors.removeAll()
    }
    
    
    
    
}
