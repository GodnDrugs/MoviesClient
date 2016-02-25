//
//  BookmarksViewController.swift
//  MoviesClient
//
//  Created by Sergey Salnikov on 06.02.16.
//  Copyright © 2016 Sergey Salnikov. All rights reserved.
//

import UIKit

class BookmarksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var bookmarksMovieArray = Array<BookmarkMovie>()
    var bookmarkMovie: BookmarkMovie? = nil
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
//        DatabaseManager.sharedInstance.getMovieBookmarks { (bookmarkMovieArray) -> Void in
//            self.bookmarksMovieArray = bookmarkMovieArray
//            self.tableView.reloadData()
//            print("")
//        }
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 200
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None

        tableView.registerNib(BookmarkMovieViewCell.nibBookmarkCell(), forCellReuseIdentifier: BookmarkMovieViewCell.cellBookmarkReuseIdentifier())
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        DatabaseManager.sharedInstance.getMovieBookmarks { (bookmarkMovieArray) -> Void in
            self.bookmarksMovieArray = bookmarkMovieArray
            self.tableView.reloadData()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if (segue.identifier == "toDetailMovieVC") {
            var vc = DetailMovieViewController()
            vc = segue.destinationViewController as! DetailMovieViewController
            vc.bookmarkMovie = self.bookmarkMovie
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        self.bookmarkMovie = self.bookmarksMovieArray[indexPath.row]
        self.performSegueWithIdentifier("toDetailMovieVC", sender: self)
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.bookmarksMovieArray.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier(BookmarkMovieViewCell.cellBookmarkReuseIdentifier()) as! BookmarkMovieViewCell
        
        let bookmarkMovie = self.bookmarksMovieArray[indexPath.row]
        var timeGenreYearCountry = bookmarkMovie.runtime!+" - "+bookmarkMovie.genre!
        timeGenreYearCountry += " - "+bookmarkMovie.year!+" - "+bookmarkMovie.country!
        
        cell.titleLabel.text = bookmarkMovie.title
        cell.timeGenreYearCountryLabel.text = timeGenreYearCountry
        cell.directorLabel.text = "Director: "+bookmarkMovie.director!
        cell.ratingLabel.text = "Rating: "+bookmarkMovie.imdbRating!
        cell.writersLabel.text = "Director: "+bookmarkMovie.writer!
        cell.typeLabel.text = "Type: "+bookmarkMovie.type!
        cell.descriptionLabel.text = "Short description: "+bookmarkMovie.plot!

        return cell
    }

}
