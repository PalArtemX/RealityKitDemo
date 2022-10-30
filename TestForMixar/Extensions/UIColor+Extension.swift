//
//  UIColorExtension.swift
//  TestForMixar
//
//  Created by Artem Paliutin on 27/10/2022.
//

import UIKit


extension UIColor {
    static func randomColor() -> UIColor {
        return UIColor(displayP3Red: Double.random(in: 0...1),
                       green: Double.random(in: 0...1),
                       blue: Double.random(in: 0...1),
                       alpha: 1.0)
    }
}
