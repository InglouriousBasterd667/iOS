//
//  ImageTableViewCell.swift
//  Smashtag
//
//  Created by Mikhail Lyapich on 13.12.16.
//  Copyright © 2016 Mikhail Lyapich. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {

    var imageURL: String?{
        didSet{
            updateUI()
        }
    }
    
    private func updateUI(){
        
    }
    
}
