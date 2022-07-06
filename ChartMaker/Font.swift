//
//  Font.swift
//  ChartMaker
//
//  Created by Insu Park on 2022/06/21.
//

import Foundation
import UIKit

struct Font {
    
    static func poppins(type: String, size: CGFloat) -> UIFont {
        return UIFont.init(name: "Poppins-\(type)", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
}

extension UIColor {
    
    static func rgb(r red: CGFloat, g green: CGFloat, b blue: CGFloat, a alpha: CGFloat = 1.0) -> UIColor {
        return UIColor.init(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
    }
    
}
