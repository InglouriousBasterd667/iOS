/*
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import CoreData
import UIKit

class ViewController: UIViewController {

  // MARK: - IBOutlets
  @IBOutlet weak var segmentedControl: UISegmentedControl!
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var ratingLabel: UILabel!
  @IBOutlet weak var timesWornLabel: UILabel!
  @IBOutlet weak var lastWornLabel: UILabel!
  @IBOutlet weak var favoriteLabel: UILabel!
  
  var managedContext: NSManagedObjectContext!
  
  func insertSampleData(){
    let fetch = NSFetchRequest<Bowtie>(entityName: "Bowtie")
    fetch.predicate = NSPredicate(format: "searchKey != nil")
    let count = try! managedContext.count(for: fetch)
    
    if count > 0{
      return
    }
    
    let path = Bundle.main.path(forResource: "SampleData", ofType: "plist")
    let dataArray = NSArray(contentsOfFile: path!)!
    
    for dict in dataArray{
      let entity = NSEntityDescription.entity(forEntityName: "Bowtie", in: managedContext)!
      let bowtie = Bowtie(entity: entity, insertInto: managedContext)
      let btDict = dict as! [String: AnyObject]
      
      bowtie.name = btDict["name"] as? String
      bowtie.searchKey = btDict["searchKey"] as? String
      bowtie.rating = btDict["rating"] as! Double
      let colorDict = btDict["tintColor"] as! [String: AnyObject]
      bowtie.tintColor = UIColor.color(dict: colorDict)
      
      let imageName = btDict["imageName"] as? String
      let image = UIImage(named: imageName!)!
      let photoData = UIImagePNGRepresentation(image)!
      bowtie.photoData = NSData(data: photoData)
      
      bowtie.lastWorn = btDict["lastWorn"] as? NSDate
      let timesNumber = btDict["timesWorn"] as! NSNumber
      bowtie.timesWorn = timesNumber.int32Value
      bowtie.isFavorite = btDict["isFavorite"] as! Bool
    }
    
    try! managedContext.save()
    
  }
  
  func populate(bowtie: Bowtie){
    guard let imageData = bowtie.photoData as? Data,
      let lastWorn = bowtie.lastWorn as? Date,
      let tintColor = bowtie.tintColor as? UIColor else {
        return
    }
    imageView.image = UIImage(data: imageData)
    nameLabel.text = bowtie.name
    ratingLabel.text = "Rating: \(bowtie.rating)/5"
    timesWornLabel.text = "# times worn: \(bowtie.timesWorn)"
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .short
    dateFormatter.timeStyle = .none
    lastWornLabel.text =
      "Last worn: " + dateFormatter.string(from: lastWorn)
    favoriteLabel.isHidden = !bowtie.isFavorite
    view.tintColor = tintColor
  }
  
  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    insertSampleData()
    
    let request = NSFetchRequest<Bowtie>(entityName: "Bowtie")
    let firstTitle = segmentedControl.titleForSegment(at: 0)!
    request.predicate = NSPredicate(format: "searchKey == %@", firstTitle)
    
    do{
      let results = try managedContext.fetch(request)
      
      populate(bowtie:results.first!)
    }
    catch let error as NSError{
      print("Could not fetch \(error), \(error.userInfo)")
    }
  }

  // MARK: - IBActions
  @IBAction func segmentedControl(_ sender: AnyObject) {

  }

  @IBAction func wear(_ sender: AnyObject) {

  }
  
  @IBAction func rate(_ sender: AnyObject) {

  }
  

}

private extension UIColor{
  static func color(dict: [String : AnyObject]) -> UIColor?{
    guard let red = dict["red"] as? NSNumber,
      let green = dict["green"] as? NSNumber,
      let blue = dict["blue"] as? NSNumber else {
        return nil
    }
    
    return UIColor(red: CGFloat(red)/255.0,
                   green: CGFloat(green)/255.0,
                   blue: CGFloat(blue)/255.0,
                   alpha: 1)
  }
}
