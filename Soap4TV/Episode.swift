//
//  Episode.swift
//  Soap4TV
//
//  Created by Peter on 13/11/15.
//  Copyright © 2015 Peter Tikhomirov. All rights reserved.
//

import ObjectMapper

protocol EpisodeDelegate: class {
    func didUpdateImage(imageUrl: NSURL)
}


class Episode: Mappable {

    weak var delegate:EpisodeDelegate?

	var sid: String?
	var episode: Int?
	var season: Int?
	var title_en: String?
	var title_ru: String?
	var spoiler: String?
	var season_id: Int?
	var watched: Bool?
	var version = [Version]()
    var screenshotUrl: NSURL?
	
	required init?(_ map: Map){}
	
	let convertToInt = TransformOf<Int, String>(fromJSON: { (value: String?) -> Int? in
		guard let myInt = value else { return nil }
		return Int(myInt)
		}, toJSON: { (value: Int?) -> String? in
			return nil
	})
	
	let convertToBool = TransformOf<Bool, Int>(fromJSON: { (value: Int?) -> Bool? in
		return value == 1 ? true : false
		}, toJSON: { (value: Bool?) -> Int? in
			return nil
	})
	
    func mapping(map: Map) {
		sid <- map["sid"]
		episode <- (map["episode"], convertToInt)
		season <- (map["season"], convertToInt)
		title_en <- map["title_en"]
		title_ru <- map["title_ru"]
		spoiler <- map["spoiler"]
		season_id <- (map["season_id"], convertToInt)
		watched <- (map["watched"], convertToBool)
	}

    func addDelegate(newDelegate:EpisodeDelegate?) {
        delegate = newDelegate
    }

    func addScreenshotUrl(url:NSURL) {
        screenshotUrl = url;
        delegate?.didUpdateImage(url)
    }
}

struct Version {
	var hash: String?
	var quality: String?
	var translate: String?
	var eid: String?
}

struct TVDBEpisode: Mappable {

	var airedEpisodeNumber: Int?
	var airedSeason: Int?
	var episodeName: String?
	var firstAired: String?
	var id: Int?
	var overview: String?
	
	init?(_ map: Map){}
	
	mutating func mapping(map: Map) {
		airedEpisodeNumber <- map["airedEpisodeNumber"]
		airedSeason <- map["airedSeason"]
		episodeName <- map["episodeName"]
		firstAired <- map["firstAired"]
		id <- map["id"]
		overview <- map["overview"]
	}
}








