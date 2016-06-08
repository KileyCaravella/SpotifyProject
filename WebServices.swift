//
//  WebServices.swift
//  SpotifyProject
//
//  Created by Kiley  Caravella on 6/7/16.
//  Copyright © 2016 Kiley Caravella. All rights reserved.
//

import Foundation

class WebServices: NSObject {
     let baseURL: String = "https://api.spotify.com/v1/search?q="
     var jsonResult: NSDictionary = [:]
     var artistNames = []
     var boolForTime:Bool! = false
    
     func getSeveralArtists(searchArtists: String!) -> NSArray {
        
          //Modifying String if there are spaces
          let searchArtists = searchArtists.stringByReplacingOccurrencesOfString(" ", withString: "%20")
          
          let url = baseURL + searchArtists + "&type=artist&offset=20&limit=50" //search string goes where empty string currently is
        let request : NSMutableURLRequest = NSMutableURLRequest()
        request.URL = NSURL(string: url)
        guard request.URL != nil else {
            print("URL not valid: \(url)")
            return []
        }
        
        request.HTTPMethod = "GET"
        print("Getting ", searchArtists)
          
        NSURLSession.sharedSession().dataTaskWithURL(NSURL(string:url)!) { data, response, error in
            do {
                self.jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
               self.artistNames = self.jsonResult.valueForKey("artists")!.valueForKey("items")!.valueForKey("name")! as! NSArray
               self.boolForTime = true
            } catch {
                print ("failure")
            }
        }.resume()
          while(!self.boolForTime) {
              NSThread.sleepForTimeInterval(0.0001)
          }
          self.artistNames = self.artistNames.sort{$0.localizedCaseInsensitiveCompare($1 as! String) == NSComparisonResult.OrderedAscending}
     return self.artistNames
    }

}