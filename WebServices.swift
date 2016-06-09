//
//  WebServices.swift
//  SpotifyProject
//
//  Created by Kiley  Caravella on 6/7/16.
//  Copyright © 2016 Kiley Caravella. All rights reserved.
//

import Foundation

class SARequestManager: NSObject {
     let baseURL: String = "https://api.spotify.com"
     var jsonResult: NSDictionary = [:]
     var artistNames = []
     var artistWebServiceDictionaries = []
    
     func searchArtists(searchArtists: String!, completion: (NSArray,NSArray) -> Void) {
          
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
          NSURLSession.sharedSession().dataTaskWithURL(NSURL(string:url)!) { data, response, error in
                    do {
                         self.jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                         self.artistWebServiceDictionaries = self.jsonResult.valueForKey("artists")!.valueForKey("items") as! NSArray
                         self.artistNames = self.artistWebServiceDictionaries.valueForKey("name") as! NSArray
                         
                         dispatch_async(dispatch_get_main_queue()) {
                              completion(self.artistNames, self.artistWebServiceDictionaries)
                         }
                    } catch {
                         print ("failure")
                    }
          }.resume()
    }

}