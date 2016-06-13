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
     var jsonResultDictionary = [:]
     var SAArtistArray: [SAArtist] = []
     var SAArtistSongsArray: [SAArtistSongs] = []
     var albumArray = []
     var imgData = NSData(bytes: [0xFF, 0xD9] as [UInt8], length: 2)
     var request = NSMutableURLRequest()

     
     func searchArtists(searchArtists: String!, completion: (NSArray) -> Void) {
          print("Fetching Artists")
          
          //Modifying String if there are spaces
          let searchArtists = searchArtists.stringByReplacingOccurrencesOfString(" ", withString: "%20")
          
          let startingURL = baseURL + "/v1/search?q="
          let url = startingURL + searchArtists + "&type=artist&limit=30"
          self.SAArtistArray.removeAll()
        
          self.request = NSMutableURLRequest()
          self.request.URL = NSURL(string: url)
          guard self.request.URL != nil else {
               print("URL not valid: \(url)")
               return
          }
        
          self.request.HTTPMethod = "GET"
          NSURLSession.sharedSession().dataTaskWithURL(self.request.URL!) {data, response, error in
               do {
                    self.jsonResultDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    let artistDictionaryArray = self.jsonResultDictionary.valueForKey("artists")!.valueForKey("items") as! NSArray
                        
                    for artistDict in artistDictionaryArray {
                         let artist = SAArtist()
                         artist.followers = artistDict.valueForKey("followers")?.valueForKey("total") as! NSInteger
                         artist.id = artistDict.valueForKey("id") as! String
                         artist.images = artistDict.valueForKey("images") as! NSArray
                         artist.name = artistDict.valueForKey("name") as! String
                         self.SAArtistArray.append(artist)
                    }
                    dispatch_async(dispatch_get_main_queue()) {
                         completion(self.SAArtistArray)
                    }
               } catch {
                    print ("failure")
               }
          }.resume()
     }
     
     func getTopSongsOfArtist(idOfArtist: String, completion: (NSArray) -> Void) {
          print("Fetching Top Songs")
          self.SAArtistSongsArray.removeAll()

          let url = self.baseURL + "/v1/artists/" + idOfArtist + "/top-tracks?country=US"
          self.request.URL = NSURL(string: url)
          guard self.request.URL != nil else {
               print("URL not valid: \(url)")
               return
          }
          
          self.request.HTTPMethod = "GET"
          NSURLSession.sharedSession().dataTaskWithURL(self.request.URL!) {data, response, error in
               do {
                    self.jsonResultDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as!NSDictionary
                    let songJSONArray = self.jsonResultDictionary.valueForKey("tracks") as! NSArray
                    for songInfo in songJSONArray {
                         let song = SAArtistSongs()
                         song.name = songInfo.valueForKey("name") as! String
                         song.previewUrl = songInfo.valueForKey("preview_url") as! String
                         song.durationMs = songInfo.valueForKey("duration_ms") as! Int
                         song.explicit = songInfo.valueForKey("explicit") as! Bool
                         song.albumName = songInfo.valueForKey("album")!.valueForKey("name") as! String
                         self.SAArtistSongsArray.append(song)

                         dispatch_async(dispatch_get_main_queue()) {
                              completion(self.SAArtistSongsArray)
                         }
                    }
               } catch {
                    print("failure")
               }
          }.resume()
     }
     
     func getImg(url: String, completion: (NSData) -> Void) {
          print("Fetching Image")
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