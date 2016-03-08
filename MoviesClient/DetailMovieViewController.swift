//
//  DetailMovieViewController.swift
//  MoviesClient
//
//  Created by Sergey Salnikov on 23.02.16.
//  Copyright © 2016 Sergey Salnikov. All rights reserved.
//

import UIKit

import Social
import MessageUI
import AlamofireImage


let searchIdentifierVC = "searchVC"
let bookmarkIdentifierVC = "bookmarkVC"

class DetailMovieViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate, UINavigationControllerDelegate, DetailMovieCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var detailNavigationBar: UINavigationBar!
    
    var checkViewController = String()
    var bookmarkMovie: BookmarkMovie?
    var foundMovie: FoundMovie?
    var itemHeights = [CGFloat](count: 1000, repeatedValue: UITableViewAutomaticDimension)

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.detailNavigationBar.topItem?.title = self.bookmarkMovie?.title
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        

        self.tableView.estimatedRowHeight = 200
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        self.tableView.registerNib(DetailMovieCell.nibCell(), forCellReuseIdentifier: DetailMovieCell.cellReuseIdentifier())
        self.title = bookmarkMovie?.title
        self.tableView.reloadData()

    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.tableView.reloadData()
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
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat
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
        
        if (checkViewController == searchIdentifierVC) {
            if ((self.foundMovie?.isBookmarked) != true) {
                cell.bookmarkImage.image = nil
            } else {
                cell.bookmarkImage.image = UIImage(named: "bookmarks")
            }
            
            if (self.foundMovie?.bookmarked == "true") {
                cell.bookmarkImage.image = UIImage(named: "bookmarks")
            } else {
                cell.bookmarkImage.image = nil
            }
        } else {
            cell.bookmarkImage.image = UIImage(named: "bookmarks")
        }

        cell.titleLabel.text = self.bookmarkMovie?.title
        var timeGenreYearCountry = self.bookmarkMovie!.runtime!+" | "+self.bookmarkMovie!.genre!
        timeGenreYearCountry += " | "+self.bookmarkMovie!.year!+" | "+self.bookmarkMovie!.country!
        cell.timeGenreYearCountryLabel.text = timeGenreYearCountry
        cell.ratingLabel.text = "Rating: "+(self.bookmarkMovie?.imdbRating)!
        cell.directorLabel.text = "Director: "+(self.bookmarkMovie?.director)!
        cell.writersLabel.text = "Writers: "+(self.bookmarkMovie?.writer)!
        cell.typeMovieLabel.text = "Type: "+(self.bookmarkMovie?.type)!
        cell.plotLabel.text = "Description: "+(self.bookmarkMovie?.plot)!
        cell.posterImage.af_setImageWithURL(NSURL(string: (self.bookmarkMovie?.poster)!)!, placeholderImage: UIImage(named: "scientific15"), completion: { response -> Void in
        })
    
        cell.posterImage.image = scaleImage(cell.posterImage.image!, newSize: CGSizeMake(300.0, 450.0))
        
        cell.delegate = self
        cell.fixConstraints()
//        if systemVersion < "9.0" {
//            cell.updateConstraintsIfNeeded()
//        }

        return cell
    }
    
    func scaleImage(image: UIImage, newSize: CGSize) -> UIImage
    {
        UIGraphicsBeginImageContext(newSize)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    @IBAction func backButton(sender: AnyObject)
    {
        self.dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }

    @IBAction func showActionSheet(sender: AnyObject)
    {
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .ActionSheet)
        optionMenu.view.tintColor = UIColor.brownColor()
        
        let shareToTwitter = UIAlertAction(title: "Twitter share", style: .Default) {
            (alert: UIAlertAction!) -> Void in
            let shareToTwitter : SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            self.presentViewController(shareToTwitter, animated: true, completion: nil)
        }
        
        let shareToFacebook = UIAlertAction(title: "Facebook share", style: .Default) {
            (alert: UIAlertAction!) -> Void in
            let shareToTwitter : SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            self.presentViewController(shareToTwitter, animated: true, completion: nil)
        }
        
        let emailAction = UIAlertAction(title: "Email share", style: .Default) {
            (alert: UIAlertAction!) -> Void in
            self.presentModalMailComposeViewController(true)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) {
            (alert: UIAlertAction!) -> Void in
            //Code
        }
        
        optionMenu.addAction(shareToTwitter)
        optionMenu.addAction(shareToFacebook)
        optionMenu.addAction(emailAction)
        optionMenu.addAction(cancelAction)
        
        if (checkViewController == searchIdentifierVC) {
            if ((self.foundMovie?.isBookmarked) == true || self.foundMovie?.bookmarked == "true") {
                optionMenu.addAction(self.deleteFromBookmarksAlert())
            } else {
                optionMenu.addAction(self.addToBookmarksAlert())
            }
        } else {
            optionMenu.addAction(self.deleteFromBookmarksAlert())
        }

        self.presentViewController(optionMenu, animated: true, completion: nil)
        
    }
    
    func presentModalMailComposeViewController(animated: Bool)
    {
        let emailTitle = "Test Email"
        let messageBody = "iOS programming is so fun!"
        let toRecipents = ["support@appcoda.com"]
        
        let mc = MFMailComposeViewController()
        mc.mailComposeDelegate = self
        mc.setSubject(emailTitle)
        mc.setMessageBody(messageBody, isHTML: false)
        mc.setToRecipients(toRecipents)
        
        self.presentViewController(mc, animated: true) { () -> Void in
            
        }

    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        
        if error != nil {
            print("Error: \(error)")
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func addToBookmarksAlert() -> UIAlertAction
    {
        let addBookmarkAction = UIAlertAction(title: "Add to Bookmarks", style: .Default) {
            (alert: UIAlertAction!) -> Void in
            print("")
            DatabaseManager.sharedInstance.addMovieToBookmarks(addToBookmarks: self.bookmarkMovie!)
            DatabaseManager.sharedInstance.markAddedToBookmarks(imdbID: (self.foundMovie?.imdbID)!, isBookmark: "true")
            self.foundMovie?.bookmarked = "true"
            self.foundMovie?.isBookmarked = true
            self.tableView.reloadData()
        }
        
        return addBookmarkAction
    }
    
    func deleteFromBookmarksAlert() -> UIAlertAction
    {

        
        let removeBookmarkAction = UIAlertAction(title: "Remove from Bookmarks", style: .Default) {
            (alert: UIAlertAction!) -> Void in
            DatabaseManager.sharedInstance.deleteMoveFromBookmarks(titleMovieForRemove: (self.bookmarkMovie?.title)!)
            self.foundMovie?.isBookmarked = false
            self.foundMovie?.bookmarked = "false"
            if self.foundMovie == nil {
                DatabaseManager.sharedInstance.unmark(imdbID: (self.bookmarkMovie?.imdbID)!, isBookmark: "false")
            } else {
                DatabaseManager.sharedInstance.unmark(imdbID: (self.foundMovie?.imdbID)!, isBookmark: "false")
            }
            self.bookmarkMovie?.isBookmarked = false
            self.tableView.reloadData()
        }

        return removeBookmarkAction
    }
    
    override func prefersStatusBarHidden() -> Bool
    {
        return false
    }
    
    func showDetailPosterScreen()
    {
        self.performSegueWithIdentifier("toDetailPosterVC", sender: self)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if (segue.identifier == "toDetailPosterVC") {
            var vc = DetailPosterViewController()
            vc = segue.destinationViewController as! DetailPosterViewController
            vc.posterImageURL = self.bookmarkMovie?.poster
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle
    {
        return UIStatusBarStyle.LightContent
    }


}/* End Class */
