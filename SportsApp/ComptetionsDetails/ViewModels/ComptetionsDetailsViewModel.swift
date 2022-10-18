//
//  ComptetionsDetailsViewModel.swift
//  SportsApp
//
//  Created by Abdallah Eslah on 17/10/2022.
//

import Foundation
import RxCocoa
import RxSwift

class ComptetionsDetailsViewModel {
    
    var loadingBehavior                        = BehaviorRelay<Bool>(value: false)
    
    private var comptetionsDetailsModelSubject = PublishSubject<[Teams]>()
    
    var comptetionsDetailsModelObservable      : Observable<[Teams]> {
        return comptetionsDetailsModelSubject
    }
    
    //  Get All Comptetions Request
    func getComptetionsDetails(ComptetionId:Int){
        loadingBehavior.accept(true)
        let endPoints = EndPoints.getComtetionsDetails.stringValue + "\(ComptetionId)" + "/teams"
        guard let newUrl = URL(string: endPoints) else {
            return
        }
        NetworkManager.shared.taskForGETRequest(url: newUrl) { [weak self] (comptetionDetails:MainComptetionTeams?, responseError:ComptetionError?,error)  in
            if error != nil {
                print(error!.localizedDescription)
                Helper.displayMessage(message: error!.localizedDescription, messageError: true)
            }else if let responseError = responseError {
                Helper.displayMessage(message: responseError.message ?? "", messageError: true)
            }
            //  result -> is the [competitions]
            guard let comptetionDetails = comptetionDetails else { return }
            print(comptetionDetails)
            self?.comptetionsDetailsModelSubject.onNext(comptetionDetails.teams ?? [] )
        }
    }
    
}
