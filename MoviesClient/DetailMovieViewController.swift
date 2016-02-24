//
//  DetailMovieViewController.swift
//  MoviesClient
//
//  Created by Sergey Salnikov on 23.02.16.
//  Copyright © 2016 Sergey Salnikov. All rights reserved.
//

import UIKit

class DetailMovieViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var bookmarkMovie: BookmarkMovie?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.estimatedRowHeight = 200
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        self.tableView.registerNib(DetailMovieCell.nibCell(), forCellReuseIdentifier: DetailMovieCell.cellReuseIdentifier())
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier(DetailMovieCell.cellReuseIdentifier()) as! DetailMovieCell
        
        cell.titleLabel.text = self.bookmarkMovie?.title
        var timeGenreYearCountry = self.bookmarkMovie!.runtime!+" - "+self.bookmarkMovie!.genre!
        timeGenreYearCountry += " - "+self.bookmarkMovie!.year!+" - "+self.bookmarkMovie!.country!
        cell.timeGenreYearCountryLabel.text = timeGenreYearCountry
        cell.ratingLabel.text = "Rating: "+(self.bookmarkMovie?.imdbRating)!
        cell.directorLabel.text = "Director: "+(self.bookmarkMovie?.director)!
        cell.writersLabel.text = "Writers: "+(self.bookmarkMovie?.writer)!
        cell.typeMovieLabel.text = "Type: "+(self.bookmarkMovie?.type)!
        cell.plotLabel.text = "Description: "+(self.bookmarkMovie?.plot)!
        cell.posterImage.setImageWithURL(NSURL(string: (self.bookmarkMovie?.poster)!)!)
        
        return cell
    }
    

}/* End Class */
