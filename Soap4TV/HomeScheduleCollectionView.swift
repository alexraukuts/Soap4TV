//
//  HomeScheduleCollectionView.swift
//  Soap4TV
//
//  Created by Peter on 26/11/15.
//  Copyright © 2015 Peter Tikhomirov. All rights reserved.
//

import UIKit
import Kingfisher

private let reuseIdentifier = "scheduleCollectionCell"

class HomeScheduleCollectionView: UICollectionViewController {
	
	var data = [Schedule]()
	let dateFormatter = NSDateFormatter()
	
	override func viewDidLoad() {
		self.collectionView!.registerNib(UINib(nibName: "ScheduleCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
	}
	
	func loadSchedule(schedule: [Schedule]) {
		self.data = schedule
		collectionView?.reloadData()
	}
	
	override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return 1
	}
	
	override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return data.count
	}
	
	override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ScheduleCollectionViewCell
		
		let schedule = data[indexPath.row]
		dateFormatter.dateFormat = "dd.MM.yyyy"
		if let d = schedule.date {
			cell.showDate.text = dateFormatter.stringFromDate(d)
		}
		cell.showTitle.text = schedule.title
		cell.showEpisode.text = schedule.episode
		if let sid = schedule.sid {
			let URL = NSURL(string: "\(Config.URL.covers)/soap/\(sid).jpg")!
			let placeholderImage = UIImage(named: "placeholder")!
			cell.cover.kf_setImageWithURL(URL, placeholderImage: placeholderImage)
		}
		
		return cell
	}
	
	override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
		
		if let next = context.nextFocusedView as? ScheduleCollectionViewCell {
			UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 3, options: .CurveEaseIn, animations: {
				next.transform = CGAffineTransformMakeScale(1.2,1.2)
				}, completion: { done in
			})
		}
		
		if let prev = context.previouslyFocusedView as? ScheduleCollectionViewCell {
			UIView.animateWithDuration(0.1, animations: {
				prev.transform = CGAffineTransformIdentity
			})
		}
	}
	
	

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
