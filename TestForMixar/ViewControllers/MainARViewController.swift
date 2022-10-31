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
    
    // MARK: - Properties
    var arView: ARView!
    private let speedMoveBox: Float = 0.03
    private let boxSize: Float = 0.04
    var doubleSpeedMoveBox = false
    var cancellable: Set<AnyCancellable> = []
    var dynamicReferenceImages: Set<ARReferenceImage> = []
    let urlReferenceImages = "https://mix-ar.ru/content/ios/marker.jpg"
    
    lazy var imageRecognized: UIImageView = {
        var config = UIImage.SymbolConfiguration(hierarchicalColor: .white)
        let image = UIImage(systemName: "circle.dashed.rectangle", withConfiguration: config)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.isHidden = true
        return imageView
    }()
    lazy var labelScore: UILabel = {
        let label = UILabel()
        label.textColor = .white.withAlphaComponent(0.5)
        label.text = "0"
        label.font = .systemFont(ofSize: 44)
        label.isHidden = true
        return label
    }()
    lazy var buttonRemoveAll: MoveButton = {
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
    lazy var buttonPlaceCoins: MoveButton = {
        let button = MoveButton(systemName: "circle.hexagonpath.fill", color: .green, isHidden: true, action: #selector(placeCoinsCoins))
        button.configuration?.title = "Coins"
        return button
    }()
    
    // MARK: - Life Cycle ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        arView = ARView()
        arView.session.delegate = self
        arView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(arView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // FIXME: Debug Options
        arView.debugOptions = [ARView.DebugOptions.showFeaturePoints]
        
        setupConfiguration()
        addSubviewForARView()
        setupConstraints()
        enableLongPressGestureRecognizer()
        enableTapGestureRecognizer()
        addReferenceImagesDynamicLoad()
    }

    
    // MARK: - Methods
    func setupConfiguration() {
//        guard let referenceImage = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else {
//            return
//        }
    let options = [ARSession.RunOptions.removeExistingAnchors, ARSession.RunOptions.resetTracking]
    
    arView.automaticallyConfigureSession = false
    let configuration = ARWorldTrackingConfiguration()
    configuration.planeDetection = [.horizontal, .vertical]
    configuration.environmentTexturing = .automatic
    configuration.detectionImages = dynamicReferenceImages
    configuration.maximumNumberOfTrackedImages = 1
    
    arView.session.run(configuration, options: ARSession.RunOptions(options))
}
    
    private func addSubviewForARView() {
        let subviews = [buttonRemoveAll, buttonDown, buttonUp, buttonLeft, buttonRight, buttonZOnMe, buttonZBegging, buttonPlaceCoins, imageRecognized, labelScore]
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
            
            buttonRemoveAll.trailingAnchor.constraint(equalTo: arView.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            buttonRemoveAll.bottomAnchor.constraint(equalTo: arView.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            
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
            buttonRight.bottomAnchor.constraint(equalTo: arView.safeAreaLayoutGuide.bottomAnchor, constant: -80),
            
            buttonPlaceCoins.topAnchor.constraint(equalTo: arView.safeAreaLayoutGuide.topAnchor, constant: 10),
            buttonPlaceCoins.trailingAnchor.constraint(equalTo: arView.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            
            imageRecognized.leadingAnchor.constraint(equalTo: arView.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            imageRecognized.topAnchor.constraint(equalTo: arView.safeAreaLayoutGuide.topAnchor, constant: 10),
            imageRecognized.widthAnchor.constraint(equalToConstant: 44),
            
            labelScore.topAnchor.constraint(equalTo: imageRecognized.bottomAnchor, constant: 10),
            labelScore.leadingAnchor.constraint(equalTo: arView.safeAreaLayoutGuide.leadingAnchor, constant: 10)
        ])
    }
    
    @objc private func removeAllAnchors() {
        arView.scene.anchors.removeAll()
        isHiddenButtonMove()
        imageRecognized.isHidden = true
        doubleSpeedMoveBox = false
        labelScore.isHidden = true
    }
    
    @objc private func tapMoveBox(_ sender: UIButton) {
        arView.scene.anchors.forEach { anchor in
            if anchor.name == .constants.nameAnchorBox {
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
                    anchor.position.z += doubleSpeedMoveBox ? -speedMoveBox*2 : -speedMoveBox
                case buttonZOnMe:
                    anchor.position.z += doubleSpeedMoveBox ? speedMoveBox*2 : speedMoveBox
                default:
                    break
                }
            }
        }
    }
    
    func placeBox(entityName: String, anchor: ARAnchor) {
        let box = MeshResource.generateBox(size: boxSize)
        let material = SimpleMaterial(color: .randomColor(), isMetallic: true)
        let modelEntity = ModelEntity(mesh: box, materials: [material])
        let anchorEntity = AnchorEntity(anchor: anchor)
        
        modelEntity.generateCollisionShapes(recursive: true)
        arView.installGestures(.all, for: modelEntity)
        anchorEntity.name = entityName
        
        anchorEntity.addChild(modelEntity)
        arView.scene.addAnchor(anchorEntity)
        
        [buttonUp, buttonDown, buttonLeft, buttonRight, buttonZBegging, buttonZOnMe, buttonRemoveAll, buttonPlaceCoins, buttonPlaceCoins].forEach { button in
            button.isHidden = false
        }
    }
    
    func isHiddenButtonMove() {
        var countBoxAnchors = 0
        
        if arView.scene.anchors.isEmpty {
            [buttonUp, buttonDown, buttonLeft, buttonRight, buttonZBegging, buttonZOnMe, buttonRemoveAll, buttonPlaceCoins].forEach { button in
                button.isHidden = true
            }
        } else {
            for i in 0..<arView.scene.anchors.count {
                if arView.scene.anchors[i].name == .constants.nameAnchorBox {
                    countBoxAnchors += 1
                }
            }
            if countBoxAnchors == 0 {
                [buttonUp, buttonDown, buttonLeft, buttonRight, buttonZBegging, buttonZOnMe, buttonPlaceCoins].forEach { button in
                    button.isHidden = true
                }
            }
        }
    }
    
    @objc private func placeCoinsCoins() {
        for _ in 0...10 {
            let anchorEntity = AnchorEntity(plane: .horizontal)
            anchorEntity.position.y += .randomAnchorPosition() + 0.2
            anchorEntity.position.x += .randomAnchorPosition()
            anchorEntity.position.z += .randomAnchorPosition()
            
            let _ = ModelEntity.loadModelAsync(named: .constants.nameModelCoin1)
                .receive(on: DispatchQueue.main)
                .sink { _ in
                    
                } receiveValue: { [weak self] modelEntity in
                    anchorEntity.addChild(modelEntity)
                    self?.arView.scene.anchors.append(anchorEntity)
                }
                .store(in: &cancellable)
        }
        buttonRemoveAll.isHidden = false
        labelScore.isHidden = false
        buttonPlaceCoins.isHidden = true
    }
    

}

