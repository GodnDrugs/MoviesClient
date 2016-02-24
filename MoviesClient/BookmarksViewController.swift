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

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 200
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None

        tableView.registerNib(BookmarkMovieViewCell.nibBookmarkCell(), forCellReuseIdentifier: BookmarkMovieViewCell.cellBookmarkReuseIdentifier())
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.bookmarksMovieArray.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
//    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
//    {
//        return UITableViewAutomaticDimension
//    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier(BookmarkMovieViewCell.cellBookmarkReuseIdentifier()) as! BookmarkMovieViewCell
        
        let bookmarkMovie = self.bookmarksMovieArray[indexPath.row]
//        let testString = "Такой код как ни странно выведет в консоль 100 вместо 30. Ладно, здесь мы видим, что создан был все таки квадрат, а затем использован в качестве прямоугольника. А если использование объекта класса Rectangle будет совсем не в том месте, где объект был создан? Скажем, пропущенный через несколько вызовов нескольких классов?"
        cell.titleLabel.text = bookmarkMovie.title
        var timeGenreYearCountry = bookmarkMovie.runtime!+" - "+bookmarkMovie.genre!
        timeGenreYearCountry += " - "+bookmarkMovie.year!+" - "+bookmarkMovie.country!
        cell.timeGenreYearCountryLabel.text = timeGenreYearCountry
        cell.directorLabel.text = "Director: "+bookmarkMovie.director!
        cell.ratingLabel.text = "Rating: "+bookmarkMovie.imdbRating!
        cell.writersLabel.text = "Director: "+bookmarkMovie.writer!
        cell.typeLabel.text = "Type: "+bookmarkMovie.type!
        cell.descriptionLabel.text = "Short description: "+bookmarkMovie.plot!

        return cell
    }

}
