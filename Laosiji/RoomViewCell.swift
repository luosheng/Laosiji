//
//  RoomViewCell.swift
//  Laosiji
//
//  Created by Luo Sheng on 16/6/6.
//  Copyright © 2016年 Luo Sheng. All rights reserved.
//

import Foundation
import UIKit

class RoomViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "RoomCell"
    
    var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView = UIImageView(frame: bounds)
        contentView.addSubview(imageView)
        imageView.adjustsImageWhenAncestorFocused = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
