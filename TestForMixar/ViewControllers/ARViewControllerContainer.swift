//
//  ARViewControllerContainer.swift
//  TestForMixar
//
//  Created by Artem Paliutin on 27/10/2022.
//

import SwiftUI
import RealityKit

struct ARViewControllerContainer: UIViewControllerRepresentable {

    func makeUIViewController(context: UIViewControllerRepresentableContext<ARViewControllerContainer>) -> UIViewController {
        let viewController = ARViewController()
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<ARViewControllerContainer>) {
    }

    func makeCoordinator() -> ARViewControllerContainer.Coordinator {
        return Coordinator()
    }

    class Coordinator {

    }
}
