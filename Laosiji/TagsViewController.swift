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
    
    var tags: [Tag] = [] {
        didSet {
            collectionView?.reloadData()
        }
    }
    
    override func viewDidLoad() {
        collectionView?.registerClass(TagViewCell.self, forCellWithReuseIdentifier: TagViewCell.reuseIdentifier)
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 400, height: 300)
        collectionView?.collectionViewLayout = layout
        
        _ = API.getColumnDetail("").subscribeNext { tags in
            self.tags = tags
        }
    }
    
    // MARK: - UICollectionViewDataSource
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tags.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(TagViewCell.reuseIdentifier, forIndexPath: indexPath)
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
}