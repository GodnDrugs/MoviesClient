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
    
    var id: String!
    var title: String!
    var year: String!
    var country: String!
    var poster: String!
    var plot: String!
    
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
        
        self.id <- map["imdbID"]
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
        
        foundMovie.title = resultSet.stringForColumn("title")
        foundMovie.year = resultSet.stringForColumn("year")
        foundMovie.country = resultSet.stringForColumn("country")
        foundMovie.poster = resultSet.stringForColumn("poster")
        foundMovie.plot = resultSet.stringForColumn("plot")
        
        return foundMovie
    }
}










