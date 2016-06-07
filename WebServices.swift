//
//  WebServices.swift
//  SpotifyProject
//
//  Created by Kiley  Caravella on 6/7/16.
//  Copyright © 2016 Kiley Caravella. All rights reserved.
//

import Foundation

class WebServices: NSObject {
    let baseURL: String = "https://api.spotify.com"
    var jsonResult: NSDictionary = []
    
    func getSeveralArtists() -> String {
        let url = baseURL + "/v1/artists?ids={ids}"
        let request : NSMutableURLRequest = NSMutableURLRequest()
        request.URL = NSURL(string: url)
        request.HTTPMethod = "GET"

        NSURLSession.sharedSession().dataTaskWithURL(NSURL(string:url)!) { data, response, error in
            jsonResult = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
        }.resume()
        
        let artistName:String = [jsonResult.]
        
//        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue(), completionHandler: {(response:NSURLResponse?, data: NSData?, error: NSError?) -> Void in
//            var error: AutoreleasingUnsafeMutablePointer<NSError?> = nil
//            let jsonResult: NSDictionary! = NSJSONSerialization.JSONObjectWithData((data?)!, options: NSJSONReadingOptions.MutableContainers, error: error)as? NSDictionary
//            
//            if (jsonResult != nil) {
//                //process jsonResult
//                //let artistNames:String = [jsonResult.]
//            } else {
//                print ("errorWithFile")
//            }
//        })
    }
}