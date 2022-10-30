//
//  ARViewContainer.swift
//  TestForMixar
//
//  Created by Artem Paliutin on 27/10/2022.
//

import SwiftUI
import RealityKit

struct ARViewContainer: UIViewControllerRepresentable {

    func makeUIViewController(context: UIViewControllerRepresentableContext<ARViewContainer>) -> UIViewController {
        let viewController = MainARViewController()
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<ARViewContainer>) {
    }

    func makeCoordinator() -> ARViewContainer.Coordinator {
        return Coordinator()
    }

    class Coordinator {

    }
}
