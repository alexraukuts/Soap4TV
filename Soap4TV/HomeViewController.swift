//
//  HomeViewController.swift
//  Soap4TV
//
//  Created by Peter on 21/11/15.
//  Copyright © 2015 Peter Tikhomirov. All rights reserved.
//

import UIKit
import Kingfisher
import SwiftyUserDefaults

let featuredCellIdentifier = "featuredCell"

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
	
	var token: String?
	var featuredShows = [TVShow]()
	
	@IBOutlet weak var topBanner: UIImageView!
	@IBOutlet weak var newShowsCollectionView: UICollectionView!
	@IBOutlet weak var poster: UIImageView!
	@IBOutlet weak var title_en: UILabel!
	@IBOutlet weak var title_ru: UILabel!
//	@IBOutlet weak var text: FocusableLabel!
	@IBOutlet weak var text: FocusableText!
	
    override func viewDidLoad() {
		super.viewDidLoad()
		text.selectable = true
		self.newShowsCollectionView.registerNib(UINib(nibName: "FeaturedCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: featuredCellIdentifier)
		topBanner.image = UIImage(named: "featured-background")
		//	topBanner.kf_setImageWithURL(NSURL(string: "http://thetvdb.com/banners/fanart/original/298156-1.jpg")!)
		let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
		let blurView = UIVisualEffectView(effect: blurEffect)
		blurView.frame = topBanner.bounds
		topBanner.addSubview(blurView)
		loadFeaturedData()
	}
	
	private func loadFeaturedData() {
		guard let token = self.token else {
			print("Failed to get token")
			return
		}
		print("token is: \(token)")
		API().getTVShows(token, view: nil) { objects, error in
			if let shows = objects {
				let sortedShows = shows.sort(>)
				self.featuredShows = sortedShows.takeElements(Config.maxNumberFeatured)
				self.newShowsCollectionView.reloadData()
			}
		}
	}
	
	func getFeaturedShowInfo(show: TVShow) {
		guard let tvdb = show.tvdb_id, token = Defaults[.TVDBToken] else {
			return
		}
		self.text.show = show
		self.text.parentView = self
		TVDB().getShow(tvdb, token: token) { response, error in
			if let _ = response {
				TVDB().getPoster(tvdb, token: token) { response, error in
					guard let response = response else {return}
					let object = response["data"].first
					if let poster = object {
						guard let url = NSURL(string: "\(Config.tvdb.baseURL)\(poster.1["fileName"])") else {
							return
						}
						self.poster.kf_setImageWithURL(url)
						self.title_en.text = show.title
						self.title_ru.text = show.title_ru
						self.text.text = show.description
					}
				}
			}
		}
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
	}
	
	func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return featuredShows.count
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = newShowsCollectionView.dequeueReusableCellWithReuseIdentifier(featuredCellIdentifier, forIndexPath: indexPath) as! FeaturedCollectionViewCell
		let show = featuredShows[indexPath.row]
		print(show.title)
		if let sid = show.sid {
			let URL = NSURL(string: "\(Config.URL.covers)/soap/big/\(sid).jpg")!
			let placeholderImage = UIImage(named: "placeholder")!
			cell.cover.kf_setImageWithURL(URL, placeholderImage: placeholderImage)
		}
		return cell
	}
	
	func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		let show = featuredShows[indexPath.row]
		getFeaturedShowInfo(show)
	}
	
	override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
		
		if let next = context.nextFocusedView as? FeaturedCollectionViewCell {
			next.setNeedsUpdateConstraints()
			UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 3, options: .CurveEaseIn, animations: {
				next.transform = CGAffineTransformMakeScale(1.2,1.2)
				}, completion: nil)
		}
		
		if let prev = context.previouslyFocusedView as? FeaturedCollectionViewCell {
			prev.setNeedsUpdateConstraints()
			UIView.animateWithDuration(0.1, animations: {
				prev.transform = CGAffineTransformIdentity
			})
		}
	}
	
	
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	/*
	
	1. Get 20 latest tv shows
	2. Get /my tv shows schedule
	3. Get popular tv shows

	
	*/
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}