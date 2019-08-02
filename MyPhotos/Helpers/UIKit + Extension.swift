//
//  UIKit + Extension.swift
//  MyPhotos
//
//  Created by Алексей Пархоменко on 30/07/2019.
//  Copyright © 2019 Алексей Пархоменко. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    convenience init(text: String, font: UIFont, textColor: UIColor) {
        self.init(frame: .zero)
        self.text = text
        self.font = font
        self.textColor = textColor
    }
    
    convenience init(text: String, font: UIFont, textAlignment: NSTextAlignment) {
        self.init(frame: .zero)
        self.text = text
        self.font = font
        self.textAlignment = textAlignment
    }
}

