//
//  BookmarksViewController.swift
//  MoviesClient
//
//  Created by Sergey Salnikov on 06.02.16.
//  Copyright © 2016 Sergey Salnikov. All rights reserved.
//

import UIKit

import AlamofireImage


class BookmarksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITabBarControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bookmarkNavigationBar: UINavigationBar!
    
    var bookmarksMovieArray = [BookmarkMovie]()
    var bookmarkMovie: BookmarkMovie? = nil
    var imdbIDArray = [String]()
    var isBookmarksExist: Bool = true
    
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
        
        self.tabBarController?.delegate = self
    
        tableView.registerNib(SearchViewCell.nibCell(), forCellReuseIdentifier: SearchViewCell.cellReuseIdentifier())
        tableView.registerNib(NotBookmarksViewCell.nibCell(), forCellReuseIdentifier: NotBookmarksViewCell.cellReuseIdentifier())
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: kCellIdentifier)
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)

        self.tableView.reloadData()

        for movie in self.bookmarksMovieArray {
            if !movie.isBookmarked {
                self.imdbIDArray.append(movie.imdbID)
            }
        }

        DatabaseManager.sharedInstance.getMovieBookmarks { (bookmarkMovieArray) -> Void in
            self.bookmarksMovieArray = bookmarkMovieArray
            if (bookmarkMovieArray.count == 0) {
                self.isBookmarksExist = false
            } else {
                self.isBookmarksExist = true
            }
            self.tableView.reloadData()
        }
    }
    
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool
    {
        let searchVC = self.tabBarController?.viewControllers![0] as! SearchMovieViewController
        searchVC.imdbIDDeleteArray = self.imdbIDArray
        return true
    }
    
// MARK: - UITableView -
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        self.bookmarkMovie = self.bookmarksMovieArray[indexPath.row]
        self.performSegueWithIdentifier("toDetailMovieVC", sender: self)
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        var numberOfRows = 0
        
        if !self.isBookmarksExist {
            numberOfRows = 1
        } else {
            numberOfRows = self.bookmarksMovieArray.count
        }
        
        return numberOfRows
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        var heightRow: CGFloat = 0.0
        
        if !self.isBookmarksExist {
            heightRow = self.tableView.frame.size.height
        } else {
            heightRow = UITableViewAutomaticDimension
        }
        
        return heightRow
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
        self.tableView.scrollEnabled = false
        var generalCell: UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier(kCellIdentifier)! as UITableViewCell
        
        if !self.isBookmarksExist {
            let notBookmarksCell = tableView.dequeueReusableCellWithIdentifier(NotBookmarksViewCell.cellReuseIdentifier()) as! NotBookmarksViewCell
            generalCell = notBookmarksCell
        } else {
            self.tableView.scrollEnabled = true
            let cell = tableView.dequeueReusableCellWithIdentifier(SearchViewCell.cellReuseIdentifier()) as! SearchViewCell
            let bookmarkMovie = self.bookmarksMovieArray[indexPath.row]
            var timeGenreYearCountry = bookmarkMovie.runtime!+" | "+bookmarkMovie.genre!
            timeGenreYearCountry += " | "+bookmarkMovie.year!+" | "+bookmarkMovie.country!
            
            cell.titleMovieLabel.text = bookmarkMovie.title
            cell.movieDescriptionLabel.text = bookmarkMovie.plot
            cell.countryDataLabel.text = timeGenreYearCountry
            cell.imageMovie.af_setImageWithURL(NSURL(string: bookmarkMovie.poster)!, placeholderImage: UIImage(named: "scientific15"), completion: { response -> Void in
            })
            
            generalCell = cell
        }
        generalCell.fixConstraints()
        
        return generalCell
    }
    
// MARK: - PrepareForSegue -
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if (segue.identifier == "toDetailMovieVC") {
            var vc = DetailMovieViewController()
            vc = segue.destinationViewController as! DetailMovieViewController
            vc.bookmarkMovie = self.bookmarkMovie
        }
    }
    
    override func prefersStatusBarHidden() -> Bool
    {
        return false
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle
    {
        return UIStatusBarStyle.LightContent
    }


}
