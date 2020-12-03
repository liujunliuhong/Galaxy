//
//  GLDatingAudioPlayManager.swift
//  SwiftTool
//
//  Created by Yule on 2020/12/3.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

public class GLDatingAudioPlayManager: NSObject {
    public static let `default` = GLDatingAudioPlayManager()
    
    private var audioPlayer: AVAudioPlayer?
    private var audioURL: URL?
    
    private override init() {
        super.init()
    }
}

extension GLDatingAudioPlayManager {
    
    private func addNotification() {
        self.removeNotification()
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackgroundNotification), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForegroundNotification), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    private func removeNotification() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    /// 继续播放
    private func replayAudio() {
        guard let audioURL = self.audioURL else { return }
        self.stopPlay()
        do {
            self.audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
            self.audioPlayer?.prepareToPlay()
            self.audioPlayer?.delegate = self
            self.audioPlayer?.play()
            self.addNotification()
            self.audioURL = audioURL
        } catch {
            #if DEBUG
            print("[GLDatingAudioPlayManager] [初始化`AVAudioPlayer`失败] \(error)")
            #endif
        }
    }
}

extension GLDatingAudioPlayManager: AVAudioPlayerDelegate {
    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.replayAudio()
    }
    public func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        if let error = error {
            #if DEBUG
            print("[GLDatingAudioPlayManager] [播放音频失败] \(error)")
            #endif
        }
    }
}

extension GLDatingAudioPlayManager {
    @objc private func didEnterBackgroundNotification() {
        self.pausePlay()
    }
    
    @objc private func willEnterForegroundNotification() {
        self.continuePlay()
    }
}

extension GLDatingAudioPlayManager {
    /// 播放一个本地音频文件
    public func playAudio(localAudioPath: String?) {
        self.stopPlay()
        guard let localAudioPath = localAudioPath else { return }
        let audioURL = URL(fileURLWithPath: localAudioPath)
        do {
            self.audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
            self.audioPlayer?.prepareToPlay()
            self.audioPlayer?.delegate = self
            self.audioPlayer?.play()
            self.audioURL = audioURL
            self.addNotification()
        } catch {
            #if DEBUG
            print("[GLDatingAudioPlayManager] [初始化`AVAudioPlayer`失败] \(error)")
            #endif
        }
    }
    
    /// 播放一个远程音频文件
    public func playAudio(remoteAudioPath: String?) {
        self.stopPlay()
        guard let remoteAudioPath = remoteAudioPath else { return }
        guard let audioURL = URL(string: remoteAudioPath) else { return }
        do {
            self.audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
            self.audioPlayer?.prepareToPlay()
            self.audioPlayer?.delegate = self
            self.audioPlayer?.play()
            self.audioURL = audioURL
            self.addNotification()
        } catch {
            #if DEBUG
            print("[GLDatingAudioPlayManager] [初始化`AVAudioPlayer`失败] \(error)")
            #endif
        }
    }
    
    /// 暂停播放
    public func pausePlay() {
        self.audioPlayer?.pause()
    }
    
    /// 继续播放
    public func continuePlay() {
        self.audioPlayer?.play()
    }
    
    /// 停止播放
    public func stopPlay() {
        self.audioPlayer?.stop()
        self.audioPlayer = nil
        self.audioURL = nil
        self.removeNotification()
    }
}
