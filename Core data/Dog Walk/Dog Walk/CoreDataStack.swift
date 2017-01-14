//
//  CoreDataStack.swift
//  Dog Walk
//
//  Created by Mikhail Lyapich on 14.01.17.
//  Copyright © 2017 Razeware. All rights reserved.
//

import Foundation
import CoreData


class CoreDataStack {
  private let modelName: String
  
  func saveContext(){
    guard managedContext.hasChanges else { return }
  }
  
  public lazy var managedContext: NSManagedObjectContext = {return self.storeContainer.viewContext}()
  
  init(modelName: String) {
    self.modelName = modelName
  }
  
  private lazy var storeContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: self.modelName)
    
    container.loadPersistentStores{storeDesc, error in
      if let error = error as NSError? {
        print("Unresolved error \(error), \(error.userInfo)")
      }
    }
    return container
  }()

}
