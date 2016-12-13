//
//  TweetDetailTableViewController.swift
//  Smashtag
//
//  Created by Mikhail Lyapich on 12.12.16.
//  Copyright © 2016 Mikhail Lyapich. All rights reserved.
//

import UIKit
import Twitter

class TweetDetailTableViewController: UITableViewController {

    
    
    private var tweet: Tweet!
    private var mentions = [String:[AnyObject]]()
    private var mentionsSections: [String] = []
    
    private struct Storyboard{
        static let mentionIdentifier = "Mention"
        static let imageIdentifier = "Image"
    }
    
    func getDataFromSegue(_ tweet: Tweet){
        self.tweet = tweet
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = tweet.user.name
        
        mentions["Images"] = tweet.media
        mentions["Hashtags"] = tweet.hashtags
        mentions["Urls"] = tweet.urls
        mentions["Users"] = tweet.userMentions
        
        mentionsSections = Array(mentions.keys).sorted()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return mentionsSections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (mentions[mentionsSections[section]]?.count)!
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let title = mentionsSections[section]
        if let mentionsBySection = mentions[title], mentionsBySection.count > 0{
            return title
        }
        else{
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        let sectionName = mentionsSections[indexPath.section]
        let mentionsBySection = mentions[sectionName]
        if mentionsBySection is [Mention]{
            cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.mentionIdentifier, for: indexPath)
            let mention = mentionsBySection?[indexPath.row]
            cell.textLabel?.text = mention?.keyword
        }
        else if mentionsBySection is [MediaItem]{
            cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.imageIdentifier, for: indexPath)
            cell.textLabel?.text = "Hello motherfucker!"
        }
        else{
            cell.textLabel?.text = "There are no items"
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
