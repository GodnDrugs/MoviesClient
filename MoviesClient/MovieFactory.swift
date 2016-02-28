//
//  MovieFactory.swift
//  MoviesClient
//
//  Created by Sergey Salnikov on 11.02.16.
//  Copyright © 2016 Sergey Salnikov. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper


protocol MovieFactoryDelegate
{
    func responseFalseNotification()
}

class MovieFactory: NSObject {
    
    var delegate:MovieFactoryDelegate? = nil
    
    class var sharedInstance: MovieFactory {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: MovieFactory? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = MovieFactory()
        }
        
        return Static.instance!
    }

    func collectorFoundMovie(searchString text: String, completion: [FoundMovie] -> Void) -> Void
    {
        var imdbIDArray = [String]()
        var foundMovieArray = [FoundMovie]()
        let downloadGroup = dispatch_group_create()
        
        let urlForSearchByTitle = self.createUrlForSearchByTitle(movieTitle: text)
        Alamofire.request(.GET, urlForSearchByTitle, parameters: ["foo": "bar"])
            .responseJSON { response in
                print("")
                if let JSON = response.result.value {
                    
                    let dictionaryJSON = JSON as! NSDictionary
                    let response = dictionaryJSON.valueForKeyPath("Response") as! String
                    
                    if (response == "False") {
                        self.delegate?.responseFalseNotification()
                        return
                    }
                    
                    imdbIDArray = dictionaryJSON.valueForKeyPath("Search.imdbID") as! Array<String>
                }
                
                for id in imdbIDArray {
                    
                    dispatch_group_enter(downloadGroup)
                    let urlSearchByID = self.createUrlForSearchByID(insertID: id)
                    Alamofire.request(.GET, urlSearchByID, parameters: ["foo": "bar"])
                        .responseJSON { response in
                            
                            if let JSON = response.result.value {
                                
                                let foundMovie = Mapper<FoundMovie>().map(JSON)
                                foundMovieArray.append(foundMovie!)
                                print(foundMovie?.title)
                                
                            }
                            
                            dispatch_group_leave(downloadGroup)
                    }//End Alamofire
                    
                } // End for
                dispatch_group_notify(downloadGroup, dispatch_get_main_queue()) {
                         completion(foundMovieArray)
                }
        }//End Alamofire

    }//End Function
    
    func collectorBookmarkMovie(bookmarkMovieID bookmarkMovieID: String, completion: BookmarkMovie -> Void) -> Void
    {
        var bookmarkMovie: BookmarkMovie?
        
        let urlSearchByID = self.createUrlForSearchByID(insertID: bookmarkMovieID)
        Alamofire.request(.GET, urlSearchByID, parameters: ["foo": "bar"])
            .responseJSON { response in
                
                if let JSON = response.result.value {
                    bookmarkMovie = Mapper<BookmarkMovie>().map(JSON)
                    completion(bookmarkMovie!)
                }
        }
    }
    
    
    func createUrlForSearchByID(insertID id: String) -> String
    {
        let URLPartOne = "http://www.omdbapi.com/?i="
        let URLPartTwo = "&plot=full&r=json"
        let resultURL = URLPartOne+id+URLPartTwo
        
        return resultURL
    }
    
    func createUrlForSearchByTitle(movieTitle title: String) -> String
    {
        let stringWithExcessWhitespace = "http://www.omdbapi.com/?s=\(title)"
        var urlForRequest = removeExcessiveSpaces(stringWithExcessWhitespace: stringWithExcessWhitespace)
        urlForRequest = urlForRequest.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        
        return urlForRequest
    }
    
    func removeExcessiveSpaces(stringWithExcessWhitespace string: String) -> String
    {
        let components = string.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        let filtered = components.filter({!$0.isEmpty})
        
        return filtered.joinWithSeparator("+")
    }
    
}//End Class

