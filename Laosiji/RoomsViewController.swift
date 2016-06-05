//
//  RoomsViewController.swift
//  Laosiji
//
//  Created by Luo Sheng on 16/6/6.
//  Copyright © 2016年 Luo Sheng. All rights reserved.
//

import Foundation
import UIKit
import DouyuAPI

class RoomsViewController: UICollectionViewController {
    
    let tagID: String
    
    var rooms: [Room] = [] {
        didSet {
            collectionView?.reloadData()
        }
    }
    
    init(tagID: String) {
        self.tagID = tagID
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 320, height: 180)
    
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        collectionView?.registerClass(RoomViewCell.self, forCellWithReuseIdentifier: RoomViewCell.reuseIdentifier)
        
        _ = API.fetchRoomsForTag(tagID).subscribeNext { rooms in
            self.rooms = rooms
        }
    }
    
    // MARK: - UICollectionViewDataSource
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.rooms.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(RoomViewCell.reuseIdentifier, forIndexPath: indexPath)
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    override func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        guard let cell = cell as? RoomViewCell else {
            return
        }
        let room = rooms[indexPath.item]
        if let URL = room.src {
            cell.imageView.af_setImageWithURL(URL)
        }
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        guard let roomID = rooms[indexPath.item].identifier else {
            return
        }
        
        let playerViewController = PlayerViewController(roomID: roomID)
        self.presentViewController(playerViewController, animated: true, completion: nil)
    }
    
}