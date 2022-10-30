//
//  Float+Extension.swift
//  TestForMixar
//
//  Created by Artem Paliutin on 31/10/2022.
//

import Foundation


extension Float {
    static func randomAnchorPosition() -> Float {
        self.random(in: -0.2..<0.2)
    }
}
