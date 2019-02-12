//
//  MoviesTableViewController.swift
//  popular movies app
//
//  Created by Achem Samuel on 1/13/19.
//  Copyright © 2019 Achem Samuel. All rights reserved.
//

import UIKit
import Kingfisher

class MoviesTableViewController: UITableViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
 
    
    //MARK: Variables *****************************************************************************
    
    var movieArray = ["Upcoming Movies", "Top Rated Movies", "Popular Movies", "Trending Movies", "Live TV Shows", "Top Rated TV Shows"]
    
    //Upcoming
    let tableCellIdentifier = "cell"
    let collectionCellIdentifier = "collectionCell"
    
    
    //Top Rated
    let topRatedCellIdentifier = "topRatedCell"
    let topCollectionCell = "topRatedCollectionCell"
    
    
    //Popular
    let popularCell = "popularCell"
    let popularCollecionCell = "popularCollectionCell"
    
    //PopularTV
    let popularTVCell = "popularTVCell"
    let popularTVCollectionCell = "popularTVCollectionCell"
    
    //LiveTV
    let liveTVCell = "liveTVCell"
    let liveCollectionCell = "liveTVCollectionCell"
    
    //topTV
    let topTVCell = "topTVCell"
    let topTVCollectionCell = "topTVCollectionCell"
    
    
    
    //Networking Variables
    var apiKey : String!
    let serviceUrl = "https://api.themoviedb.org/3"
    var baseUrl : String!
    var posterWidth = "w154"
    var moviesResult = MovieResult()
    var finalMovieUrl : String = ""
    let imagesUrl = "image.tmdb.org/t/p/"
    var movieTitle : String = ""

  
    @IBAction func refreshButton(_ sender: Any) {
        
       // tableView.setNeedsDisplay()
        tableView.reloadData()
    }
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
        
        getResult()
        
        
        tableView.reloadData()
        
    }
    
      ///////////////////////////////////////////////////////////////////////
    
    
    //Set Configuration & Append Results To Model
    
    func getResult() {
        
        fetchConfigurations { (message) in
            print(message)
            
            ///////////////////////////////////////////////////////////////////////
                                                                                //Upcoming Movies
            ///////////////////////////////////////////////////////////////////////
            
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
                    
                    
                })
                
                print("Movie Results: \(self.moviesResult.totalPages)")
                
            }, onFailure: { (message) in
                print(message)
            })
            
              ///////////////////////////////////////////////////////////////////////
                                                                                        //Top Rated
              ///////////////////////////////////////////////////////////////////////
            
            self.fetchTopRatedMovies(onComplete: { (topMoviesJsonResult) in
                
                self.moviesResult.pageNum = topMoviesJsonResult.value(forKey: "page") as! Int
                self.moviesResult.totalPages = topMoviesJsonResult.value(forKey: "total_pages") as! Int
                self.moviesResult.totalResults = topMoviesJsonResult.value(forKey: "total_results") as! Int
                
                let topMoviesJsonArray = topMoviesJsonResult.value(forKey: "results") as! NSArray
                topMoviesJsonArray.forEach({ (topMoviesJsonItem) in
                    
                    let topMoviesJsonDictionary = topMoviesJsonItem as! NSDictionary
                    let topMovieItem = MovieItem()
                    
                    topMovieItem.movieId = topMoviesJsonDictionary.value(forKey: "id") as! Int
                    topMovieItem.movieTitle = topMoviesJsonDictionary.value(forKey: "original_title") as! String
                    topMovieItem.posterPath = topMoviesJsonDictionary.value(forKey: "poster_path") as! String
                    topMovieItem.releaseDate = topMoviesJsonDictionary.value(forKey: "release_date") as! String
                    
                    self.moviesResult.topMovieArray.append(topMovieItem)
                    print("Top PosterPath: \(topMovieItem.posterPath)")
        
                    
                })
                
                print("Top Movies Results: \(self.moviesResult.totalPages)")
               
            }, onFailure: { (message) in
                print("Top Error: \(message)")
            })
            
              ///////////////////////////////////////////////////////////////////////
                                                                    //Popular TV SHows
              ///////////////////////////////////////////////////////////////////////
            
            self.fetchTrendingMovies(onComplete: { (trendingMoviesJsonResult) in
                
                self.moviesResult.pageNum = trendingMoviesJsonResult.value(forKey: "page") as! Int
                self.moviesResult.totalPages = trendingMoviesJsonResult.value(forKey: "total_pages") as! Int
                self.moviesResult.totalResults = trendingMoviesJsonResult.value(forKey: "total_results") as! Int
                
                let trendingMoviesJsonArray = trendingMoviesJsonResult.value(forKey: "results") as! NSArray
                trendingMoviesJsonArray.forEach({ (trendingMoviesJsonItem) in
                    
                    let trendingMoviesJsonDictionary = trendingMoviesJsonItem as! NSDictionary
                    let trendingMoviesItem = MovieItem()
                    
                    trendingMoviesItem.movieId = trendingMoviesJsonDictionary.value(forKey: "id") as! Int
                   // trendingMoviesItem.movieTitle = trendingMoviesJsonDictionary.value(forKey: "original_title") as! String
                    trendingMoviesItem.posterPath = trendingMoviesJsonDictionary.value(forKey: "poster_path") as! String
                    //trendingMoviesItem.releaseDate = trendingMoviesJsonDictionary.value(forKey: "release_date") as! String
                    
                    self.moviesResult.trendingMoviesArray.append(trendingMoviesItem)
                    print("Popular TV Poster: \(trendingMoviesItem.posterPath)")
                    
                })
                
                print("Popular TV Count: \(self.moviesResult.trendingMoviesArray.count)")
               
                ////////////////////
                DispatchQueue.main.async {
                       self.tableView.reloadData()
                }
                ///////////////////
            
                
            }, onFailure: { (message) in
                print("Failed to get Popular Movies \(message)")
            })
            
              ///////////////////////////////////////////////////////////////////////
                                                                    //Popular Movies
              ///////////////////////////////////////////////////////////////////////
            
            
            self.fetchPopularMovies(onComplete: { (popularMoviesJsonResult) in
                
                self.moviesResult.pageNum = popularMoviesJsonResult.value(forKey: "page") as! Int
                self.moviesResult.totalPages = popularMoviesJsonResult.value(forKey: "total_pages") as! Int
                self.moviesResult.totalResults = popularMoviesJsonResult.value(forKey: "total_results") as! Int
                
                let popularMoviesJsonArray = popularMoviesJsonResult.value(forKey: "results") as! NSArray
                popularMoviesJsonArray.forEach({ (popularMoviesJsonItem) in
                    
                    let popularMoviesJsonDictionary = popularMoviesJsonItem as! NSDictionary
                    let popularMoviesItem = MovieItem()
                    
                    popularMoviesItem.movieId = popularMoviesJsonDictionary.value(forKey: "id") as! Int
                    popularMoviesItem.movieTitle = popularMoviesJsonDictionary.value(forKey: "original_title") as! String
                    popularMoviesItem.posterPath = popularMoviesJsonDictionary.value(forKey: "poster_path") as! String
                    popularMoviesItem.releaseDate = popularMoviesJsonDictionary.value(forKey: "release_date") as! String
                    
                    self.moviesResult.popularMovieArray.append(popularMoviesItem)
                    print("Popular Poster: \(popularMoviesItem.posterPath)")
                    
                    
                })
                
                print("Popular Movies Result: \(self.moviesResult.totalPages)")
                
                
            }, onFailure: { (message) in
                print("Failure : \(message)")
            })
            
            ///////////////////////////////////////////////////////////////////////
                                                                                //Live TV Shows
            ///////////////////////////////////////////////////////////////////////
         
            
            self.fetchLiveTV(onComplete: { (liveTVJsonResult) in

                self.moviesResult.pageNum = liveTVJsonResult.value(forKey: "page") as! Int
                self.moviesResult.totalPages = liveTVJsonResult.value(forKey: "total_pages") as! Int
                self.moviesResult.totalResults = liveTVJsonResult.value(forKey: "total_results") as! Int

                let liveTVJsonArray = liveTVJsonResult.value(forKey: "results") as! NSArray
                liveTVJsonArray.forEach({ (liveTVJSonItem) in

                    let liveTVDictionary = liveTVJSonItem as! NSDictionary
                    let liveTVItem = MovieItem()

                    liveTVItem.movieId = liveTVDictionary.value(forKey: "id") as! Int
                    liveTVItem.movieTitle = liveTVDictionary.value(forKey: "original_name") as! String
                    liveTVItem.posterPath = liveTVDictionary.value(forKey: "poster_path") as! String
                    liveTVItem.releaseDate = liveTVDictionary.value(forKey: "first_air_date") as! String

                    self.moviesResult.liveTVArray.append(liveTVItem)
                    print("Live TV Poster \(liveTVItem.posterPath)")

                })

                print("Live TV Results: \(self.moviesResult.totalPages)")

            }, onFailure: { (message) in
                print("Fetch Live TV Error: \(message)")
            })

            
            ///////////////////////////////////////////////////////////////////////
                                                                     //TopRated TV Shows
              ///////////////////////////////////////////////////////////////////////
            
            self.fetchTopTV(onComplete: { (topTVJsonResult) in

                self.moviesResult.pageNum = topTVJsonResult.value(forKey: "page") as! Int
                self.moviesResult.totalPages = topTVJsonResult.value(forKey: "total_pages") as! Int
                self.moviesResult.totalResults = topTVJsonResult.value(forKey: "total_results") as! Int

                let topTVJsonArray = topTVJsonResult.value(forKey: "results") as! NSArray
                topTVJsonArray.forEach({ (topJsonItem) in

                    let topTVDictionary = topJsonItem as! NSDictionary
                    let topTVItem = MovieItem()

                    topTVItem.movieId = topTVDictionary.value(forKey: "id") as! Int
                    topTVItem.movieTitle = topTVDictionary.value(forKey: "original_name") as! String
                    topTVItem.posterPath = topTVDictionary.value(forKey: "poster_path") as! String
                    topTVItem.releaseDate = topTVDictionary.value(forKey: "first_air_date") as! String

                    self.moviesResult.topRatedTVArray.append(topTVItem)
                })

                print("TopRated TV Results: \(self.moviesResult.totalPages)")

            }, onFailure: { (message) in
                print("Fetch Top TV Failed: \(message)")
            })

        }
        DispatchQueue.main.async {
              self.tableView.reloadData()
        }
      
    }
    
      ///////////////////////////////////////////////////////////////////////
    
      ///////////////////////////////////////////////////////////////////////

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
       
        
        if indexPath.section == 0   {
           let cell = tableView.dequeueReusableCell(withIdentifier: tableCellIdentifier, for: indexPath) as! MovieTableViewCell
            
            return cell
        }
            
        else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: topRatedCellIdentifier, for: indexPath) as! TopRatedTableViewCell
            
            return cell
        }
            
        else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: popularCell, for: indexPath) as! PopularTableViewCell
            
            return cell
        }
        
        else if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: popularTVCell, for: indexPath) as! PopularTVTableViewCell
            
            return cell
        }
            
        else if indexPath.section == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: liveTVCell, for: indexPath) as! LiveTVTableViewCell
            
            return cell
        }
        else if indexPath.section == 5 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: topTVCell, for: indexPath) as! TopTVTableViewCell
            
            return cell
            
        }
        
    
            
        else {
            return UITableViewCell()
        }
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return movieArray[section]
    }

    
    //MARK: Collection View Datasource*********
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        if collectionView.tag == 1 {
             return moviesResult.movieArray.count
        }
            
        else if collectionView.tag == 2 {
            return moviesResult.topMovieArray.count 
        }
            
        else if collectionView.tag == 3 {
            return moviesResult.popularMovieArray.count
        }
            
        else if collectionView.tag == 4 {
            print("Popular TV Array Count ------------------------- -: \(self.moviesResult.trendingMoviesArray.count)")
          return moviesResult.trendingMoviesArray.count
       
         
        }
            
        else if collectionView.tag == 5 {
              print("Live TV Array: \(moviesResult.liveTVArray.count) ")
            return moviesResult.liveTVArray.count
            //return 10
        }
        
        else if collectionView.tag == 6 {
            print("Top TV Array: \(moviesResult.topRatedTVArray.count) ")
             return moviesResult.topRatedTVArray.count
        }


        
        else {
            return 0
        }
       
    }
    
    ///////////////////////////////////////////////////////////////////////////////////////
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
   
        if collectionView.tag == 1 {
            
            if let upcomingCell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionCellIdentifier, for: indexPath) as? MovieCollectionViewCell {
                let movieItem = moviesResult.movieArray[indexPath.row]
                let posterItem = ("https://\(self.imagesUrl)\(self.posterWidth)\(movieItem.posterPath)")
                
                print("Poster Item: \(posterItem)")
                
                //Advanced Caching
                
                var upcominImageView = upcomingCell.image
                upcominImageView!.kf.indicatorType = .activity
                
                upcominImageView!.kf.setImage(with: URL(string: posterItem), placeholder: UIImage(named: "upcoming Image"), options: [
                    .transition(.fade(1)),
                    ])
                {
                    result in
                    switch result {
                    case .success(let value):
                        print("Upcoming Image Task Completed For: \(value.source.url!.absoluteString)")
                    case .failure(let error):
                        print("Upcoming IMageJob failed: \(error.localizedDescription)")
                    }
                    
                }
                
                return upcomingCell
            
        }
     
        }
        else if collectionView.tag == 2 {
            
            if let topCell = collectionView.dequeueReusableCell(withReuseIdentifier: topCollectionCell, for: indexPath) as? TopCollectionViewCell {
                
                let topMovieItem = moviesResult.topMovieArray[indexPath.row]
                let topPosterItem = ("https://\(self.imagesUrl)\(self.posterWidth)\(topMovieItem.posterPath)")
                
                //Caching
                
                var topImageView = topCell.topRatedImage
                topImageView!.kf.indicatorType = .activity
                
                topImageView!.kf.setImage(with: URL(string: topPosterItem), placeholder: UIImage(named: "top rated image"), options: [.transition(.fade(1)),])
                {
                    result in
                    
                    switch result {
                    case.success(let value):
                        print("TopRated Image task Completed For: \(String(describing: value.source.url?.absoluteString))")
                        
                    case.failure(let error):
                        print("Top Image Job Failed: \(error.localizedDescription)")
                    }
                }
                
                return topCell
            }
            
        }
            
        else if collectionView.tag == 3 {
            
            if let popularCell = collectionView.dequeueReusableCell(withReuseIdentifier: popularCollecionCell, for: indexPath) as? PopularCollectionViewCell {
                
                let popularMovieItem = moviesResult.popularMovieArray[indexPath.row]
                let popularPosterItem = ("https://\(self.imagesUrl)\(self.posterWidth)\(popularMovieItem.posterPath)")
                
                //Caching
                
                var popularImageView = popularCell.popularImage
                popularImageView!.kf.indicatorType = .activity
                
                popularImageView!.kf.setImage(with: URL(string: popularPosterItem), placeholder: UIImage(named: "popula Image"), options: [.transition(.fade(1)),])
                {
                    result in
                    
                    switch result {
                    case.success(let value):
                        print("Popular Image Task Completed For: \(String(describing: value.source.url?.absoluteString))")
                        
                    case.failure(let error):
                        print("Popular Image Job Failed: \(error.localizedDescription)")
                    }
                }
                return popularCell
            }
            
            
        }
            
        else if collectionView.tag == 4 {
            
//            if let popularTVCell = collectionView.dequeueReusableCell(withReuseIdentifier: popularTVCollectionCell, for: indexPath) as? PopulaTVCollectionViewCell {
//
////            return popularTVCell!
////
//            let popularTVPoster = popularTVCell.popularTVImage
//            let popularTVPost = moviesResult.popularTVArray[indexPath.row]
//
//            let posterItem = ("https://\(self.imagesUrl)\(self.posterWidth)\(popularTVPost.posterPath)")
//
//            popularTVPoster!.kf.setImage(with: URL.init(fileURLWithPath: posterItem))

            if let trendingMovieCell = collectionView.dequeueReusableCell(withReuseIdentifier: popularTVCollectionCell, for: indexPath) as? PopulaTVCollectionViewCell {

                print("i actually work")

                let trendingItem = moviesResult.trendingMoviesArray[indexPath.row]
                let trendingPosterItem = ("https://\(self.imagesUrl)\(self.posterWidth)\(trendingItem.posterPath)")

                //Caching

                var trendingImageView = trendingMovieCell.popularTVImage
                trendingImageView!.kf.indicatorType = .activity

                trendingImageView!.kf.setImage(with: URL(string: trendingPosterItem), placeholder: UIImage(named: "Trending TV Image"), options: [.transition(.fade(1)),])
                {
                    result in

                    switch result {
                    case.success(let value):
                        print("Popular TV Image Task Completed For: \(String(describing: value.source.url?.absoluteString))")

                    case.failure(let error):
                        print("Popular TV Image Job Failed: \(error.localizedDescription)")
                    }
                }


            return trendingMovieCell
            }
            
        }
            
        else if collectionView.tag == 5 {
            
//            let liveTVCell = collectionView.dequeueReusableCell(withReuseIdentifier: liveCollectionCell, for: indexPath) as? LiveTVCollectionViewCell
//
//            return liveTVCell!
            
            if let liveTVCell = collectionView.dequeueReusableCell(withReuseIdentifier: liveCollectionCell, for: indexPath) as? LiveTVCollectionViewCell {

            let liveTVItem = moviesResult.liveTVArray[indexPath.row]
            let liveTVPosterItem = ("https://\(self.imagesUrl)\(self.posterWidth)\(liveTVItem.posterPath)")

            //Caching

            var liveTVImageView = liveTVCell.liveTVImage
            liveTVImageView!.kf.indicatorType = .activity

            liveTVImageView!.kf.setImage(with: URL(string: liveTVPosterItem), placeholder: UIImage(named: "Live TV Image"), options: [.transition(.fade(1)),])
            {
                result in

                switch result {
                case.success(let value):
                    print("Live TV Image Task Completed For: \(String(describing: value.source.url?.absoluteString))")

                case.failure(let error):
                    print("Live TV Image Job Failed: \(error.localizedDescription)")
                }
            }

            return liveTVCell

            }
        }
            
        else if collectionView.tag == 6 {
            
            if let topTVCell = collectionView.dequeueReusableCell(withReuseIdentifier: topTVCollectionCell, for: indexPath) as? TopTVCollectionViewCell {
                
                let topTVItem = moviesResult.topRatedTVArray[indexPath.row]
                let topTVPosterItem = ("https://\(self.imagesUrl)\(self.posterWidth)\(topTVItem.posterPath)")
                
                //Caching
                
                var topTVImageView = topTVCell.topTVImage
              topTVImageView!.kf.indicatorType = .activity
                
                topTVImageView!.kf.setImage(with: URL(string: topTVPosterItem), placeholder: UIImage(named: "Top TV Image"), options: [.transition(.fade(1)),])
                {
                    result in
                    
                    switch result {
                    case.success(let value):
                        print("Top TV Image Task Completed For: \(String(describing: value.source.url?.absoluteString))")
                        
                    case.failure(let error):
                        print("Top TV Image Job Failed: \(error.localizedDescription)")
                    }
                }
                
                 return topTVCell
            }
            
           
        }
            
        else {
            return UICollectionViewCell()
        }
       
       return UICollectionViewCell()
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
    
    //Upcoming Movies
    
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
              //  print("Movies Result Json: \(moviesResultJson)")
            }
            
        }.resume()
        
    }
    
    //TopRated Movies
    func fetchTopRatedMovies (onComplete : @escaping (_ topMovieResult : NSDictionary) -> (), onFailure : @escaping (_ message : String) -> ()) -> Void {
        
        let topRatedUrl = ("\(serviceUrl)/movie/top_rated?api_key=\(apiKey!)&language=en-US&page=1")
        print("TopRatedUrl: \(topRatedUrl)")
        
        var request = URLRequest.init(url: URL.init(string: topRatedUrl)!)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            
            if error != nil {
                print("Error TopRated error: \(String(describing: error))")
                onFailure("Error: \(String(describing: error))")
            }
            
            else {
                let topMoviesResult = try! JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                
                onComplete(topMoviesResult)
             //   print("Top Movies Result: \(topMoviesResult)")
            }
            
        }.resume()
        
        
    }
    
    //Popular Movies
    func fetchPopularMovies (onComplete : @escaping (_ popularMoviesResult : NSDictionary) -> (), onFailure : @escaping (_ message : String) -> ()) -> Void {
        
        let popularUrl = ("\(serviceUrl)/movie/popular?api_key=\(apiKey!)&language=en-US&page=1")
        print("PopularUrl: \(popularUrl)")
        
        var request = URLRequest.init(url: URL.init(string: popularUrl)!)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            
            if error != nil {
                print("Cannot Get Popular Movies :\(String(describing: error))")
                onFailure("Popular Movies Error\(String(describing: error))")
            }
            
            else {
                
                let popularMoviesResult = try! JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                
                onComplete(popularMoviesResult)
            //    print("Popular Movies Result \(popularMoviesResult)")
                
            }
            
        }.resume()
        
    }
    
    //Trending Movies
    
    func  fetchTrendingMovies (onComplete : @escaping (_ trendingMoviesResult : NSDictionary) -> (), onFailure : @escaping (_ message : String) -> ()) -> Void {

        let trendinMoviesUrl = ("\(serviceUrl)/trending/all/day?api_key=\(apiKey!)")
        print("PopularTV: \(trendinMoviesUrl)")

        var request = URLRequest.init(url: URL.init(string: trendinMoviesUrl)!)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) {(data, response, error) in

            if error != nil {
                print("Trending Movies shows error: \(String(describing: error))")
                onFailure("Trending Movies error: \(String(describing: error))")
            }

            else {
                let trendingMoviesResult = try! JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary

                onComplete(trendingMoviesResult)
                print("PopularTV COmpleted Json: \(trendingMoviesResult)")

            }

        }.resume()

    }
    

    //Live TV Shows
    
    func fetchLiveTV (onComplete : @escaping (_ liveTVResult : NSDictionary) -> (), onFailure : @escaping (_ message : String) -> ()) -> Void {

        let liveTVUrl = ("\(serviceUrl)/tv/on_the_air?api_key=\(apiKey!)&language=en-US&page=1")
        print("liveTVUrl : \(liveTVUrl)")

        var request = URLRequest.init(url: URL.init(string: liveTVUrl)!)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) {(data, response, error) in

            if error != nil {

                print("Live TV error: \(String(describing: error))")
                onFailure("Live TV error: \(String(describing: error))")

            }

            else {

                let liveTVResult = try! JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary

                onComplete(liveTVResult)
                print("Live TV Results JSon: \(liveTVResult)")
            }

        }.resume()



    }
//
//    //Top Rated TV Shows

    func fetchTopTV (onComplete : @escaping (_ topTVResults : NSDictionary) ->(), onFailure : @escaping (_ message : String) -> ()) -> Void {

        let topTVUrl = ("\(serviceUrl)/tv/top_rated?api_key=\(apiKey!)&language=en-US&page=1")
        print("top TV Url: \(topTVUrl)")

        var request = URLRequest.init(url: URL.init(string: topTVUrl)!)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) {(data, response, error) in

            if error != nil {

                print("TopTVURL Error: \(String(describing: error))")
                onFailure("TopTVURL Error: \(String(describing: error))")

            }

            else {

                let topTVResult = try! JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                 onComplete(topTVResult)
                print("Top TV Result: \(topTVResult)")

            }

        }.resume()

    }
    
    
    }


