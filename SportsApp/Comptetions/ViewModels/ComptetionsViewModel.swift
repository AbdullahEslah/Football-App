//
//  ComptetionsViewModel.swift
//  SportsApp
//
//  Created by Abdallah Eslah on 15/10/2022.
//

import Foundation
import RxCocoa
import RxSwift

class ComptetionsViewModel {
    
    static var loadingBehavior                 = BehaviorRelay<Bool>(value: false)
    
    static var comptetionsModelSubject = PublishSubject<[Competitions]>()
    
    
    static var comptetionsModelObservable      : Observable<[Competitions]> {
        return comptetionsModelSubject
    }
    
    //  1=>  If I Want To Send An Event To Others Which Can subscribe to it to listen to it
    //  Or of for single & just for single elemnt this Observable<String>
    var stringVar = Observable.of("hello","abdallah")
    
    //  this Observable<[String]>
    var arrVar = Observable.of(["1","2"])
    
//    ex of subscribe or listen to event
//    comptetionsModelSubject.subscribe { event in
//        print(event)
//    }
    
    
    
    //  Fetch All Comptetions
    static func getComptetions(){
        

        loadingBehavior.accept(true)
        NetworkManager.shared.taskForGETRequest(url: EndPoints.getComtetions.url){ (response:MainComptetions?,responseError:ComptetionError? ,error)  in
            self.loadingBehavior.accept(false)
            
            if error != nil {
                Helper.displayMessage(message: error!.localizedDescription, messageError: true)
                print(error!)
            }else if let errorModel = responseError {
                Helper.displayMessage(message: error!.localizedDescription, messageError: true)
                print(errorModel.message ?? "")
            }
            
            //  result -> is the [competitions]
            guard let comptetionsModel = response else { return }
            
            //  Add add new Values to that sequence 
            self.comptetionsModelSubject.onNext(comptetionsModel.competitions ?? [])
//            ArraysManager.coreDataArray.append(contentsOf: comptetionsModel.competitions ?? [])
            for comptition in comptetionsModel.competitions ?? [] {
                self.saveLocalData(comptitionsName: comptition.name)
        
            }

        }
    }
    
    static func saveLocalData(comptitionsName :String?) {
        
        if CoreDataManager.shared.save(comptitionName: comptitionsName ?? "") {
            print("Done")
        }
    }
    
}
