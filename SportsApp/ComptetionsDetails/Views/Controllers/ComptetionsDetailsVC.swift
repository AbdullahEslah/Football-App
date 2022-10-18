//
//  ComptetionsDetailsVC.swift
//  SportsApp
//
//  Created by Abdallah Eslah on 15/10/2022.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class ComptetionsDetailsVC: UIViewController {
    
    @IBOutlet weak var leagueName     : UILabel!
    @IBOutlet weak var leagueContinent: UILabel!
    @IBOutlet weak var collectionView : UICollectionView!
    
    //  Variables
    var comptetionId                :Int?
    var comptetionName              :String?
    var continentName               :String?
    var comptetionsDetailsViewModel : ComptetionsDetailsViewModel?
    let disposeBag                  = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        leagueContinent.text        = continentName
        leagueName.text             = comptetionName
        comptetionsDetailsViewModel = ComptetionsDetailsViewModel()
        setupCollectionView()
        subscribeToResponse()
        subscribeToSelection()
        subscribeToLoading()
        getComptetionsDetails()
    }
    
    //  Configure CollectionView & CompostotionalLayout
    func setupCollectionView() {
        collectionView.register(UINib(nibName: "ComptetionsDetailsCell", bundle: nil), forCellWithReuseIdentifier: "ComptetionsDetailsCell")
        collectionView.collectionViewLayout = ComposotionalLayout
            .createcompositionalLayout()
    }
    
    func subscribeToLoading() {
        comptetionsDetailsViewModel?.loadingBehavior.subscribe(onNext: { (isLoading) in
            if isLoading {
                AppAnimation.playAnimation(onView: self.view)
                self.collectionView.isHidden = true
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: {
                    self.collectionView.isHidden = false
                    AppAnimation.dismissAnimation()
                    
                })
            }
        }).disposed(by: disposeBag)
    }
    
    func subscribeToResponse() {
        self.comptetionsDetailsViewModel?.comptetionsDetailsModelObservable
            .bind(to: self.collectionView
                .rx
                .items(cellIdentifier: "ComptetionsDetailsCell",
                       cellType: ComptetionsDetailsCell.self)) { item, comptetionsDetails, cell in
                print(item)
                cell.comptetionName?.text = self.comptetionName ?? ""
                
                cell.comptetionDetailsLongName.text = comptetionsDetails.name
                
                cell.comptetionDetailsShortName.text = comptetionsDetails.shortName ?? ""
                if let url = URL(string: comptetionsDetails.crestUrl ?? "") {
                    let placeholder = UIImage(named: "placeholder")
                    let options : KingfisherOptionsInfo = [KingfisherOptionsInfoItem.transition(.fade(0.1))]
                    cell.comptetionsDetailsImageView.kf.indicatorType = .activity
                    cell.comptetionsDetailsImageView.kf.setImage(with: url,placeholder: placeholder,options: options)
                }
                
            }
                       .disposed(by: disposeBag)
    }
    
    func subscribeToSelection() {
        Observable
            .zip(collectionView.rx.itemSelected, collectionView.rx.modelSelected(Teams.self))
            .bind { [weak self] selectedIndex, team in
                guard let self = self else {return}
                let storyboard = UIStoryboard(name: "TeamDetails", bundle: nil)
                let teamInfoVC = storyboard.instantiateViewController(withIdentifier: "TeamInfoVC") as! TeamInfoVC
                teamInfoVC.teamId    = team.id
                teamInfoVC.teamImage = team.crestUrl
                teamInfoVC.teamShortName = team.shortName
                teamInfoVC.teamLongName = team.name
                teamInfoVC.teamAddress = team.address
                self.navigationController?.show(teamInfoVC, sender: self)
        }
        .disposed(by: disposeBag)
    }
    
    func getComptetionsDetails(){
        comptetionsDetailsViewModel?.getComptetionsDetails(ComptetionId: self.comptetionId ?? 0)
    }

}
