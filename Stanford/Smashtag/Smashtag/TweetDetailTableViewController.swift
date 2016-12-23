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

    
    
    private var tweet: Tweet!{
        didSet{
            
        }
    }
    private var mentions = [String:[AnyObject]]()
    private var mentionsSections: [String] = []
    
    private struct Storyboard{
        static let mentionIdentifier = "Mention"
        static let imageIdentifier = "Image"
        static let segueSearchIdentifier = "Search mention"
        static let segueImageIdentifier = "Show image"
    }
    
    func getDataFromSegue(_ tweet: Tweet){
        self.tweet = tweet
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        
        title = tweet.user.name
        
        mentions["Images"] = tweet.media
        mentions["Hashtags"] = tweet.hashtags
        mentions["Urls"] = tweet.urls
        mentions["Users"] = tweet.userMentions
        
        mentionsSections = Array(mentions.keys).sorted()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier{
            if identifier == Storyboard.segueSearchIdentifier{
                if let destVc = segue.destination as? TweetTableViewController{
                    if let cell = sender as? UITableViewCell{
                        destVc.searchText = cell.textLabel?.text
                    }
                }
            }
            else if identifier == Storyboard.segueImageIdentifier{
                if let destVc = segue.destination as? ImageViewController{
                    if let cell = sender as? ImageTableViewCell{
                        destVc.imageURL = cell.imageURL
                    }
                }
            }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == Storyboard.segueSearchIdentifier{
            if let cell = sender as? UITableViewCell{
                if let txt = cell.textLabel?.text{
                    if let url = URL(string: txt), txt.hasPrefix("http"){
                        UIApplication.shared.open(url)
                        return false
                    }
                }
            }
        }
        return true
    }
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sectionName = mentionsSections[indexPath.section]
        let mentionsBySection = mentions[sectionName]
        let mention = mentionsBySection?[indexPath.row]
        if mentionsBySection is [MediaItem]{
            let media = mention as! MediaItem
            return tableView.bounds.size.width / CGFloat(media.aspectRatio)
        }
        return UITableViewAutomaticDimension
    }
    
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
        let sectionName = mentionsSections[indexPath.section]
        let mentionsBySection = mentions[sectionName]
        let mention = mentionsBySection?[indexPath.row]
        if mentionsBySection is [Mention]{
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.mentionIdentifier, for: indexPath)
            cell.textLabel?.text = mention?.keyword
            return cell
        }
       else if mentionsBySection is [MediaItem]{
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.imageIdentifier, for: indexPath) as! ImageTableViewCell
            let media = mention as! MediaItem
            cell.imageURL = media.url
            return cell
        }
        return UITableViewCell()
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
