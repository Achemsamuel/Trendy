//
//  MoviesTableViewController.swift
//  popular movies app
//
//  Created by Achem Samuel on 1/13/19.
//  Copyright © 2019 Achem Samuel. All rights reserved.
//

import UIKit

class MoviesTableViewController: UITableViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    //MARK: Variables *****************************************************************************
    
    var movieArray = ["Upcoming Movies", "Top Rated Movies", "Popular Movies", "Popular TV Shows", "Top Rated TV Shows", "Live TV Shows"]
    let tableCellIdentifier = "cell"
    let collectionCellIdentifier = "collectionCell"
    
    
    //Networking Variables
    var apiKey : String!
    let serviceUrl = "https://api.themoviedb.org/3"
    var baseUrl : String!
    var posterWidth = "w154"
    var moviesResult = MovieResult()
    let finalMovieUrl : String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        //Set up Api Call
        guard let path = Bundle.main.path(forResource: "MovieConfiguration", ofType: "plist"), let movieConfigDict = NSDictionary.init(contentsOfFile: path) else {
            print("Path/Movie configuration do not exist")
            return
        }
        apiKey = (movieConfigDict.value(forKey: "ApiKey") as! String)
        print("Api Key: \(apiKey!)")
        
        fetchConfigurations { (message) in
            print(message)
            
            self.fetchUpcomingMovies(onComplete: { (moviesJsonResult) in
                self.moviesResult.pageNum = moviesJsonResult.value(forKey: "page") as! Int
                self.moviesResult.totalPages = moviesJsonResult.value(forKey: "total_pages") as! Int
                self.moviesResult.totalResults = moviesJsonResult.value(forKey: "total_results") as! Int
                
                let moviesJsonArray = moviesJsonResult.value(forKey: "results") as! NSArray
                moviesJsonArray.forEach({ (movieJsonItem) in
                    
                    let  moviesJsonDictionary = movieJsonItem as! NSDictionary
                    let movieItem = MovieItem()
                    movieItem.movieId = moviesJsonDictionary.value(forKey: "id") as! Int
                    movieItem.movieTitle = moviesJsonDictionary.value(forKey: "original_title") as! String
                    movieItem.posterPath = moviesJsonDictionary.value(forKey: "poster_path") as! String
                    movieItem.releaseDate = moviesJsonDictionary.value(forKey: "release_date") as! String
                    
                    self.moviesResult.movieArray.append(movieItem)
                    print("Poster Path: \(movieItem.posterPath)")
                    
                    //Final URl
                    var finalUrl = self.baseUrl+self.posterWidth+movieItem.posterPath
                    finalUrl = self.finalMovieUrl
                    print("Final Url\(finalUrl)")
                    
                })
                
                print("Movie Results: \(self.moviesResult.totalPages)")
                
            }, onFailure: { (message) in
                print(message)
            })
        
        }
        
        
    }

    // MARK: - Table view data source **********************************************************************
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return movieArray.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableCellIdentifier, for: indexPath) as! MovieTableViewCell


        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return movieArray[section]
    }

    //MARK: Collection View Datasource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionCellIdentifier, for: indexPath) as! MovieCollectionViewCell
        
        return cell
    }
    

    
    //MARK: Networking ****************************************************************************
    
    func fetchConfigurations (onComplete: @escaping (_ message : String) -> ()) -> Void {
        
        let  configurationsUrl = "\(serviceUrl)/configuration?api_key=\(apiKey!)"
        print("Configurations Url: \(configurationsUrl)")
        
        var request = URLRequest.init(url: URL.init(string: configurationsUrl)!)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            if error != nil {
                print("Error: \(String(describing: error))")
                onComplete("Error: \(String(describing: error))")
            }
            else {
                let configurationsJson = try! JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                
                let imageDictionary = configurationsJson.value(forKey: "images") as! NSDictionary
                
                self.baseUrl = (imageDictionary.value(forKey: "secure_base_url") as! String)
                print("BaseUrl: \(String(describing: self.baseUrl!))")
                onComplete("BaseUrl: \(String(describing: self.baseUrl))")
                
            }
            
        }.resume()
        
    }
    
    func fetchUpcomingMovies (onComplete: @escaping (_ moviesResult :  NSDictionary) -> (), onFailure: @escaping (_ message : String)->()) -> Void {
        
        let moviesUrl = "\(serviceUrl)/movie/upcoming?api_key=\(apiKey!)&language=en-US&page=1"
        print("Movies Url: \(moviesUrl)")
        
        var request = URLRequest.init(url: URL.init(string: moviesUrl)!)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            if error != nil {
                print("Error: \(String(describing: error))")
                onFailure("Error: \(String(describing: error))")
            }
            else {
                let moviesResultJson = try! JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                
                onComplete(moviesResultJson)
                print("Movies Result Json: \(moviesResultJson)")
            }
            
        }.resume()
        
    }
    
    
    
}
