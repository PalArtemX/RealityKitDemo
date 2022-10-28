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
    
//    let addBoxButton: UIButton = {
//        let button = UIButton(configuration: .borderedTinted())
//        button.configuration?.image = UIImage(systemName: "plus.square.dashed")
//        button.configuration?.title = "Box"
//        button.tintColor = .green
//        button.addTarget(.none, action: #selector(tapGesture), for: .touchUpInside)
//        return button
//    }()
    
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
        
        arView.session.delegate = self
        
        arView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(arView)
        
        // MARK: debugOptions
        arView.debugOptions = [ARView.DebugOptions.showFeaturePoints]
        
        addSubviewForARView()
        setupConstraints()
        
        arView.enableLongPressGestureRecognizer()
        arView.enableTapGestureRecognizer()
    }
    
  
    
    // MARK: - Methods
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            arView.topAnchor.constraint(equalTo: view.topAnchor),
            arView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            arView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            arView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
//            addBoxButton.centerXAnchor.constraint(equalTo: arView.centerXAnchor),
//            addBoxButton.bottomAnchor.constraint(equalTo: arView.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            
            removeAllBoxes.trailingAnchor.constraint(equalTo: arView.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            removeAllBoxes.bottomAnchor.constraint(equalTo: arView.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }
    
    private func addSubviewForARView() {
        let subviews = [removeAllBoxes]
        subviews.forEach { subview in
            subview.translatesAutoresizingMaskIntoConstraints = false
            arView.addSubview(subview)
        }
    }
        
    @objc private func removeAllAnchors() {
        arView.scene.anchors.removeAll()
    }
    
    func placeObject(entityName: String, anchor: ARAnchor) {
        let box = MeshResource.generateBox(size: 0.1)
        let material = SimpleMaterial(color: .randomColor(), isMetallic: true)
        let modelEntity = ModelEntity(mesh: box, materials: [material])
        let anchorEntity = AnchorEntity(anchor: anchor)
        modelEntity.generateCollisionShapes(recursive: true)
        arView.installGestures(.all, for: modelEntity)
        anchorEntity.name = entityName
        
        anchorEntity.addChild(modelEntity)
        arView.scene.addAnchor(anchorEntity)
    }
    
}




