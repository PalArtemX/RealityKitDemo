//
//  MainARViewController.swift
//  TestForMixar
//
//  Created by Artem Paliutin on 27/10/2022.
//


import UIKit
import RealityKit
import ARKit
import Combine

class MainARViewController: UIViewController {

    var newReferenceImages:Set<ARReferenceImage> = Set<ARReferenceImage>()
    var arView: ARView!
    private let speedMoveBox: Float = 0.03
    var doubleSpeedMoveBox = false
    private var boxSize: Float = 0.04
    var cancellable: Set<AnyCancellable> = []
    
//    lazy var labelImageRecognized: UILabel = {
//        let label = UILabel()
//        label.isHidden = true
//        label.text = "Image recognized"
//        return
//    }()
    
    lazy var removeAllBoxes: MoveButton = {
        let button = MoveButton(systemName: "trash.square", color: .red, isHidden: true, action: #selector(removeAllAnchors))
        button.configuration?.title = "All"
        return button
    }()
    lazy var buttonDown: MoveButton = {
        let button = MoveButton(systemName: "chevron.down", action: #selector(tapMoveBox))
        return button
    }()
    lazy var buttonUp: MoveButton = {
        let button = MoveButton(systemName: "chevron.up", action: #selector(tapMoveBox))
        return button
    }()
    lazy var buttonLeft: MoveButton = {
        let button = MoveButton(systemName: "chevron.left", action: #selector(tapMoveBox))
        return button
    }()
    lazy var buttonRight: MoveButton = {
        let button = MoveButton(systemName: "chevron.right", action: #selector(tapMoveBox))
        return button
    }()
    lazy var buttonZBegging: MoveButton = {
        let button = MoveButton(systemName: "chevron.compact.up", action: #selector(tapMoveBox))
        return button
    }()
    lazy var buttonZOnMe: MoveButton = {
        let button = MoveButton(systemName: "chevron.compact.down", action: #selector(tapMoveBox))
        return button
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        arView = ARView()
        arView.session.delegate = self
        arView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(arView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // MARK: debugOptions
        arView.debugOptions = [ARView.DebugOptions.showFeaturePoints]
        
        setupConfiguration()
        
        addSubviewForARView()
        setupConstraints()
        enableLongPressGestureRecognizer()
        enableTapGestureRecognizer()
    }

    
    // MARK: - Methods
    private func setupConfiguration() {
        guard let referenceImage = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else {
            return
        }
        let options = [ARSession.RunOptions.removeExistingAnchors, ARSession.RunOptions.resetTracking]
       
        arView.automaticallyConfigureSession = false
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        configuration.environmentTexturing = .automatic
        configuration.detectionImages = referenceImage
        configuration.maximumNumberOfTrackedImages = 1
        
        arView.session.run(configuration, options: ARSession.RunOptions(options))
    }
    
    private func addSubviewForARView() {
        let subviews = [removeAllBoxes, buttonDown, buttonUp, buttonLeft, buttonRight, buttonZOnMe, buttonZBegging]
        subviews.forEach { subview in
            subview.translatesAutoresizingMaskIntoConstraints = false
            arView.addSubview(subview)
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
        isHiddenButtonMove(isHidden: true)
    }
    
    @objc func tapMoveBox(_ sender: UIButton) {
        arView.scene.anchors.forEach { anchor in
            switch sender {
            case buttonDown:
                anchor.position.y += doubleSpeedMoveBox ? -speedMoveBox*2 : -speedMoveBox
            case buttonUp:
                anchor.position.y += doubleSpeedMoveBox ? speedMoveBox*2 : speedMoveBox
            case buttonLeft:
                anchor.position.x += doubleSpeedMoveBox ? -speedMoveBox*2 : -speedMoveBox
            case buttonRight:
                anchor.position.x += doubleSpeedMoveBox ? speedMoveBox*2 : speedMoveBox
            case buttonZBegging:
                anchor.position.z += doubleSpeedMoveBox ? speedMoveBox*2 : -speedMoveBox
            case buttonZOnMe:
                anchor.position.z += doubleSpeedMoveBox ? speedMoveBox*2 : speedMoveBox
            default:
                break
            }
        }
    }
    
    
    func placeObject(entityName: String, anchor: ARAnchor) {
        let box = MeshResource.generateBox(size: boxSize)
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
    
    func isHiddenButtonMove(isHidden: Bool) {
        if arView.scene.anchors.isEmpty {
            [buttonUp, buttonDown, buttonLeft, buttonRight, buttonZBegging, buttonZOnMe, removeAllBoxes].forEach { button in
                button.isHidden = isHidden
            }
        }
    }
    
}




