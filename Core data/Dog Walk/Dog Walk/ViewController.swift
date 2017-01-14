import UIKit
import CoreData

class ViewController: UIViewController {

  var managedContext: NSManagedObjectContext!
  // MARK: - Properties
  lazy var dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
  }()
  
  var currentDog: Dog?

  // MARK: - IBOutlets
  @IBOutlet var tableView: UITableView!

  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    let dogName = "Guffy"
    let dogFetch: NSFetchRequest<Dog> = Dog.fetchRequest()
    
    dogFetch.predicate = NSPredicate(format: "%K = %@", #keyPath(Dog.name), dogName)
    
    do{
      let result = try managedContext.fetch(dogFetch)
      if result.count > 0{
        currentDog = result.first
      }
      else{
        currentDog = Dog(context: managedContext)
        currentDog?.name = dogName
        try managedContext.save()
      }
    }
    catch let error as NSError{
      print("Fetch error: \(error) \(error.userInfo)")
    }
    
  }
}

// MARK: - IBActions
extension ViewController {

  @IBAction func add(_ sender: UIBarButtonItem) {
//    walks.append(NSDate())
    tableView.reloadData()
  }
}

// MARK: UITableViewDataSource
extension ViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let currentWalks = currentDog?.walks else{ return 1 }
    return currentWalks.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    guard let walk = currentDog?.walks?[indexPath.row] as? Walk,
      let walkDate = walk.date as? Date else {
        return cell
    }
    cell.textLabel?.text = dateFormatter.string(from: walkDate)
    return cell
  }

  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "List of Walks"
  }
}
