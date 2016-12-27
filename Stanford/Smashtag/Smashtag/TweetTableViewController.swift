//
//  TweetTableTableViewController.swift
//  Smashtag
//
//  Created by Mikhail Lyapich on 05.12.16.
//  Copyright © 2016 Mikhail Lyapich. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewController: UITableViewController, UISearchBarDelegate {

    
    private struct Storyboard{
        static let TweetCellIdentifier = "Tweet"
        static let ShowDetailTweetIdentifier = "Show Tweet"
    }
    
    @IBOutlet weak var searchField: UISearchBar!{
        didSet{
            searchField.delegate = self
            searchField.text = searchText
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let st = self.searchText{
            RecentSearches().add(search: st)
        }
        searchBar.resignFirstResponder()
    }
    
    var tweets = [Array<Twitter.Tweet>](){
        didSet{
            tableView.reloadData()
        }
    }
    var searchText: String?{
        didSet{
            tweets.removeAll()
            title = searchText
            searchForTweets()
        }
    }
    
    private var twitterRequest: Twitter.Request?{
        if let query = searchText, !query.isEmpty{
            return Twitter.Request(search:query,count:100)
        }
        return nil
    }
    
    private var lastTwitRequest: Twitter.Request?
    
    private func searchForTweets(){
        if let request = twitterRequest{
            lastTwitRequest = request

            request.fetchTweets(){[weak weakSelf = self] (newTweets) in
                DispatchQueue.main.async(){
                    if !newTweets.isEmpty && request == weakSelf?.lastTwitRequest{
                        weakSelf?.tweets.insert(newTweets, at: 0)
                    }
                }
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination
        if let cell = sender as? TweetTableViewCell{
            if let tweetDetailVC = destinationVC as? TweetDetailTableViewController{
                if segue.identifier == Storyboard.ShowDetailTweetIdentifier{
                    tweetDetailVC.getDataFromSegue((cell.tweet)!)
                }
            }
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return tweets.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets[section].count
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.TweetCellIdentifier, for: indexPath)

        let tweet = tweets[indexPath.section][indexPath.row]
        if let tweetCell = cell as? TweetTableViewCell{
            tweetCell.tweet = tweet
        }
        
        return cell
    }

    

    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}