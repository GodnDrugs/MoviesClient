//
//  SearchMovieViewController.swift
//  MoviesClient
//
//  Created by Sergey Salnikov on 05.02.16.
//  Copyright © 2016 Sergey Salnikov. All rights reserved.
//

import UIKit

import Alamofire
import ObjectMapper
import AlamofireImage

let selfIdentifier = "searchVC"
let systemVersion = UIDevice.currentDevice().systemVersion

class SearchMovieViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, MovieFactoryDelegate, UISearchControllerDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var notFoundMovieFlag: Bool = false
    var searchActive: Bool = false
    var imdbIDArray = [AnyObject]()
    var movie: FoundMovie?
    var bookmarkMovieToDetail: BookmarkMovie?
    var foundMovieToDetail: FoundMovie?
    var foundMovieArray = [FoundMovie]()
    var imdbIDDeleteArray = [String]()
    
    var onceToken: dispatch_once_t = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        MovieFactory.sharedInstance.delegate = self
        
        self.searchBar.resignFirstResponder()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.searchBar.delegate = self
        self.searchBar.tintColor = UIColor.blackColor()
        self.searchBar.placeholder = "Search..."
        self.searchBar.showsCancelButton = true
        self.searchBar.sizeToFit()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.view.endEditing(true)
        
        tableView.registerNib(SearchViewCell.nibSearchCell(), forCellReuseIdentifier: SearchViewCell.cellSearchReuseIdentifier())
        tableView.registerNib(NotFoundViewCell.nibCell(), forCellReuseIdentifier: NotFoundViewCell.cellReuseIdentifier())
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "GeneralCell")
    }

    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        var offSet = CGPoint()
        offSet = self.tableView.contentOffset
        self.tableView.reloadData()
        self.tableView.layoutIfNeeded()
        self.tableView.setContentOffset(offSet, animated: true)
        
        dispatch_once(&onceToken) { () -> Void in
            DatabaseManager.sharedInstance.loadPreviousSearchResult({ (previousSearchResultArray) -> Void in
                if previousSearchResultArray.count == 0 {
                    return
                }
                self.foundMovieArray = previousSearchResultArray
                self.tableView.reloadData()
            })
        }

    }
    

// MARK: - UISearchBar -
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar)
    {
        searchActive = false;
        self.searchBar.endEditing(true)
        self.view.endEditing(true)
        self.searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar)
    {
        self.searchBar.resignFirstResponder()
        self.searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String)
    {
        if (searchText.characters.count == 1 || searchText.characters.count == 0) {/*this code is sucked into outer space*/} else {

                MovieFactory.sharedInstance.collectorFoundMovie(searchString: searchText) { (foundMovieArray) -> Void in
                    self.foundMovieArray = foundMovieArray
                    self.notFoundMovieFlag = false
                    self.tableView.reloadData()
                    DatabaseManager.sharedInstance.saveSearchResult(resultToSave: foundMovieArray)
                    
            }
        }
        
    }
    
 // MARK: - UITableView -
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        var heightOfRow: CGFloat = 0.0
        
        if !self.notFoundMovieFlag {
            heightOfRow = UITableViewAutomaticDimension
        } else {
            heightOfRow = self.tableView.frame.size.height
        }
        
        return heightOfRow
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        var numberOfRows = self.foundMovieArray.count
        
        if self.notFoundMovieFlag {
            numberOfRows = 1
        }
        
        return numberOfRows
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var generalCell: UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("GeneralCell")! as UITableViewCell
        
        if !self.notFoundMovieFlag {
            let cellMovie = tableView.dequeueReusableCellWithIdentifier(SearchViewCell.cellSearchReuseIdentifier()) as! SearchViewCell
            
            let foundMovie = self.foundMovieArray[indexPath.row]
            
            if foundMovie.isBookmarked {
                cellMovie.bookmarkImageView.image = UIImage(named: "bookmarks")
            } else {
                cellMovie.bookmarkImageView.image = nil
            }
            
            if (self.imdbIDDeleteArray.count > 0) {
                for i in self.imdbIDDeleteArray {
                    if i == foundMovie.imdbID {
                        cellMovie.bookmarkImageView.image = nil
                        foundMovie.isBookmarked = false
                    }
                }
            }
            
            cellMovie.titleMovieLabel.text = foundMovie.title
            cellMovie.movieDescriptionLabel.text = foundMovie.plot
            cellMovie.countryDataLabel.text = foundMovie.country+" - "+foundMovie.year
            cellMovie.imageMovie.af_setImageWithURL(NSURL(string: foundMovie.poster)!, placeholderImage: UIImage(named: "scientific15"), completion: { response -> Void in
            })
            
            if systemVersion < "9.0" {
                cellMovie.updateConstraintsIfNeeded()
            }
            
            generalCell = cellMovie
        } else {
            self.tableView.scrollEnabled = false
            let cellNotFoundMovie = tableView.dequeueReusableCellWithIdentifier(NotFoundViewCell.cellReuseIdentifier()) as! NotFoundViewCell
            generalCell = cellNotFoundMovie
        }
        
        return generalCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let foundMovie = self.foundMovieArray[indexPath.row]
        self.foundMovieToDetail = self.foundMovieArray[indexPath.row]
        let movieID = foundMovie.imdbID
        
        MovieFactory.sharedInstance.collectorBookmarkMovie(bookmarkMovieID: movieID!) { (bookmarkMovie) -> Void in
            self.bookmarkMovieToDetail = bookmarkMovie
            self.performSegueWithIdentifier("toDetailMovieVC", sender: self)
        }
        
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if (segue.identifier == "toDetailMovieVC") {
            var vc = DetailMovieViewController()
            vc = segue.destinationViewController as! DetailMovieViewController
            vc.bookmarkMovie = self.bookmarkMovieToDetail
            vc.foundMovie = self.foundMovieToDetail
            vc.checkViewController = selfIdentifier
        }
    }

    func responseFalseNotification()
    {
        self.notFoundMovieFlag = true
        self.tableView.reloadData()
    }
    
    override func prefersStatusBarHidden() -> Bool
    {
        return false
    }

}





