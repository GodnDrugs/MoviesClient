//
//  FoundMovie.swift
//  MoviesClient
//
//  Created by Sergey Salnikov on 09.02.16.
//  Copyright © 2016 Sergey Salnikov. All rights reserved.
//

import UIKit
import ObjectMapper
import FMDB


class FoundMovie: NSObject, Mappable {
    
    var imdbID: String! = ""
    var title: String! = "No Information"
    var year: String! = "No Information"
    var country: String! = "No Information"
    var poster: String! = ""
    var plot: String! = "No Information"
    var bookmarked: String = ""
    
    var isBookmarked: Bool = false
    
    override init()
    {

    }
    
    required convenience init?(_ map: Map)
    {
        self.init()
        mapping(map)
    }

    func mapping(map: Map)
    {
        
        self.imdbID <- map["imdbID"]
        self.title <- map["Title"]
        self.year <- map["Year"]
        self.country <- map["Country"]
        self.poster <- map["Poster"]
        self.plot <- map["Plot"]
        
    }
    
}

extension FoundMovie {
    
    class func foundMovieWithResultSet(resultSet: FMResultSet) -> FoundMovie
    {
        let foundMovie = FoundMovie()
        
        foundMovie.imdbID = resultSet.stringForColumn("imdbID")
        foundMovie.title = resultSet.stringForColumn("title")
        foundMovie.year = resultSet.stringForColumn("year")
        foundMovie.country = resultSet.stringForColumn("country")
        foundMovie.poster = resultSet.stringForColumn("poster")
        foundMovie.plot = resultSet.stringForColumn("plot")
        foundMovie.bookmarked = resultSet.stringForColumn("is_bookmarked")
        
        return foundMovie
    }
}










