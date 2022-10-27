//
//  ituneAPIData.swift
//  ituneAPIPractice
//
//  Created by 羅以捷 on 2022/10/26.
//

import Foundation

struct ituneMusic : Codable {
    var resultCount : Int
    var results : [storeItem]
}

struct storeItem: Codable {
    var artistName: String = ""
    var collectionName: String = ""
    var trackName : String = ""
    var previewUrl : URL?
    var artworkUrl100: URL?
}

struct FavoriteAndPlaySong{
    var isFavorite : [Bool] = []
    var isPlay : [Bool] = []
}
