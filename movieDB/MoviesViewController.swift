//
//  MoviesViewController.swift
//  movieDB
//
//  Created by Pushpinder Jaswal on 7/14/16.
//  Copyright © 2016 Pushpinder Jaswal. All rights reserved.
//

import UIKit
import AFNetworking

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var moviesTableView: UITableView!
    
    var movies : [NSDictionary]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        moviesTableView.dataSource = self
        moviesTableView.delegate = self
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: nil, delegateQueue: NSOperationQueue.mainQueue())
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: {(dataOrNil, response, error) in
                if let data  = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options: []) as? NSDictionary{
                            print("response: \(responseDictionary)")
                        if let results = responseDictionary["results"]{
                                self.movies = results as? [NSDictionary]
                        }
                    }
                    self.moviesTableView.reloadData()
                }
        });
        task.resume()
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if let movies = movies {
            return movies.count
        }else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = moviesTableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MoviesTableViewCell
//        cell.textLabel?.text = "row \(indexPath.row)"
//        print("row \(indexPath.row)")
        
        let moviesData = movies![indexPath.row]
        let originalTitle = moviesData["original_title"] as! String
        let overview = moviesData["overview"] as! String
        let baseUrl = "http://image.tmdb.org/t/p/w500"
        let posterPath = moviesData["poster_path"] as! String
        let imageUrl = NSURL(string: baseUrl + posterPath)
        
        //let url = NSURL(string:moviesData["image_permalink"] as! String)
        
        cell.titleLabel.text = originalTitle
        cell.overviewLabel.text = overview
        cell.dpImage.setImageWithURL(imageUrl!)
        
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
