//
//  AudioPlayerView.swift
//  Repressor Destressor
//
//  Created by Gavin King on 3/20/15.
//  Copyright (c) 2015 Group 2. All rights reserved.
//

import UIKit
import AVFoundation

private let BUTTON_SIZE:CGFloat = 80.0
private let BUTTON_ALPHA:CGFloat = 0.32
private let AUDIO_SLIDER_RATE = 0.01

protocol AudioPlayerViewDelegate
{
    func audioPlayerViewDidPause(audioPlayerView: AudioPlayerView)
    func audioPlayerViewDidPlay(audioPlayerView: AudioPlayerView)
}

class AudioPlayerView: UIView
{
    private var slider: UIView = UIView()
    private var button: UIButton = UIButton()
    
    private var audioPlayer:AVAudioPlayer = AVAudioPlayer()
    private var timer: NSTimer? = nil
    
    // Public properties
    
    var delegate: AudioPlayerViewDelegate?
    var isPlaying = false
    var audioFileUrl: NSURL?
    {
        didSet
        {
            self.audioPlayer = try! AVAudioPlayer(contentsOfURL: self.audioFileUrl!)
            self.audioPlayer.prepareToPlay()
            self.audioPlayer.currentTime = 0.0
            self.updateAudioPlayerView()
            self.pause()
        }
    }
    var percentage: Float
    {
        get
        {
            return Float(self.audioPlayer.currentTime) / Float(self.audioPlayer.duration)
        }
    }
    
    override init (frame : CGRect)
    {
        super.init(frame : frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        self.setup()
    }

    private func setup()
    {
        print("setting up audioplayerview")
        self.backgroundColor = UIColor.lightYellow()
        
        self.slider.frame = CGRectMake(0, 0, 0, self.frame.size.height)
        self.slider.backgroundColor = UIColor.darkYellow()
        self.slider.userInteractionEnabled = false
        self.addSubview(self.slider)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "handleTouch:")
        let panGesture = UIPanGestureRecognizer(target: self, action: "handleTouch:")
        self.addGestureRecognizer(tapGesture)
        self.addGestureRecognizer(panGesture)
        
        self.button.frame = CGRectMake(0, 0, BUTTON_SIZE, BUTTON_SIZE)
        self.button.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(BUTTON_ALPHA)
        self.button.layer.cornerRadius = BUTTON_SIZE / 2
        self.button.setImage(UIImage(named: "play"), forState: .Normal)
        self.button.adjustsImageWhenHighlighted = false
        self.button.addTarget(self, action: "buttonWasTapped:", forControlEvents: .TouchUpInside)
        self.addSubview(self.button)
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        self.button.center = self.convertPoint(self.center, fromView: self.superview)
    }
    
    func updateAudioPlayerView()
    {
        let frame = self.slider.frame
        self.slider.frame = CGRectMake(frame.origin.x, frame.origin.y, self.frame.size.width * CGFloat(self.percentage), frame.size.height)
    }
    
    // MARK: Public API
    
    func play()
    {
        print("inside audio play")
        if (audioFileUrl != nil)
        {
            print("audio file isn't nil")
            self.audioPlayer.play()
            self.timer = NSTimer.scheduledTimerWithTimeInterval(AUDIO_SLIDER_RATE, target: self, selector: "updateAudioPlayerView", userInfo: nil, repeats: true)
            self.button.setImage(UIImage(named: "pause"), forState: .Normal)
            
            self.delegate?.audioPlayerViewDidPlay(self)
        }
    }
    
    func pause()
    {
        if (audioFileUrl != nil)
        {
            print("Inside audio pause")
            self.audioPlayer.pause()
            self.timer = nil
            self.button.setImage(UIImage(named: "play"), forState: .Normal)
            
            self.delegate?.audioPlayerViewDidPause(self)
        }
    }
    
    // MARK: Actions
    
    func buttonWasTapped(sender: UIButton)
    {
        self.isPlaying = !self.isPlaying
        
        if (self.isPlaying)
        {
            self.play()
        }
        else
        {
            self.pause()
        }
    }
    
    func handleTouch(sender: UITapGestureRecognizer)
    {
        if (sender.state == .Began)
        {
            self.delegate?.audioPlayerViewDidPause(self);
        }
        else if ((sender.state == .Ended || sender.state == .Cancelled) && self.isPlaying)
        {
            self.delegate?.audioPlayerViewDidPlay(self);
        }
        
        let point = sender.locationInView(self)
        self.slider.frame = CGRectMake(0, 0, point.x, self.frame.size.height)
        
        let percentage:Float = Float(point.x) / Float(self.frame.size.width)
        
        self.audioPlayer.currentTime = Double(Float(self.audioPlayer.duration) * percentage);
    }
}
