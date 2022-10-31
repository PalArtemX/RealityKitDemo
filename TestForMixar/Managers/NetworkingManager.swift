//
//  NetworkingManager.swift
//  TestForMixar
//
//  Created by Artem Paliutin on 31/10/2022.
//

import UIKit


class NetworkingManager {
    
    static var shared = NetworkingManager()
    
    init() { }
    
    func loadImage(url: URL, completionHandler: @escaping (UIImage) -> ()) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        completionHandler(image)
                    }
                }
            }
        }
    }
}
