//
//  BookmarksViewController.swift
//  MoviesClient
//
//  Created by Sergey Salnikov on 06.02.16.
//  Copyright © 2016 Sergey Salnikov. All rights reserved.
//

import UIKit

import AlamofireImage


class BookmarksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bookmarkNavigationBar: UINavigationBar!
    
    var bookmarksMovieArray = [BookmarkMovie]()
    var bookmarkMovie: BookmarkMovie? = nil
    
    var itemHeights = [CGFloat](count: 1000, repeatedValue: UITableViewAutomaticDimension)
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.bookmarkNavigationBar.topItem?.title = "Bookmarked"
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
    
        tableView.registerNib(SearchViewCell.nibSearchCell(), forCellReuseIdentifier: SearchViewCell.cellSearchReuseIdentifier())
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.tableView.reloadData()

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
    
// MARK: - UITableView -
    
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

    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath)
    {
        if itemHeights[indexPath.row] == UITableViewAutomaticDimension {
            itemHeights[indexPath.row] = cell.bounds.height
        }
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return itemHeights[indexPath.row]
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier(SearchViewCell.cellSearchReuseIdentifier()) as! SearchViewCell
        let bookmarkMovie = self.bookmarksMovieArray[indexPath.row]
        var timeGenreYearCountry = bookmarkMovie.runtime!+" - "+bookmarkMovie.genre!
        timeGenreYearCountry += " - "+bookmarkMovie.year!+" - "+bookmarkMovie.country!
        
        cell.titleMovieLabel.text = bookmarkMovie.title
        cell.movieDescriptionLabel.text = bookmarkMovie.plot
        cell.countryDataLabel.text = timeGenreYearCountry
        cell.imageMovie.af_setImageWithURL(NSURL(string: bookmarkMovie.poster)!, placeholderImage: UIImage(named: "scientific15"), completion: { response -> Void in
            })

        return cell
    }
    
    override func prefersStatusBarHidden() -> Bool
    {
        return false
    }

}
