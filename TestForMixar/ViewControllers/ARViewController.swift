//
//  ARViewController.swift
//  TestForMixar
//
//  Created by Artem Paliutin on 27/10/2022.
//


import UIKit
import RealityKit
import ARKit
import Combine

class ARViewController: UIViewController {

    var arView: ARView!
    private var speedMovePositionBox: Float = 0.03
    var cancellable: Set<AnyCancellable> = []
    
//    lazy var labelImageRecognized: UILabel = {
//        let label = UILabel()
//        label.isHidden = true
//        label.text = "Image recognized"
//        return
//    }()
    
    lazy var removeAllBoxes: MoveBoxButton = {
        let button = MoveBoxButton(systemName: "trash.square", color: .red, isHidden: true, action: #selector(removeAllAnchors))
        button.configuration?.title = "All"
        return button
    }()
    lazy var buttonDown: MoveBoxButton = {
        let button = MoveBoxButton(systemName: "chevron.down", action: #selector(tapMoveBox))
        return button
    }()
    lazy var buttonUp: MoveBoxButton = {
        let button = MoveBoxButton(systemName: "chevron.up", action: #selector(tapMoveBox))
        return button
    }()
    lazy var buttonLeft: MoveBoxButton = {
        let button = MoveBoxButton(systemName: "chevron.left", action: #selector(tapMoveBox))
        return button
    }()
    lazy var buttonRight: MoveBoxButton = {
        let button = MoveBoxButton(systemName: "chevron.right", action: #selector(tapMoveBox))
        return button
    }()
    lazy var buttonZBegging: MoveBoxButton = {
        let button = MoveBoxButton(systemName: "chevron.compact.up", action: #selector(tapMoveBox))
        return button
    }()
    lazy var buttonZOnMe: MoveBoxButton = {
        let button = MoveBoxButton(systemName: "chevron.compact.down", action: #selector(tapMoveBox))
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
        
        setupConfiguration()
        addSubviewForARView()
        setupConstraints()
        setupControlBox()
        
        //arView.enableLongPressGestureRecognizer()
        enableLongPressGestureRecognizer()
        arView.enableTapGestureRecognizer()
    }
    
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        resetTrackingConfig()
    }
    
    
    
    // MARK: - Methods
    private func setupConfiguration() {
        let arConfiguration = ARWorldTrackingConfiguration()
        arConfiguration.planeDetection = [.vertical, .horizontal]
        arConfiguration.isLightEstimationEnabled = true
        arConfiguration.environmentTexturing = .automatic
        
        if let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) {
            arConfiguration.maximumNumberOfTrackedImages = 1
            arConfiguration.detectionImages = referenceImages
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            arView.topAnchor.constraint(equalTo: view.topAnchor),
            arView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            arView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            arView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            removeAllBoxes.trailingAnchor.constraint(equalTo: arView.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            removeAllBoxes.bottomAnchor.constraint(equalTo: arView.safeAreaLayoutGuide.bottomAnchor, constant: -10),
        ])
    }
    
    private func addSubviewForARView() {
        let subviews = [removeAllBoxes]
        subviews.forEach { subview in
            subview.translatesAutoresizingMaskIntoConstraints = false
            arView.addSubview(subview)
        }
    }
    
    private func setupControlBox() {
        let subviews = [buttonDown, buttonUp, buttonLeft, buttonRight, buttonZOnMe, buttonZBegging]
        subviews.forEach { subview in
            subview.translatesAutoresizingMaskIntoConstraints = false
            arView.addSubview(subview)
        }
        
        NSLayoutConstraint.activate([
            buttonDown.bottomAnchor.constraint(equalTo: arView.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            buttonDown.centerXAnchor.constraint(equalTo: arView.centerXAnchor),
            
            buttonZOnMe.bottomAnchor.constraint(equalTo: buttonDown.topAnchor, constant: -10),
            buttonZOnMe.centerXAnchor.constraint(equalTo: buttonDown.centerXAnchor),
            
            buttonZBegging.bottomAnchor.constraint(equalTo: buttonZOnMe.topAnchor, constant: -10),
            buttonZBegging.centerXAnchor.constraint(equalTo: buttonZOnMe.centerXAnchor),
            
            buttonUp.bottomAnchor.constraint(equalTo: buttonZBegging.topAnchor, constant: -10),
            buttonUp.centerXAnchor.constraint(equalTo: buttonZBegging.centerXAnchor),
            
            buttonLeft.trailingAnchor.constraint(equalTo: buttonDown.leadingAnchor, constant: -40),
            buttonLeft.bottomAnchor.constraint(equalTo: arView.safeAreaLayoutGuide.bottomAnchor, constant: -80),
            
            buttonRight.leadingAnchor.constraint(equalTo: buttonDown.trailingAnchor, constant: 40),
            buttonRight.bottomAnchor.constraint(equalTo: arView.safeAreaLayoutGuide.bottomAnchor, constant: -80)
        ])
    }
        
    @objc private func removeAllAnchors() {
        arView.scene.anchors.removeAll()
        
        if arView.scene.anchors.isEmpty {
            [buttonUp, buttonDown, buttonLeft, buttonRight, buttonZBegging, buttonZOnMe, removeAllBoxes].forEach { button in
                button.isHidden = true
            }
        }
    }
    
    @objc func tapMoveBox(_ sender: UIButton) {
        arView.scene.anchors.forEach { anchor in
            switch sender {
            case buttonDown:
                anchor.position.y += -speedMovePositionBox
            case buttonUp:
                anchor.position.y += speedMovePositionBox
            case buttonLeft:
                anchor.position.x += -speedMovePositionBox
            case buttonRight:
                anchor.position.x += speedMovePositionBox
            case buttonZBegging:
                anchor.position.z += -speedMovePositionBox
            case buttonZOnMe:
                anchor.position.z += speedMovePositionBox
            default:
                break
            }
        }
    }
    
    func placeObject(entityName: String, anchor: ARAnchor) {
        let box = MeshResource.generateBox(size: 0.03)
        let material = SimpleMaterial(color: .randomColor(), isMetallic: true)
        let modelEntity = ModelEntity(mesh: box, materials: [material])
        let anchorEntity = AnchorEntity(anchor: anchor)
        modelEntity.generateCollisionShapes(recursive: true)
        arView.installGestures(.all, for: modelEntity)
        anchorEntity.name = entityName
        
        anchorEntity.addChild(modelEntity)
        arView.scene.addAnchor(anchorEntity)
        
        [buttonUp, buttonDown, buttonLeft, buttonRight, buttonZBegging, buttonZOnMe, removeAllBoxes].forEach { button in
            button.isHidden = false
        }
        
    }
    
    
    private func enableLongPressGestureRecognizer() {
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressGesture))
        arView.addGestureRecognizer(longPressGestureRecognizer)
    }
    @objc private func longPressGesture(_ recognizer: UILongPressGestureRecognizer) {
        let tapLocation = recognizer.location(in: arView)

        if let entity = arView.entity(at: tapLocation) {
            if let anchorEntity = entity.anchor, anchorEntity.name == .constants.nameAnchorBox {
                anchorEntity.removeFromParent()
                if arView.scene.anchors.isEmpty {
                    [buttonUp, buttonDown, buttonLeft, buttonRight, buttonZBegging, buttonZOnMe, removeAllBoxes].forEach { button in
                        button.isHidden = true
                    }
                }
            }
        }
    }
    
}




