//
//  TagViewCell.swift
//  Laosiji
//
//  Created by Luo Sheng on 16/6/5.
//  Copyright © 2016年 Luo Sheng. All rights reserved.
//

import Foundation
import UIKit

class TagViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "TagCell"
    
    var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.redColor()
        
        imageView = UIImageView(frame: bounds)
        contentView.addSubview(imageView)
        imageView.backgroundColor = UIColor.blueColor()
        imageView.adjustsImageWhenAncestorFocused = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}