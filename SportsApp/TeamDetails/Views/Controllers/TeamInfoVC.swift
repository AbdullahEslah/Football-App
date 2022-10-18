//
//  TeamInfoVC.swift
//  SportsApp
//
//  Created by Abdallah Eslah on 17/10/2022.
//

import UIKit
import Kingfisher
import RxSwift

class TeamInfoVC: UIViewController {
    
    @IBOutlet weak var teamImageView: UIImageView!
    @IBOutlet weak var teamShortNameLabel: UILabel!
    @IBOutlet weak var teamLongNameLabel: UILabel!
    @IBOutlet weak var teamAddressLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    //  Variables
    var teamId        :Int?
    var teamLongName  :String?
    var teamShortName :String?
    var teamImage     :String?
    var teamAddress   :String?

    var teamDetailsViewModel : TeamInfoViewModel?
    let disposeBag           = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        teamShortNameLabel.text = teamShortName
        teamLongNameLabel.text  = teamLongName
        teamDetailsViewModel    = TeamInfoViewModel()
        fetchTeamImage()
        setupTableView()
        subscribeToResponse()
        subscribeToLoading()
        getComptetionsDetails()
    }
    
    func fetchTeamImage() {
        if let url = URL(string: teamImage ?? "") {
            let placeholder = UIImage(named: "placeholder")
            let options : KingfisherOptionsInfo = [KingfisherOptionsInfoItem.transition(.fade(0.1))]
            teamImageView.kf.indicatorType = .activity
            teamImageView.kf.setImage(with: url,placeholder: placeholder,options: options)
        }
    }
    
    //  Configure TableView
    func setupTableView() {
        tableView.register(UINib(nibName: "TeamInfoCell", bundle: nil), forCellReuseIdentifier: "TeamInfoCell")
    }
    
    func subscribeToLoading() {
        teamDetailsViewModel?.loadingBehavior.subscribe(onNext: { (isLoading) in
            if isLoading {
                AppAnimation.playAnimation(onView: self.view)
                self.tableView.isHidden = true
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: {
                    self.tableView.isHidden = false
                    AppAnimation.dismissAnimation()
                    
                })
            }
        }).disposed(by: disposeBag)
    }
    
    func subscribeToResponse() {
        self.teamDetailsViewModel?.teamDetailsModelObservable
            .bind(to: self.tableView
                .rx
                .items(cellIdentifier: "TeamInfoCell",
                       cellType: TeamInfoCell.self)) { row, teamDetails, cell in
                
                cell.playerNameLabel.text        = teamDetails.name
                cell.playerPositionLabel.text    = teamDetails.position
                cell.playerNationalityLabel.text = teamDetails.nationality
            }
                       .disposed(by: disposeBag)
    }
    
    func getComptetionsDetails(){
        teamDetailsViewModel?.getTeamDetails(teamId: self.teamId ?? 0)
    }

}
