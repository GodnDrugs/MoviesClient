//
//  BookmarkMovie.swift
//  MoviesClient
//
//  Created by Sergey Salnikov on 11.02.16.
//  Copyright © 2016 Sergey Salnikov. All rights reserved.
//

import UIKit
import ObjectMapper
import FMDB


class BookmarkMovie: NSObject, Mappable {

    var title: String!
    var year: String!
    var rated: String!
    var released: String!
    var runtime: String!
    var genre: String!
    var director: String!
    var writer: String!
    var actors: String!
    var plot: String!
    var language: String!
    var country: String!
    var awards: String!
    var poster: String!
    var metascore: String!
    var imdbRating: String!
    var imdbVotes: String!
    var imdbID: String!
    var type: String!
    
    override init()
    {
        
    }

    required convenience init?(_ map: Map)
    {
        self.init()
        mapping(map)
    }

    func mapping(map: Map) {
        
        title <- map["Title"]
        year <- map["Year"]
        rated <- map["Rated"]
        released <- map["Released"]
        runtime <- map["Runtime"]
        genre <- map["Genre"]
        director <- map["Director"]
        writer <- map["Writer"]
        actors <- map["Actors"]
        plot <- map["Plot"]
        language <- map["Language"]
        country <- map["Country"]
        awards <- map["Awards"]
        poster <- map["Poster"]
        metascore <- map["Metascore"]
        imdbRating <- map["imdbRating"]
        imdbVotes <- map["imdbVotes"]
        imdbID <- map["imdbID"]
        type <- map["Type"]
        
    }
    
}

extension BookmarkMovie {
    
    class func bookmarkMovieWithResultSet(resultSet: FMResultSet) -> BookmarkMovie
    {
        let bookmarkMovie = BookmarkMovie()
        
        bookmarkMovie.title = resultSet.stringForColumn("title")
        bookmarkMovie.year = resultSet.stringForColumn("year")
        bookmarkMovie.country = resultSet.stringForColumn("country")
        bookmarkMovie.poster = resultSet.stringForColumn("poster")
        bookmarkMovie.rated = resultSet.stringForColumn("rated")
        bookmarkMovie.released = resultSet.stringForColumn("released")
        bookmarkMovie.runtime = resultSet.stringForColumn("runtime")
        bookmarkMovie.genre = resultSet.stringForColumn("genre")
        bookmarkMovie.director = resultSet.stringForColumn("director")
        bookmarkMovie.plot = resultSet.stringForColumn("plot")
        bookmarkMovie.writer = resultSet.stringForColumn("writer")
        bookmarkMovie.actors = resultSet.stringForColumn("actors")
        bookmarkMovie.language = resultSet.stringForColumn("language")
        bookmarkMovie.awards = resultSet.stringForColumn("awards")
        bookmarkMovie.metascore = resultSet.stringForColumn("metascore")
        bookmarkMovie.imdbRating = resultSet.stringForColumn("imdbRating")
        bookmarkMovie.imdbVotes = resultSet.stringForColumn("imdbVotes")
        bookmarkMovie.imdbID = resultSet.stringForColumn("imdbID")
        bookmarkMovie.type = resultSet.stringForColumn("type")
        
        return bookmarkMovie
    }

}
