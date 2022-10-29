//
//  MoveBoxButton.swift
//  TestForMixar
//
//  Created by Artem Paliutin on 29/10/2022.
//

import UIKit


class MoveBoxButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(systemName: String, color: UIColor = .yellow, isHidden: Bool = true, action: Selector) {
        super.init(frame: .zero)
        
        configuration = .borderedTinted()
        configuration?.image = UIImage(systemName: systemName)
        self.isHidden = isHidden
        tintColor = color
        addTarget(.none, action: action, for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


