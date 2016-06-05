//
//  TagsViewController.swift
//  Laosiji
//
//  Created by Luo Sheng on 16/6/5.
//  Copyright © 2016年 Luo Sheng. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class TagsViewController: UICollectionViewController {
    
    var tags: [Tag]?
    
    override func viewDidLoad() {
        _ = API.getColumnDetail("").subscribeNext { tags in
            self.tags = tags
        }
    }
    
    // MARK: - UICollectionViewDataSource
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
}