//
//  PlayerViewController.swift
//  Soap4TV
//
//  Created by Peter on 16/11/15.
//  Copyright © 2015 Peter Tikhomirov. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class PlayerViewController: AVPlayerViewController {
	
	var videoURL : String!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		let url = NSURL(string: videoURL)
		player = AVPlayer(URL: url!)
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		player!.play()
	}
	
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		self.player!.pause()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
		player = nil
	}
	
}
