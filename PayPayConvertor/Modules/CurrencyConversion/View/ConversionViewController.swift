//
//  ConversionViewController.swift
//  PayPayConvertor
//
//  Created by Yuvaraj Selvam on 13/01/24.
//

import Foundation
import UIKit
import Alamofire

/**
 A view controller for handling currency conversion.
 */
class ConversionViewController: BaseViewController {
    //MARK: Properties
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collection.showsVerticalScrollIndicator = false
        collection.backgroundColor = .clear
        return collection
    }()
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "background")
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private lazy var conversionView: ConversionView = {
        let view = ConversionView()
        if let currency = Preference.shared.currency {
            view.configure(currency: currency)
        }
        view.backgroundColor = .white
        view.setText(as: "1")
        view.delegate = self
        return view
    }()
    
    private lazy var searchBar: UISearchBar = {
        let search = UISearchBar()
        search.delegate = self
        search.searchBarStyle = .minimal
        search.placeholder = "Search for a currency"
        return search
    }()
    
    private lazy var containerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 8
        return stack
    }()
    
    private var dataSource: UICollectionViewDiffableDataSource<ConversionSection, ConversionRow>!
    private var searchQuery: String? = nil
    let presenter: CurrencyConversionPresenterProtocol
    
/**
     Initializes the ConversionController with a presenter.
     
     - Parameters:
        - presenter: The presenter for handling currency conversion logic.
     */
    init(presenter: CurrencyConversionPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable, message: "use `init(presenter: )` instead")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var dismissKeyboardOnTap: Bool { true }
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.setupDataSource()
        self.presenter.getRates(for: 1)
    }
    
    //MARK: Private methods
    private func setupView() {
        title = "PayPay Convertor"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .white
        view.addSubview(backgroundImageView)
        view.addSubview(containerStackView)
        view.isShimmering = true
        view.isUserInteractionEnabled = false
        containerStackView.addArrangedSubview(conversionView)
        containerStackView.addArrangedSubview(searchBar)
        containerStackView.addArrangedSubview(collectionView)
        
        containerStackView.snp.makeConstraints({ make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.bottom.equalToSuperview()
        })
        backgroundImageView.snp.makeConstraints({ $0.edges.equalToSuperview() })
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int,
            layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .absolute(64))
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
        let cellRegistration = UICollectionView.CellRegistration<ConversionCell, ConversionRow> { cell, indexPath, item in
            cell.configure(currency: item.currencyCode, value: item.value)
        }
        
        dataSource = UICollectionViewDiffableDataSource<ConversionSection, ConversionRow>(collectionView: collectionView) { collectionView, indexPath, item in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }
    }
    
    private func search() {
        let rows = presenter.section.rows.filter({ $0.contains(searchQuery) }).sorted { $0.currencyCode < $1.currencyCode }
        var snapshot = NSDiffableDataSourceSnapshot<ConversionSection, ConversionRow>()
        snapshot.appendSections([presenter.section])
        snapshot.appendItems(rows, toSection: presenter.section)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

//MARK: SearchDelegate Extension
extension ConversionViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchQuery = searchText
        self.search()
    }
}

//MARK: ConversionViewDelegate Extension
extension ConversionViewController: ConversionViewDelegate {
    func didEnterValue(as value: Double) {
        presenter.getRates(for: value)
    }
    
    func didTapChangeCurrency() {
        guard let navigationController else { return }
        presenter.moveToSearch(with: navigationController, delegate: self)
    }
}

//MARK: CurrencyChooserDelegate Extension
extension ConversionViewController: CurrencyChooserDelegate {
    func didChooseCurrency() {
        guard let currency = Preference.shared.currency else { return }
        self.conversionView.configure(currency: currency)
        self.presenter.getRates(for: nil)
    }
}

//MARK: CurrencyConversionViewProtocol Extension
extension ConversionViewController: CurrencyConversionViewProtocol {
    func dataDidLoad() {
        self.view.isShimmering = false
        self.view.isUserInteractionEnabled = true
        self.search()
    }
    
    func dataDidFail(with error: AFError) {
        self.presentAlert(title: "Oops, something went wrong", message: error.localizedDescription)
    }
}
