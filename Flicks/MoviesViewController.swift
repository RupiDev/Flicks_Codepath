//
//  MoviesViewController.swift
//  Flicks
//
//  Created by Rupin Bhalla on 1/10/16.
//  Copyright © 2016 Rupin Bhalla. All rights reserved.
//

import UIKit
import AFNetworking
import EZLoadingActivity

class MoviesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate
{
    

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    

    
    
    
    
    //@IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var networkErrorLabel: UILabel!
    
    var movies : [NSDictionary]?
    var refreshControl: UIRefreshControl!
    

    
    /*override func viewDidAppear(animated: Bool)
    {
        
        EZLoadingActivity.showWithDelay("Loading...", disableUI: false, seconds: 1)
    }*/
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl();
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        collectionView.insertSubview(refreshControl, atIndex: 0)
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string:"https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if(error != nil)
                {
                    print("error")
                    self.collectionView.alpha = 0;
                    self.networkErrorLabel.alpha = 1;
                    self.networkErrorLabel.text = "Network Error"
                }
                
                else if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            NSLog("response: \(responseDictionary)")
                            
                            self.movies = responseDictionary["results"] as! [NSDictionary]
                            
                            self.collectionView.reloadData();
                            
                            
                            
                            
                            
                    }
                    
                }
                
        });
        task.resume()

     
    }
    
    func delay(delay:Double, closure:()->())
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
    }
    
    func onRefresh()
    {
        delay(2, closure: {
            self.refreshControl.endRefreshing()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if let movies = movies
        {
            return movies.count;
        }
        else
        {
            return 0;
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCollectionViewCell
        
        let movie = movies![indexPath.row]
        
        
        
        
    
        
        //let title = movie["title"] as! String
    
        
        //let overview = movie["overview"] as! String
        
        let baseUrl = "http://image.tmdb.org/t/p/w500"
        let posterPath = movie["poster_path"] as! String;
        
        let imageUrl = NSURL(string: baseUrl + posterPath)
        
        
        //cell.titleLabel.text = title;
        //cell.overviewLabel.text = overview
        cell.moviePic.setImageWithURL(imageUrl!)
        
                
        return cell;

    }
    
    /*func searchBar(searchBar: UISearchBar, textDidChange searchText: String)
    {
        filteredData = searchText.isEmpty ? data : data.filter({(dataString: String) -> Bool in
            return dataString.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
        })
        
        collectionView.reloadData()
    }*/
    
    
    
    /*func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if let movies = movies
        {
            return movies.count;
        }
        else
        {
            return 0;
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        //let cell = collectionView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCollectionViewCell
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCollectionViewCell
        
        let movie = movies![indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        
        let baseUrl = "http://image.tmdb.org/t/p/w500"
        let posterPath = movie["poster_path"] as! String;
        
        let imageUrl = NSURL(string: baseUrl + posterPath)
        
        
        //cell.titleLabel.text = title;
        //cell.overviewLabel.text = overview
        cell.moviePic.setImageWithURL(imageUrl!)
        
        
        return cell;
        
    }*/
    


}
