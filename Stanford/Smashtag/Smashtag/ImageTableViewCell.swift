//
//  ImageTableViewCell.swift
//  Smashtag
//
//  Created by Mikhail Lyapich on 13.12.16.
//  Copyright © 2016 Mikhail Lyapich. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {

    @IBOutlet weak var mediaView: UIImageView!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var imageURL: URL?{
        didSet{
            updateUI()
        }
    }
    

    private var media: UIImage? {
        get {
            return mediaView.image
        }
        set {
            mediaView.image = newValue
            mediaView.sizeToFit()
            spinner?.stopAnimating()
        }
    }
    
    private func updateUI(){
        if let url = imageURL {
            // fire up the spinner
            // because we're about to fork something off on another thread
            spinner?.startAnimating()
            // put a closure on the "user initiated" system queue
            // this closure does NSData(contentsOfURL:) which blocks
            // waiting for network response
            // it's fine for it to block the "user initiated" queue
            // because that's a concurrent queue
            // (so other closures on that queue can run concurrently even as this one's blocked)
            DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async {
                let contentsOfURL = try? Data(contentsOf: url) // blocks! can't be on main queue!
                // now that we got the data from the network
                // we want to put it up in the UI
                // but we can only do that on the main queue
                // so we queue up a closure here to do that
                DispatchQueue.main.async {
                    // since it could take a long time to fetch the image data
                    // we make sure here that the image we fetched
                    // is still the one this ImageViewController wants to display!
                    // you must always think of these sorts of things
                    // when programming asynchronously
                    if url == self.imageURL {
                        if let imageData = contentsOfURL {
                            self.media = UIImage(data: imageData)
                        } else {
                            self.spinner?.stopAnimating()
                        }
                    } else {
                        // just so you can see in the console when this happens
                        print("ignored data returned from url \(url)")
                    }
                }
            }
        }
    }
    
}
