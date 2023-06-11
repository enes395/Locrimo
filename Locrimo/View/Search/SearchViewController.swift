//
//  SearchViewController.swift
//  Locrimo
//
//  Created by Muhammed Enes Kılıçlı on 16.03.2023.
//

import UIKit

class SearchViewController: BaseViewController {
    
    @IBOutlet weak var topContentView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel: SearchViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupTableView()
        setupCollectionView()
        setupCollectionFlowLayout()
        addObservationListener()
        viewModel.start()
        viewModel.getInitialData()
    }
    
    
    func inject(viewModel: SearchViewModel) {
        self.viewModel = viewModel
    }
    
    private func setupView() {
        imageView.image = UIImage(named: "titleImage.png")
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellType: CharacterTableViewCell.self)
        tableView.estimatedRowHeight = 100
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
      
        collectionView.register(cellType: LocationCollectionViewCell.self)
        collectionView.register(cellType: IndicatorCollectionViewCell.self)
    }
    
    private func setupCollectionFlowLayout() {
        let collectionFlowLayout = UICollectionViewFlowLayout()
        collectionFlowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        collectionFlowLayout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = collectionFlowLayout
        collectionView.layoutIfNeeded()
    }
    
}

// MARK: - TableView Delegate & DataSource
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfElementsForTableView()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let character = viewModel.getCharacterForCell(at: indexPath) else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: CharacterTableViewCell.className, for: indexPath) as! CharacterTableViewCell
        cell.setupCell(character: character)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSection = 0
        
        if viewModel.getNumberOfElementsForTableView() > 0 {
            self.tableView.backgroundView = nil
            numOfSection = 1
        } else {
            let noDataLabel: UILabel = UILabel(frame: CGRectMake(0, 0, self.tableView.bounds.size.width, self.tableView.bounds.size.height))
            noDataLabel.text = "No Character Found"
            noDataLabel.textColor = .rickGreen
            noDataLabel.textAlignment = .center
            self.tableView.backgroundView = noDataLabel
        }
        
        return numOfSection
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let character = viewModel.getCharacterForCell(at: indexPath)
        let goDetailPage = DetailViewController(nibName: DetailViewController.className, bundle: nil)
        let detailViewModel = DetailViewModelImpl()
        goDetailPage.characterData = character
        goDetailPage.inject(viewModel: detailViewModel)
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(goDetailPage, animated: true)
    }
    
}

// MARK: - CollectionView Delegate & DataSource
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if viewModel.thereAreNoLocationsLeft() {
            return viewModel.getNumberOfElementsForCollectionView()
        } else {
            return viewModel.getNumberOfElementsForCollectionView() + 1
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row != viewModel.getNumberOfElementsForCollectionView() {
            guard let location = viewModel.getLocationForCell(at: indexPath) else { return UICollectionViewCell() }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LocationCollectionViewCell.className, for: indexPath) as! LocationCollectionViewCell
            cell.setupCell(location: location, isSelected: viewModel.isSelectedLocation(location: location))
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IndicatorCollectionViewCell.className, for: indexPath) as! IndicatorCollectionViewCell
            cell.indicator.startAnimating()
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row > 0 && indexPath.row == viewModel.getNumberOfElementsForCollectionView() {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
                DispatchQueue.main.async {
                    self.viewModel.getMoreLocations()
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let location = viewModel.getLocationForCell(at: indexPath) else { return }
        viewModel.changeSelectedLocation(location: location)
        collectionView.reloadData()
        viewModel.getCharacters(location: location)
    }
     
}

// MARK: - ViewModel Listener
extension SearchViewController {
    func addObservationListener() {
        self.viewModel.stateClosureForInitial = { [weak self] result in
            switch result {
            case .success(let data):
                self?.handleClosureData(data: data)
            case .failure(_):
                break
            }
        }
        
        self.viewModel.stateClosureForLocations = { [weak self] result in
            switch result {
            case .success(let data):
                self?.handleClosureData(data: data)
            case .failure(_):
                break
            }
        }
        
        self.viewModel.stateClosureForCharacters = { [weak self] result in
            switch result {
            case .success(let data):
                self?.handleClosureData(data: data)
            case .failure(_):
                break
            }
        }
    }
    
    private func handleClosureData(data: SearchViewModelImpl.ViewInteractivity) {
        switch data {
        case .updateCharacterList:
            self.tableView.reloadData()
        case .updateLocationList:
            self.collectionView.reloadData()
            self.setupCollectionFlowLayout()
        case .getInitialData:
            self.collectionView.reloadData()
            self.tableView.reloadData()
        }
    }
}
