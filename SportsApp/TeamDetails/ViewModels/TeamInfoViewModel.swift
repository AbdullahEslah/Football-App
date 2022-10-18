//
//  TeamInfoViewModel.swift
//  SportsApp
//
//  Created by Abdallah Eslah on 18/10/2022.
//

import Foundation
import RxCocoa
import RxSwift

class TeamInfoViewModel {
    
    var loadingBehavior                 = BehaviorRelay<Bool>(value: false)
    
    private var teamDetailsModelSubject = PublishSubject<[Squad]>()
    
    var teamDetailsModelObservable      : Observable<[Squad]> {
        return teamDetailsModelSubject
    }
    
    //  Get All Comptetions Request
    func getTeamDetails(teamId:Int){
        loadingBehavior.accept(true)
        let endPoints = EndPoints.getTeams.stringValue + "\(teamId)"
        guard let newUrl = URL(string: endPoints) else {
            return
        }
        NetworkManager.shared.taskForGETRequest(url: newUrl) { [weak self] (comptetionDetails:MainTeamInfo?, responseError:ComptetionError?,error)  in
            if error != nil {
                print(error!.localizedDescription)
                Helper.displayMessage(message: error!.localizedDescription, messageError: true)
            }else if let responseError = responseError {
                Helper.displayMessage(message: responseError.message ?? "", messageError: true)
            }
            //  result -> is the [competitions]
            guard let comptetionDetails = comptetionDetails else { return }
            print(comptetionDetails)
            self?.teamDetailsModelSubject.onNext(comptetionDetails.squad ?? [] )
        }
    }
}
