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
import AFNetworking


class SearchMovieViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, MovieFactoryDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var searchActive : Bool = false

    var imdbIDArray = Array<AnyObject>()
    var movie: FoundMovie?
    var bookmarkMovie: BookmarkMovie?
    var movieForDisplay = Array<AnyObject>()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
//       DatabaseManager.sharedInstance.getLastSearchResult({ (resultFoundMovie) -> Void in
//        self.movieForDisplay = resultFoundMovie
//        self.tableView.reloadData()
//       })
        
        MovieFactory.sharedInstance.delegate = self
        
        self.searchBar.resignFirstResponder()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        searchBar.delegate = self
        
//        self.tabBarController?.delegate = self
        
        self.view.endEditing(true)
        
        tableView.registerNib(SearchViewCell.nibSearchCell(), forCellReuseIdentifier: SearchViewCell.cellSearchReuseIdentifier())
    }
    
//    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
//        print("")
//    }

    
//    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
//        if (viewController .isKindOfClass(BookmarksViewController)) {
//            let bookmarkVC = self.tabBarController?.viewControllers![1] as? BookmarksViewController
//            bookmarkVC?.bookmarksMovieArray = self.bookmarksMovieArray
//            print("")
//        }
//        
//        return true
//    }
    
    
//    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
//    {
//        searchActive = false;
////        self.searchBar.endEditing(true)
//    }
//    
//    func searchBarTextDidBeginEditing(searchBar: UISearchBar)
//    {
//        searchActive = true;
//    }
//    
//    func searchBarTextDidEndEditing(searchBar: UISearchBar)
//    {
//        searchActive = false;
//    }
//    
//    func searchBarCancelButtonClicked(searchBar: UISearchBar)
//    {
//        searchActive = false;
//    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar)
    {
        searchActive = false;
        self.searchBar.endEditing(true)
        self.view.endEditing(true)
        self.searchBar.resignFirstResponder()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String)
    {
        print(searchText)
        
        if (searchText.characters.count == 1 || searchText.characters.count == 0) { /* I love fuck animal! */ } else {
            
            let regexExpression = ".*[^A-Za-z0-9].*"
            let predicat = NSPredicate(format:"SELF MATCHES %@", regexExpression)
            let result = predicat.evaluateWithObject(searchText)
            
            if (result) {
                
                self.showValidateError()
                
            } else {
                
                MovieFactory.sharedInstance.collectorFoundMovie(searchString: searchText) { (foundMovieArray) -> Void in
                    self.movieForDisplay = foundMovieArray
                    self.tableView.reloadData()
                    DatabaseManager.sharedInstance.saveSearchResult(resultToSave: foundMovieArray)
                    
                }
            }
        }
        
    }
//    
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
//    {
//        return UITableViewAutomaticDimension
//    }
    
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
        return self.movieForDisplay.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier(SearchViewCell.cellSearchReuseIdentifier()) as! SearchViewCell
        let foundMovie = self.movieForDisplay[indexPath.row]
        
        if foundMovie .isKindOfClass(ResultFoundMovie) {
            
//            let cellDisplayResultSearch = tableView.dequeueReusableCellWithIdentifier(SearchViewCell.cellSearchReuseIdentifier()) as! SearchViewCell

            let movie = foundMovie as! ResultFoundMovie
            
            cell.titleMovieLabel.text = foundMovie.title
            cell.movieDescriptionLabel.text = movie.plot
            cell.countryDataLabel.text = movie.country!+" - "+movie.year!
            cell.imageMovie.setImageWithURL(NSURL(string: movie.poster!)!)
            
//            cell = cellDisplayResultSearch
            
        } else {
            
//            let cellDisplayFoundMovie = tableView.dequeueReusableCellWithIdentifier(SearchViewCell.cellSearchReuseIdentifier()) as! SearchViewCell
            
            let movie = foundMovie as! FoundMovie
            
            cell.titleMovieLabel.text = movie.title
            cell.movieDescriptionLabel.text = movie.plot
            cell.countryDataLabel.text = movie.country!+" - "+movie.year!
            cell.imageMovie.setImageWithURL(NSURL(string: movie.poster!)!)
            print("")
            
//            cell = cellDisplayFoundMovie
        }

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let foundMovie = self.movieForDisplay[indexPath.row] as! FoundMovie
        let movieID = foundMovie.id
        
        MovieFactory.sharedInstance.collectorBookmarkMovie(bookmarkMovieID: movieID!) { (bookmarkMovie) -> Void in
            self.bookmarkMovie = bookmarkMovie
            print("")
            self.performSegueWithIdentifier("toDetailMovieVC", sender: self)
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "toDetailMovieVC") {
            var vc = DetailMovieViewController()
            vc = segue.destinationViewController as! DetailMovieViewController
            vc.bookmarkMovie = self.bookmarkMovie
        }
    }
    
    func showSearchError(movieTitle title: String)
    {
        let alertController = UIAlertController(title: "Ошибка ввода!", message: "Фильм "+title+" не найден", preferredStyle: .Alert)
        let actionOk = UIAlertAction(title: "Повторить ввод", style: .Default) { (action) in
            self.searchBar.text?.removeAll()
        }
        alertController.addAction(actionOk)
        self.presentViewController(alertController, animated: true) { () -> Void in }
    }
    
    func showValidateError()
    {
        let alertController = UIAlertController(title: "Ошибка ввода!", message: "Строка должна содержать только символы латинского алфавита", preferredStyle: .Alert)
        let actionOk = UIAlertAction(title: "Повторить ввод", style: .Default) { (action) in
            self.searchBar.text?.removeAll()
        }
        alertController.addAction(actionOk)
        self.presentViewController(alertController, animated: true) { () -> Void in }
        
    }

}



