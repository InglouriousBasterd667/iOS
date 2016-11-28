//
//  GraphViewController.swift
//  Calculator
//
//  Created by Mikhail Lyapich on 28.11.16.
//  Copyright © 2016 Mikhail Lyapich. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController {


    @IBOutlet weak var str: UILabel!
    private var tochangeStr:String?
    
    func updateLabel(_ s: String){
        tochangeStr = s
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        str.text = tochangeStr
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
