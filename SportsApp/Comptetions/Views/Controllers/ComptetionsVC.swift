//
//  ComptetionsVC.swift
//  SportsApp
//
//  Created by Abdallah Eslah on 14/10/2022.
//

import UIKit
import RxSwift
import RxCocoa
import Reachability

class ComptetionsVC: UIViewController ,UITableViewDelegate{

    @IBOutlet weak var tableView: UITableView!
    
    var searchBar = UISearchBar()
    
    //  Variables
    //var comptetionsViewModel     : ComptetionsViewModel?
    let disposeBag               = DisposeBag()
    
    //  For Connection
    let conncetion               = ConnectionManager.sharedInstance
    var reachbility              : Reachability?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //comptetionsViewModel = ComptetionsViewModel()
        setupTableView()
        subscribeToResponse()
        subscribeToSelection()
        subscribeToLoading()
        checkConnection()
    }
    
    func checkConnection(){
        reachbility = try! Reachability()
        conncetion.reachability.whenReachable = { reachability in
            Helper.displayMessage(message: "There is An Internet Connection ✅..Getting Data From Internet", messageError: false)
            self.getComptetions()
        }
        
        // If No Connection
        conncetion.reachability.whenUnreachable = { reachability in
            Helper.displayMessage(message: "No Internet Connection !..Getting Data From Local Storage", messageError: true)
            // Loading These Actions After 3 Seconds
            DispatchQueue.main.asyncAfter(deadline: .now()+3, execute: {
                //ArraysManager.coreDataArray.removeAll()
//                ComptetionsViewModel.comptetionsModelSubject.
                ComptetionsViewModel.comptetionsModelSubject = CoreDataManager.shared.fetchComptitionsData()
            })
        }
    }
    
    func setupTableView() {
        //  Like => tableView.dataSource = self
        tableView.register(UINib(nibName: "ComptetionsCell", bundle: nil), forCellReuseIdentifier: "ComptetionsCell")
    }
    
    func subscribeToLoading() {
        ComptetionsViewModel.loadingBehavior.subscribe(onNext: { (isLoading) in
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
        
        ComptetionsViewModel.comptetionsModelObservable
            .bind(to: self.tableView
                .rx
                .items(cellIdentifier: "ComptetionsCell",
                       cellType: ComptetionsCell.self)) { row, comptetions, cell in
                print(row)
                cell.comptetionLeagueName?.text = comptetions.name
                
                 //comptetions.currentSeason?.winner?.shortName
                    cell.comptetionShortTeamName.text = comptetions.currentSeason?.winner?.shortName ?? ""
                 //comptetions.currentSeason?.winner?.name
                    cell.comptetionLongTeamName.text = comptetions.currentSeason?.winner?.name ?? ""
                
            }
                       .disposed(by: disposeBag)
    }
    
    func subscribeToSelection() {
        Observable
            .zip(tableView.rx.itemSelected, tableView.rx.modelSelected(Competitions.self))
            .bind { [weak self] selectedIndex, comptetions in
               // guard let vc = UIStoryboard(name: "ComptetionsDetails", bundle: nil).instantiateViewController(withIdentifier: "ComptetionsDetailsVC") as? ComptetionsDetailsVC else {return}
                let storyboard = UIStoryboard(name: "ComptetionsDetails", bundle: nil)
                let comptetionsDetailsVC = storyboard.instantiateViewController(withIdentifier: "ComptetionsDetailsVC") as! ComptetionsDetailsVC
                comptetionsDetailsVC.comptetionId    = comptetions.id
                comptetionsDetailsVC.comptetionName  = comptetions.name
                comptetionsDetailsVC.continentName   = comptetions.area?.name
                self?.navigationController?.show(comptetionsDetailsVC, sender: self)
                print(selectedIndex, comptetions.id ?? 0)
        }
        .disposed(by: disposeBag)
    }
    
    func getComptetions(){
        ComptetionsViewModel.getComptetions()
    }
    
    
}
