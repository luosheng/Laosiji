//
//  PlayerViewController.swift
//  Laosiji
//
//  Created by Luo Sheng on 16/6/6.
//  Copyright © 2016年 Luo Sheng. All rights reserved.
//

import Foundation
import AVKit
import DouyuAPI

class PlayerViewController: UIViewController, BulletScreenDelegate {
    
    let roomID: String
    var room: Room?
    let bulletScreen: BulletScreen
    
    init(roomID: String) {
        self.roomID = roomID
        bulletScreen = BulletScreen(roomID: roomID)
        super.init(nibName: nil, bundle: nil)
        bulletScreen.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _ = API.fetchRoomForID(roomID).subscribeNext { room in
            self.room = room
            self.loadAVPlayer()
        }
    }
    
    private func loadAVPlayer() {
        guard let URL = room?.HTTPLiveStreamingURL else {
            return
        }
        let asset = AVAsset(URL: URL)
        let playerItem = AVPlayerItem(asset: asset)
        let player = AVPlayer(playerItem: playerItem)
        let playerLayer = AVPlayerLayer(player: player)
        
        playerLayer.frame = view.layer.bounds
        view.layer.addSublayer(playerLayer)
        
        player.play()
    }
    
    func didReceiveBulletMessage(message: BulletMessage) {
        print(message)
    }
    
}