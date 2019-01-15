//
//  MoviesTableViewController.swift
//  popular movies app
//
//  Created by Achem Samuel on 1/13/19.
//  Copyright © 2019 Achem Samuel. All rights reserved.
//

import UIKit

class MoviesTableViewController: UITableViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    //MARK: Variables
    
    var movieArray = ["Upcoming", "Action", "Adventure", "Animation", "Comedy", "Horror", "Sci-fi"]
    let tableCellIdentifier = "cell"
    let collectionCellIdentifier = "collectionCell"
    
    //Networking Variables
    var apiKey : String!
    let serviceUrl = "https://api.themoviedb.org/3"
    var baseUrl : String!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

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
    
    

}
