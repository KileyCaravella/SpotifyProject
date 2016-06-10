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
     var artistWebServiceDictionaries = []
    var albumArray = []
     var imgData = NSData(bytes: [0xFF, 0xD9] as [UInt8], length: 2)
     
     func searchArtists(searchArtists: String!, completion: (NSArray, NSArray) -> Void) {
          //Modifying String if there are spaces
          let searchArtists = searchArtists.stringByReplacingOccurrencesOfString(" ", withString: "%20")
          
          let startingURL = baseURL + "/v1/search?q="
          let url = startingURL + searchArtists + "&type=artist&limit=50"
        
          let request: NSMutableURLRequest = NSMutableURLRequest()
          request.URL = NSURL(string: url)
          guard request.URL != nil else {
               print("URL not valid: \(url)")
               return
          }
        
          request.HTTPMethod = "GET"
          NSURLSession.sharedSession().dataTaskWithURL(request.URL!) {data, response, error in
                    do {
                         self.jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                        self.artistWebServiceDictionaries = self.jsonResult.valueForKey("artists")!.valueForKey("items") as! NSArray
                        
                        for artistDict in self.artistWebServiceDictionaries {
                            let artist = Artist()
                            artist.followers = artistDict.valueForKey("followers")?.valueForKey("total") as! NSInteger
                            artist.id = artistDict.valueForKey("id") as! String
                            artist.images = artistDict.valueForKey("images") as! NSArray
                            artist.name = artistDict.valueForKey("name") as! String
                            self.artistsInfo.append(artist)
                        }
                         print(self.artistsInfo[0].name)
                    
                         dispatch_async(dispatch_get_main_queue()) {
                              completion(self.artistWebServiceDictionaries, self.artistsInfo)
                         }
                    } catch {
                         print ("failure")
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
     
     func getAlbumOfArtist(idOfArtist: String!, completion: (NSArray) -> Void) {
          let url = self.baseURL + "/v1/artists/" + idOfArtist + "/albums"
          let request: NSMutableURLRequest = NSMutableURLRequest()
          request.URL = NSURL(string: url)
          guard request.URL != nil else {
               print("URL not valid: \(url)")
               return
          }
          
          request.HTTPMethod = "GET"
          NSURLSession.sharedSession().dataTaskWithURL(request.URL!) {data, response, error in
               do {
                    self.jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    self.albumArray = self.jsonResult.valueForKey("items") as! NSArray
                    dispatch_async(dispatch_get_main_queue()) {
                         completion(self.albumArray)
                    }
                    

               } catch {
                    print ("failure")
               }
          }.resume()
     }
}