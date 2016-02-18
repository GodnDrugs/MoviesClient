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
    var bookmarksMovieArray = Array<BookmarkMovie>()
    var foundMovieArray = Array<FoundMovie>()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        MovieFactory.sharedInstance.delegate = self
        
        self.searchBar.resignFirstResponder()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        searchBar.delegate = self
        
        self.view.endEditing(true)
        
        tableView.registerNib(SearchTableViewCell.nibSearchCell(), forCellReuseIdentifier: SearchTableViewCell.cellSearchReuseIdentifier())
    }
    
    
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
        
        if (searchText.characters.count == 1 || searchText.characters.count == 0) { /*I love fuck animal!*/ } else {
            
            let regexExpression = ".*[^A-Za-z0-9].*"
            let predicat = NSPredicate(format:"SELF MATCHES %@", regexExpression)
            let result = predicat.evaluateWithObject(searchText)
            
            if (result) {
                
                self.showValidateError()
                
            } else {
                
                MovieFactory.sharedInstance.collectorIdFoundMovieBySearch(searchString: searchText) { (foundMovieArray) -> Void in
                    self.foundMovieArray = foundMovieArray
                    self.tableView.reloadData()
                    
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
        return self.foundMovieArray.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier(SearchTableViewCell.cellSearchReuseIdentifier()) as! SearchTableViewCell
        let foundMovie: FoundMovie = self.foundMovieArray[indexPath.row]
        cell.titleMovieLabel.text = foundMovie.title
        cell.movieDescriptionLabel.text = foundMovie.plot
        cell.countryDataLabel.text = foundMovie.country+" - "+foundMovie.year
        cell.imageMovie.setImageWithURL(NSURL(string: foundMovie.poster)!)
        
        return cell;
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



