//
//  GLDatingAVPlayer.swift
//  SwiftTool
//
//  Created by Yule on 2020/12/3.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit
import AVFoundation

public class GLDatingAVPlayer: UIView {
    
    deinit {
        self.removeNotification()
    }
    
    private var playerLayer: AVPlayerLayer?
    private var playerItem: AVPlayerItem?
    private var player: AVPlayer?
    
    private var videoURL: URL?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    private init() {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GLDatingAVPlayer {
    private func addNotification() {
        self.removeNotification()
        NotificationCenter.default.addObserver(self, selector: #selector(videoPlayFinishedNotification), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self)
    }
    private func removeNotification() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self)
    }
}

extension GLDatingAVPlayer {
    @objc private func videoPlayFinishedNotification(noti: Notification) {
        if let player = noti.object as? GLDatingAVPlayer, player == self {
            self.replay()
        }
    }
}

extension GLDatingAVPlayer {
    private func replay() {
        self.stopPlay()
        guard let videoURL = self.videoURL else { return }
        let playerItem = AVPlayerItem(url: videoURL)
        let player = AVPlayer(playerItem: playerItem)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.frame = self.bounds
        self.layer.addSublayer(playerLayer)
        player.play()
        self.addNotification()
        self.playerLayer = playerLayer
        self.playerItem = playerItem
        self.player = player
    }
}

extension GLDatingAVPlayer {
    
    /// 播放一个本地视频
    public func playVideo(localVideoPath: String?) {
        self.stopPlay()
        guard let localVideoPath = localVideoPath else { return }
        let videoURL = URL(fileURLWithPath: localVideoPath)
        let playerItem = AVPlayerItem(url: videoURL)
        let player = AVPlayer(playerItem: playerItem)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.frame = self.bounds
        self.layer.addSublayer(playerLayer)
        player.play()
        self.addNotification()
        self.playerLayer = playerLayer
        self.playerItem = playerItem
        self.player = player
        self.videoURL = videoURL
    }
    
    /// 播放一个远程视频
    public func playVideo(remoteVideoPath: String?) {
        guard let remoteVideoPath = remoteVideoPath else { return }
        guard let videoURL = URL(string: remoteVideoPath) else { return }
        let playerItem = AVPlayerItem(url: videoURL)
        let player = AVPlayer(playerItem: playerItem)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.frame = self.bounds
        self.layer.addSublayer(playerLayer)
        player.play()
        self.addNotification()
        self.playerLayer = playerLayer
        self.playerItem = playerItem
        self.player = player
        self.videoURL = videoURL
    }
    
    /// 停止播放
    public func stopPlay() {
        self.playerLayer?.removeFromSuperlayer()
        self.playerLayer = nil
        self.playerItem = nil
        self.player?.replaceCurrentItem(with: nil)
        self.player = nil
        self.videoURL = nil
        self.removeNotification()
    }
    
    /// 暂停播放
    public func pausePlay() {
        self.player?.pause()
    }
    
    /// 继续播放
    public func continuePlay() {
        self.player?.play()
    }
}
