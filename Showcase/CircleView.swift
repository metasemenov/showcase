//
//  CircleView.swift
//  Showcase
//
//  Created by Admin on 08.10.16.
//  Copyright © 2016 EvilMint. All rights reserved.
//

import UIKit

class CircleView: UIImageView {
    
    override func awakeFromNib() {
        layer.cornerRadius = 5.0
        layer.shadowColor = UIColor(red: SHADOW_COLOR, green: SHADOW_COLOR, blue: SHADOW_COLOR, alpha: 0.5).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
    }

    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //layer.cornerRadius = self.frame.width / 2
        //clipsToBounds = true
    }
    
    
}
