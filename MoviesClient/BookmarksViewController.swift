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
    var testArray = Array<String>()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 200
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None

        tableView.registerNib(BookmarkMovieViewCell.nibBookmarkCell(), forCellReuseIdentifier: BookmarkMovieViewCell.cellBookmarkReuseIdentifier())
        
        for i in self.testArray {
            print(i)
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 2
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
//        let testString = "Такой код как ни странно выведет в консоль 100 вместо 30. Ладно, здесь мы видим, что создан был все таки квадрат, а затем использован в качестве прямоугольника. А если использование объекта класса Rectangle будет совсем не в том месте, где объект был создан? Скажем, пропущенный через несколько вызовов нескольких классов?"
//        cell.titleLabel.text = testString
//        cell.timeGenreYearCountryLabel.text = testString
//        cell.ratingLabel.text = testString
//        cell.writersLabel.text = testString
//        cell.typeLabel.text = testString
//        cell.descriptionLabel.text = testString

        return cell
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue
    (segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
