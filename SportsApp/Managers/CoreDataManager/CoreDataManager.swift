//
//  CoreDataManager.swift
//  SportsApp
//
//  Created by Macbook on 15/06/2022.
//

import Foundation
import UIKit
import CoreData
import RxCocoa
import RxSwift

class CoreDataManager {
    
    static var shared  = CoreDataManager()
    
    //Entity Name in Core Data
    var entityName     : String?
    
    // To Access viewContext from NSManagedObjectContext and saveContext() in AppDelegate
    var appDelegate    : AppDelegate?
    
    // NSManagedObjectContext => Responsible for managing objects in data base to create managed objects using instances (ex:from Movie)  by getting copies from this database
     // This Gives Us Object From DataBase To Store Our Data There
    let  viewContext   : NSManagedObjectContext?
    
    // For Detecting The Current Movie
    var currentLeague: NSManagedObject?
    
    private init() {
       
        entityName  = "SportsApp"
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        viewContext = appDelegate?.persistentContainer.viewContext
        
    }
    
    func fetchComptitionsData() -> PublishSubject<[Competitions]> {
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: CoreDataManager.shared.entityName!)
        
        do {
            let comptitions = try viewContext!.fetch(fetchRequest)
            
            print("Count: \(comptitions.count)")
            var array = [Competitions]()
            array.removeAll()
            for comptition in comptitions {
                array.append(Competitions(id: nil, area: nil, name: comptition.value(forKey: "comptitionName") as? String ?? "", code: nil, emblemUrl: nil, plan: nil, currentSeason: nil, numberOfAvailableSeasons: nil, lastUpdated: nil))
                
            }
            ComptetionsViewModel.comptetionsModelSubject.onNext(array)
            array.removeAll()
            print(ComptetionsViewModel.comptetionsModelSubject)
        } catch let error {
            print(error.localizedDescription)
        }
        return ComptetionsViewModel.comptetionsModelSubject
        
    }
    
    func save(comptitionName :String?) -> Bool {
        
        guard let viewContext = viewContext,
              let theComptitionName = comptitionName,
              !theComptitionName.isEmpty
              else {
            print("Missing Data")
            return false
        }

        //  Two Steps For Getting Entity (Table) From our object => viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: CoreDataManager.shared.entityName!,
                                                      in: viewContext) else {
            return false
        }
    
        //  Get The Class Required For Performing behavior required of a Core Data model object.
        let comptition = NSManagedObject(entity: entity,
                               insertInto: viewContext)
    
        //  Set Properties Inserted Data From User To Movies Table (Entity)
        comptition.setValue(theComptitionName, forKey: "comptitionName")
        
        // Save Our Data (Properties) Into CoreData
        appDelegate?.saveContext()
        
        return true
    }
    
    
}
