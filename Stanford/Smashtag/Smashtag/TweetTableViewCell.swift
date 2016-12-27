//
//  TweetTableViewCell.swift
//  Smashtag
//
//  Created by Mikhail Lyapich on 10.12.16.
//  Copyright © 2016 Mikhail Lyapich. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewCell: UITableViewCell {


    @IBOutlet weak var tweetName: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var tweetDate: UILabel!
    
    @IBOutlet weak var tweetProfileImage: UIImageView!
    
    private let urlColor: UIColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
    private let userColor: UIColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
    private let hashtagColor: UIColor = #colorLiteral(red: 0, green: 0.9914394021, blue: 1, alpha: 1)
    
    var tweet: Twitter.Tweet?{
        didSet{
            updateUI()
        }
    }
    
    private func getAttributedTextFromTweet(_ tweet: Tweet) -> NSMutableAttributedString{
        var attributedString = NSMutableAttributedString(string: tweet.text)
        attributedString.beginEditing()
        addColorToMentions(tweet.urls, attributedString: &attributedString, color: urlColor)
        addColorToMentions(tweet.hashtags, attributedString: &attributedString, color: hashtagColor)
        addColorToMentions(tweet.userMentions, attributedString: &attributedString, color: userColor)
        attributedString.endEditing()
        return attributedString
    }
    
    private func addColorToMentions(_ mentions: [Mention], attributedString: inout NSMutableAttributedString, color: UIColor){
        for mention in mentions{
            attributedString.addAttribute(NSForegroundColorAttributeName, value: color, range: mention.nsrange)
        }
    }
    
    private func addMedia(tweet:Tweet){
        if tweetText?.text != nil{
            for _ in tweet.media{
                tweetText.text! += " 📷"
            }
        }
    }
    
    private func setDate(tweet:Tweet){
        let formatter = DateFormatter()
        if NSDate().timeIntervalSince(tweet.created) > 24 * 60 * 60{
            formatter.dateStyle = .short
        }
        else{
            formatter.timeStyle = .short
        }
        tweetDate?.text = formatter.string(from: tweet.created)
    }
    
    private func setImage(tweet: Tweet){
        if let profileImageUrl = tweet.user.profileImageURL{
            DispatchQueue.global(qos: .userInitiated).async {
                let contentsOfURL = try? Data(contentsOf: profileImageUrl)
                DispatchQueue.main.async {
                    if profileImageUrl == tweet.user.profileImageURL {
                        if let imageData = contentsOfURL{
                            self.tweetProfileImage?.image = UIImage(data: imageData)
                        }
                    }
                }
            }
        }
    }
    
    private func updateUI(){
        tweetName?.text = nil
        tweetText?.attributedText = nil
        tweetDate?.text = nil
        tweetProfileImage?.image = nil
        
        if let tweet = self.tweet{
            tweetName?.text = "\(tweet.user)"
            tweetText?.attributedText = getAttributedTextFromTweet(tweet)
            addMedia(tweet: tweet)
            setDate(tweet: tweet)
            setImage(tweet: tweet)
        }
    }

}
