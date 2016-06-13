//
//  WebServices.swift
//  SpotifyProject
//
//  Created by Kiley  Caravella on 6/7/16.
//  Copyright © 2016 Kiley Caravella. All rights reserved.
//

import Foundation

class SARequestManager: NSObject {
     let baseURL = "https://api.spotify.com"
     var jsonResult = [:]
     var artistsInfo: [Artist] = []
     var songInfo: [ArtistSongs] = []
     var albumArray = []
     var imgData = NSData(bytes: [0xFF, 0xD9] as [UInt8], length: 2)
     var request = NSMutableURLRequest()

     
     func searchArtists(searchArtists: String!, completion: (NSArray) -> Void) {
          print("Fetching Artists")
          
          //Modifying String if there are spaces
          let searchArtists = searchArtists.stringByReplacingOccurrencesOfString(" ", withString: "%20")
          
          let startingURL = baseURL + "/v1/search?q="
          let url = startingURL + searchArtists + "&type=artist&limit=30"
          self.artistsInfo.removeAll()
        
          self.request = NSMutableURLRequest()
          self.request.URL = NSURL(string: url)
          guard self.request.URL != nil else {
               print("URL not valid: \(url)")
               return
          }
        
          self.request.HTTPMethod = "GET"
          NSURLSession.sharedSession().dataTaskWithURL(self.request.URL!) {data, response, error in
               do {
                    self.jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    let artistDictionaryArray = self.jsonResult.valueForKey("artists")!.valueForKey("items") as! NSArray
                        
                    for artistDict in artistDictionaryArray {
                         let artist = Artist()
                         artist.followers = artistDict.valueForKey("followers")?.valueForKey("total") as! NSInteger
                         artist.id = artistDict.valueForKey("id") as! String
                         artist.images = artistDict.valueForKey("images") as! NSArray
                         artist.name = artistDict.valueForKey("name") as! String
                         self.artistsInfo.append(artist)
                    }
                    dispatch_async(dispatch_get_main_queue()) {
                         completion(self.artistsInfo)
                    }
               } catch {
                    print ("failure")
               }
          }.resume()
     }
     
//     func getAlbumOfArtist(idOfArtist: String!, completion: (NSArray) -> Void) {
//          let url = self.baseURL + "/v1/artists/" + idOfArtist + "/albums"
//          self.request.URL = NSURL(string: url)
//          guard self.request.URL != nil else {
//               print("URL not valid: \(url)")
//               return
//          }
//          
//          self.request.HTTPMethod = "GET"
//          NSURLSession.sharedSession().dataTaskWithURL(self.request.URL!) {data, response, error in
//               do {
//                    self.jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
//                    self.albumArray = self.jsonResult.valueForKey("items") as! NSArray
//                    dispatch_async(dispatch_get_main_queue()) {
//                         completion(self.albumArray)
//                    }
//               } catch {
//                    print ("failure")
//               }
//          }.resume()
//     }
     
     func getTopSongsOfArtist(idOfArtist: String, completion: (NSArray) -> Void) {
          print("Fetching Top Songs")
          self.songInfo.removeAll()

          let url = self.baseURL + "/v1/artists/" + idOfArtist + "/top-tracks?country=US"
          self.request.URL = NSURL(string: url)
          guard self.request.URL != nil else {
               print("URL not valid: \(url)")
               return
          }

          
          self.request.HTTPMethod = "GET"
          NSURLSession.sharedSession().dataTaskWithURL(self.request.URL!) {data, response, error in
               do {
                    self.jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as!NSDictionary
                    let songJSONArray = self.jsonResult.valueForKey("tracks") as! NSArray
                    for songInfo in songJSONArray {
                         let song = ArtistSongs()
                         song.name = songInfo.valueForKey("name") as! String
                         song.previewUrl = songInfo.valueForKey("preview_url") as! String
                         song.durationMs = songInfo.valueForKey("duration_ms") as! Int
                         song.explicit = songInfo.valueForKey("explicit") as! Bool
                         song.albumName = songInfo.valueForKey("album")!.valueForKey("name") as! String
                         self.songInfo.append(song)

                         dispatch_async(dispatch_get_main_queue()) {
                              completion(self.songInfo)
                         }
                    }
               } catch {
                    print("failure")
               }
          }.resume()
     }
     
     func getImg(url: String, completion: (NSData) -> Void) {
          let url = NSURL(string:url)!
          
          NSURLSession.sharedSession().dataTaskWithURL(url) {(data, response, error) in
               
               dispatch_async(dispatch_get_main_queue()) {
                    if NSData(contentsOfURL: url) != nil {
                         self.imgData = NSData(contentsOfURL: url)!
                    }
                         
                    else {
                         print("data returned nil")
                    }
                    
                    completion(self.imgData)
               }
               }.resume()
     }
}