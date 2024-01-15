//
//  SearchViewController.swift
//  PayPayConvertor
//
//  Created by Yuvaraj Selvam on 13/01/24.
//

import Foundation
import UIKit
import Alamofire
import SnapKit

protocol CurrencyChooserDelegate: AnyObject {
    func didChooseCurrency()
}

/**
 A view controller for searching and choosing currencies.
 */
class SearchViewController: BaseViewController {
    //MARK: Properties
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collection.showsVerticalScrollIndicator = false
        collection.backgroundColor = .clear
        collection.delegate = self
        return collection
    }()
    
    private lazy var searchBar = {
        let search = UISearchBar()
        search.delegate = self
        search.placeholder = "Search for a currency"
        return search
    }()
    
    private var dataSource: UICollectionViewDiffableDataSource<CurrencySection, CurrencyRow>!
    weak var delegate: CurrencyChooserDelegate?
    let presenter: CurrencySearchPresenterProtocol
    
/**
     Initializes a new instance of `SearchController`.
     
     - Parameter presenter: The presenter for currency search logic.
     */
    init(presenter: CurrencySearchPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable, message: "use `init(presenter: )` instead")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.setupDataSource()
        self.presenter.getAvailableCurrencies()
    }
    
    //MARK: Private methods
    private func setupView() {
        title = "Choose a currency"
        view.backgroundColor = .white
        view.addSubview(collectionView)
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints({ make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        })
        collectionView.snp.makeConstraints({ make in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        })
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int,
            layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .absolute(32))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.interItemSpacing = .fixed(16)
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 10
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            return section
        }
        return layout
    }
    
    private func setupDataSource() {
        let currencyCellRegistration = UICollectionView.CellRegistration<CurrencyCell, CurrencyRow> { cell, indexPath, item in
            cell.configure(with: "(\(item.code)) \(item.fullName)")
        }
        
        dataSource = UICollectionViewDiffableDataSource<CurrencySection, CurrencyRow>(collectionView: collectionView) { collectionView, indexPath, item in
            return collectionView.dequeueConfiguredReusableCell(using: currencyCellRegistration, for: indexPath, item: item)
        }
    }
    
    private func search(with filter: String? = nil) {
        let rows = presenter.section.rows.filter({ $0.contains(filter) }).sorted { $0.code < $1.code }
        var snapshot = NSDiffableDataSourceSnapshot<CurrencySection, CurrencyRow>()
        snapshot.appendSections([presenter.section])
        snapshot.appendItems(rows, toSection: presenter.section)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

//MARK: UICollectionViewDelegate Extension
extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = dataSource.itemIdentifier(for: indexPath)
        Preference.shared.currency = item?.code
        delegate?.didChooseCurrency()
        navigationController?.popViewController(animated: true)
    }
}

//MARK: UISearchBarDelegate Extension
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.search(with: searchText)
    }
}

//MARK: CurrencySearchViewProtocol Extension
extension SearchViewController: CurrencySearchViewProtocol {
    func dataDidLoad() {
        self.search()
    }
    
    func dataDidFail(with error: AFError) {
        self.presentAlert(title: "Oops, something went wrong", message: error.localizedDescription)
    }
}
