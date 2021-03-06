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
import AlamofireImage
import DouyuAPI
import AVKit

class TagsViewController: UICollectionViewController {
    
    var tags: [Tag] = [] {
        didSet {
            collectionView?.reloadData()
        }
    }
    
    override func viewDidLoad() {
        collectionView?.registerClass(TagViewCell.self, forCellWithReuseIdentifier: TagViewCell.reuseIdentifier)
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 330, height: 457.5)
        collectionView?.collectionViewLayout = layout
        
        _ = API.fetchAllTags().subscribeNext { tags in
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
    
    override func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        guard let cell = cell as? TagViewCell else {
            return
        }
        let tag = tags[indexPath.item]
        if let picURL = tag.picURL {
            cell.imageView.af_setImageWithURL(picURL)
        }
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        guard let tagID = tags[indexPath.item].identifier else {
            return
        }
        
        let roomsViewController = RoomsViewController(tagID: tagID)
        self.presentViewController(roomsViewController, animated: true, completion: nil)
    }
}