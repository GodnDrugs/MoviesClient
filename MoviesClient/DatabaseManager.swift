//
//  DatabaseManager.swift
//  MoviesClient
//
//  Created by Sergey Salnikov on 08.02.16.
//  Copyright © 2016 Sergey Salnikov. All rights reserved.
//

import UIKit
import Foundation
import FMDB

let kDatabaseName = "movieclient.sqlite"
let createFoundMovieTableQuery = "CREATE  TABLE  IF NOT EXISTS found_movies (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, imdbID VARCHAR NOT NULL, title VARCHAR NOT NULL, year VARCHAR NOT NULL , country VARCHAR NOT NULL , poster VARCHAR NOT NULL , plot VARCHAR NOT NULL)"
let dropFoundMovieTableQuery = "DROP TABLE found_movies"
let createBookmarksTableQuery = "CREATE  TABLE  IF NOT EXISTS bookmarks (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, title VARCHAR NOT NULL , year VARCHAR NOT NULL , rated VARCHAR NOT NULL, released VARCHAR NOT NULL, runtime VARCHAR NOT NULL, genre VARCHAR NOT NULL, director VARCHAR NOT NULL, writer VARCHAR NOT NULL, actors VARCHAR NOT NULL, plot VARCHAR NOT NULL, language VARCHAR NOT NULL, country VARCHAR NOT NULL, awards VARCHAR NOT NULL , poster VARCHAR NOT NULL , metascore VARCHAR NOT NULL, imdbRating VARCHAR NOT NULL, imdbVotes VARCHAR NOT NULL, imdbID VARCHAR NOT NULL, type VARCHAR NOT NULL)"


class DatabaseManager: NSObject {
    
//    let db: FMDatabase
    let queue: FMDatabaseQueue

    class var sharedInstance: DatabaseManager {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: DatabaseManager? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = DatabaseManager()
        }
        
