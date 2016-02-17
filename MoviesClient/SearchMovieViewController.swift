//
//  ViewController.swift
//  MoviesClient
//
//  Created by Sergey Salnikov on 05.02.16.
//  Copyright © 2016 Sergey Salnikov. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import AFNetworking

class SearchMovieViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var searchActive : Bool = false
    var data = ["San Francisco","New York","San Jose","Chicago","Los Angeles","Austin","Seattle"]
    var filtered: [String] = []

    var imdbIDArray = Array<AnyObject>()
    var movie:FoundMovie?
    var bookmarksMovieArray = Array<BookmarkMovie>()
    var foundMovieArray: [FoundMovie] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
//        tableView.estimatedRowHeight = 200.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        searchBar.delegate = self
        
        let nib = UINib(nibName: "SearchTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier:"cell")

        FactoryFoundMovie.sharedInstance.collectorIdFoundMovieBySearch { (foundMovieArray) -> Void in
            self.foundMovieArray = foundMovieArray
            self.tableView.reloadData()
        }
        
    }

    override func viewDidAppear(animated: Bool)
    {
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar)
    {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar)
    {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar)
    {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar)
    {
        searchActive = false;
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String)
    {
        print("Search Text: \(searchText)")
        filtered = data.filter({ (text) -> Bool in
            
            let tmp: NSString = text
            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            
            return range.location != NSNotFound
        })
        
        if (filtered.count == 0) {
            searchActive = false;
        } else {
            searchActive = true;
        }
        
        self.tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
//        if (searchActive) {
//            return filtered.count
//        }
        
        return self.foundMovieArray.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
//        tableView.registerClass(SearchTableViewCell.self, forCellReuseIdentifier: "cell")
        let stringTest1 = "The first line of code sets the estimated row height of the cell, which is the height of the existing prototype cell."
        let stringTest2 = "The first line of code sets the estimated row height of the cell, which is the height of the existing prototype cell. The second line changes the rowHeight property to UITableViewAutomaticDimension, which is the default row height in iOS 8. In other words, you tell table view to figure out the cell size based on other information.If you test the app, the cell is still not resized. The reason is that both name and address labels are set to 1-line. So set the number of lines to zero and let the label grow automatically."
        let stringTest3 = "USA - 1995"
        let cell: SearchTableViewCell = tableView.dequeueReusableCellWithIdentifier("cell") as! SearchTableViewCell
        let foundMovie: FoundMovie = self.foundMovieArray[indexPath.row]
        cell.titleMovieLabel.text = foundMovie.title
        cell.movieDescriptionLabel.text = foundMovie.plot
        cell.countryDataLabel.text = foundMovie.country+" - "+foundMovie.year
        cell.imageMovie.setImageWithURL(NSURL(string: foundMovie.poster)!)

//        if (searchActive) {
//            cell.textLabel?.text = filtered[indexPath.row]
//        } else {
//            cell.textLabel?.text = data[indexPath.row];
//        }
        
        return cell;
    }

}



