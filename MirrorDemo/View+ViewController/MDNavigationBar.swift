//
//  MDNavigationBar.swift
//  MirrorDemo
//
//  Created by Ganesan, Veeramani - Contractor {BIS} on 7/4/18.
//  Copyright © 2018 Ganesan, Veeramani - Contractor {BIS}. All rights reserved.
//

import UIKit

class MDNavigationBar: UINavigationBar {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(1.5)
        context?.setStrokeColor(UIColor.white.cgColor)
        context?.move(to: CGPoint(x: 0, y: rect.height))
        context?.addLine(to: CGPoint(x: rect.width, y: rect.height))
        context?.strokePath()
    }
 
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