        return Static.instance!
    }
    
    override init()
    {
        let documentsFolderUrl = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
        let databasePathUrl = documentsFolderUrl.URLByAppendingPathComponent(kDatabaseName)
        print("Path to database on device: \(databasePathUrl)")
        
        let databasePathString = databasePathUrl.path
        
//        if !NSFileManager.defaultManager().fileExistsAtPath(databasePathString!) {
//            let pathToBundledDatabase = NSBundle.mainBundle().resourcePath!.stringByAppendingPathComponent(kDatabaseName)
//            
//            do {
//                try NSFileManager.defaultManager().copyItemAtPath(pathToBundledDatabase, toPath: databasePathString!)
//            } catch let error as NSError {
//                print("Cannot copy boundle database file : \(error.localizedDescription)")
//            }
//            
//        }
        self.queue = FMDatabaseQueue(path: databasePathString)
//        self.db = FMDatabase(path: databasePathString)
//        let isOpened = self.queue.open()
//        if !isOpened {
//            print("Could not open \(kDatabaseName) database!")
//        }
    }
    
    func saveSearchResult(resultToSave result: [FoundMovie]) -> Void
    {
        //            SELECT count(*) FROM sqlite_master WHERE type='table' AND name='found_movies';
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            
            self.queue.inTransaction { db, rollback in
                do {
                    let tableExist = db.tableExists("found_movies")
                    
                    if !tableExist {
                        try db.executeUpdate(createFoundMovieTableQuery, values: nil)
                    } else {
                        try db.executeUpdate(dropFoundMovieTableQuery, values: nil)
                        try db.executeUpdate(createFoundMovieTableQuery, values: nil)
                        for movie in result {
                            let title = movie.title
                            let year = movie.year
                            let country = movie.country
                            let poster = movie.poster
                            let plot = movie.plot
                            let imdbID = movie.imdbID
                            let saveResultQuery = "INSERT INTO found_movies (imdbID, title, year, country, poster, plot) VALUES (?, ?, ?, ?, ?, ?)"
                            let updateSuccessful = db.executeUpdate(saveResultQuery, withArgumentsInArray: [imdbID, title, year, country, poster, plot])
                            
                            if !updateSuccessful {
                                print("Insert failure: \(db.lastErrorMessage())")
                            }
                        }
                    }
                } catch {
                    rollback.memory = true
                    print(error)
                }
            }

        })

    }
    
    func loadPreviousSearchResult(completion: [FoundMovie] -> Void) -> Void
    {
        var foundMovieArray = Array<FoundMovie>()
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            self.queue.inDatabase({ (db) -> Void in
                let rs = db.executeQuery("select * from found_movies", withArgumentsInArray: nil)
                
                if rs == nil {
                    return
                }
                
                while rs.next() {
                    let resultFoundMovie = FoundMovie.foundMovieWithResultSet(rs)
                    foundMovieArray.append(resultFoundMovie)
                }
            })
            completion(foundMovieArray)
        })
    }
    
    func getMovieBookmarks(completion: [BookmarkMovie] -> Void) -> Void
    {
        var bookmarkMovieArray = Array<BookmarkMovie>()
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            self.queue.inDatabase({ (db) -> Void in
                let rs = db.executeQuery("select * from bookmarks", withArgumentsInArray: nil)

                if rs == nil {
                    return
                }
                
                while rs.next() {
                    let bookmarkMovie = BookmarkMovie.bookmarkMovieWithResultSet(rs)
                    bookmarkMovieArray.append(bookmarkMovie)
                }
            })
            completion(bookmarkMovieArray)
        })
    }
    
    func addMovieToBookmarks(addToBookmarks movie: BookmarkMovie) -> Void
    {
        let title = movie.title
        let year = movie.year
        let rated = movie.rated
        let released = movie.released
        let runtime = movie.runtime
        let genre = movie.genre
        let director = movie.director
        let writer = movie.writer
        let actors = movie.actors
        let plot = movie.plot
        let language = movie.language
        let country = movie.country
        let awards = movie.awards
        let poster = movie.poster
        let metascore = movie.metascore
        let imdbRating = movie.imdbRating
        let imdbVotes = movie.imdbVotes
        let imdbID = movie.imdbID
        let type = movie.type
        ///Сделать проверку, чтобы не было одинаковых записей
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            self.queue.inTransaction({ db, rollback -> Void in
                do {
                    try db.executeUpdate(createBookmarksTableQuery, values: nil)
                    
                    let addToBookmarksQuery = "INSERT INTO bookmarks (title, year, rated, released, runtime, genre, director, writer, actors, plot, language, country, awards, poster, metascore, imdbRating , imdbVotes, imdbID, type) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
                    let updateSuccessful = db.executeUpdate(addToBookmarksQuery, withArgumentsInArray: [title!, year!, rated!, released!, runtime!, genre!, director!, writer!, actors!, plot!, language!, country!, awards!, poster!, metascore!, imdbRating!, imdbVotes!, imdbID!, type!])
                    if !updateSuccessful {
                        print("Insert failure: \(db.lastErrorMessage())")
                    }
                } catch {
                    rollback.memory = true
                    print(error)
                }
            })

        })
    }
    
    func deleteMoveFromBookmarks(titleMovieForRemove title: String) -> Void
    {
        let deleteMovieQuery = "DELETE FROM bookmarks WHERE title='\(title)'"
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            self.queue.inTransaction({ db, rollback -> Void in
                do {
                    try db.executeUpdate(deleteMovieQuery, values: nil)
                } catch {
                    rollback.memory = true
                    print(error)
                }
            })
        })
    }
    
//    func createTable() -> Void
//    {
////        self.db.closeOpenResultSets()
//        do {
//            try self.db.executeQuery(createTableQuery, values: nil)
//        } catch let error as NSError {
//            print("CANNOT CREATE TABLE: \(error.localizedDescription)")
//        }
//        print("LAST ERROR MESSAGE AFTER DROP TABLE\(self.db.lastErrorMessage())")
//
//    }
    
//    func dropTable() -> Void
//    {
////        self.db.closeOpenResultSets()
//        let dropTableSuccessful = self.db.executeQuery(dropTableQuery, withArgumentsInArray: nil)
//        if (dropTableSuccessful == nil) {
//            print("Drop 'found_movies' table failure: \(self.db.lastErrorMessage())")
//        }
//        print("LAST ERROR MESSAGE AFTER DROP TABLE\(self.db.lastErrorMessage())")
//    }
    
    deinit
    {
//        self.queue.close()
//        self.db.close()
    }

}

extension String {
    
    func stringByAppendingPathComponent(path: String) -> String {
        
        let nsSt = self as NSString
        
        return nsSt.stringByAppendingPathComponent(path)
    }
}
