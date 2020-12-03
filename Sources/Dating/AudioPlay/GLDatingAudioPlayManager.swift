//
//  GLDatingAudioPlayManager.swift
//  SwiftTool
//
//  Created by Yule on 2020/12/3.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import AVFoundation

public class GLDatingAudioPlayManager: NSObject {
    public static let `default` = GLDatingAudioPlayManager()
    
    private var audioPlayer: AVAudioPlayer?
    private var audioURL: URL?
    
    private override init() {
        super.init()
    }
}

extension GLDatingAudioPlayManager {
    /// 继续播放
    private func replayAudio() {
        guard let audioURL = self.audioURL else { return }
        self.audioPlayer = try? AVAudioPlayer(contentsOf: audioURL)
        self.audioPlayer?.prepareToPlay()
        self.audioPlayer?.delegate = self
        self.audioPlayer?.play()
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
    /// 播放一个本地音频文件
    public func playAudio(localAudioPath: String?) {
        guard let localAudioPath = localAudioPath else { return }
        let audioURL = URL(fileURLWithPath: localAudioPath)
        do {
            self.audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
            self.audioPlayer?.prepareToPlay()
            self.audioPlayer?.delegate = self
            self.audioPlayer?.play()
            self.audioURL = audioURL
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
    }
}
