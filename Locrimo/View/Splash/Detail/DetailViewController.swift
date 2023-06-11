//
//  DetailViewController.swift
//  Locrimo
//
//  Created by Muhammed Enes Kılıçlı on 16.03.2023.
//

import UIKit

class DetailViewController: BaseViewController {
    
    enum Orientation {
        case portrait
        case lanscape
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var imageContainer: UIView!
    @IBOutlet weak var infoContainer: UIView!
    
    var portraitLayout = [NSLayoutConstraint]()
    var landscapeLayout = [NSLayoutConstraint]()
    var orientation = Orientation.portrait
    
    private var viewModel: DetailViewModel!
    var characterData: Character?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContainerConstraints()
        setupUIForContainers()
        setupTableView()
        viewModel.start()
        
        if let characterDetails = characterData {
            viewModel.setCharacter(character: characterDetails)
        }
    }
    
    func inject(viewModel: DetailViewModel) {
        self.viewModel = viewModel
    }
    
    override func viewWillLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setOrientation()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setContainerConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let characterName = viewModel.getCharacterName()
        setupNavBar(title: characterName, leftIcon: "chevron.backward", rightIcon: nil)
        viewModel.parseCharacterData()
        setImageViewData()
    }
    
    private func setupUIForContainers() {
        characterImageView.translatesAutoresizingMaskIntoConstraints = false
        characterImageView.centerYAnchor.constraint(equalTo: imageContainer.centerYAnchor).isActive = true
        characterImageView.centerXAnchor.constraint(equalTo: imageContainer.centerXAnchor).isActive = true
        characterImageView.heightAnchor.constraint(equalToConstant: 275).isActive = true
        characterImageView.widthAnchor.constraint(equalToConstant: 275).isActive = true
        characterImageView.cornerRadius = 10
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: infoContainer.topAnchor, constant: 20).isActive = true
        tableView.leadingAnchor.constraint(equalTo: infoContainer.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: infoContainer.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: infoContainer.bottomAnchor, constant: -20).isActive = true
    }
    
    private func setupContainerConstraints() {
        imageContainer.translatesAutoresizingMaskIntoConstraints = false
        infoContainer.translatesAutoresizingMaskIntoConstraints = false
        
        portraitLayout.append(imageContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor))
        portraitLayout.append(imageContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor))
        portraitLayout.append(imageContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor))
        portraitLayout.append(imageContainer.bottomAnchor.constraint(equalTo: infoContainer.topAnchor))
        
        portraitLayout.append(infoContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor))
        portraitLayout.append(infoContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor))
        portraitLayout.append(infoContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor))
        
        portraitLayout.append(imageContainer.heightAnchor.constraint(equalTo: infoContainer.heightAnchor))
        
        landscapeLayout.append(imageContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor))
        landscapeLayout.append(imageContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor))
        landscapeLayout.append(imageContainer.trailingAnchor.constraint(equalTo: infoContainer.leadingAnchor))
        landscapeLayout.append(imageContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor))
        
        landscapeLayout.append(infoContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor))
        landscapeLayout.append(infoContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor))
        landscapeLayout.append(infoContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor))
        
        landscapeLayout.append(imageContainer.widthAnchor.constraint(equalTo: infoContainer.widthAnchor))
    }
    
    private func setOrientation() {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        if screenHeight > screenWidth {
            orientation = Orientation.portrait
        } else if screenHeight < screenWidth {
            orientation = Orientation.lanscape
        } else {
            orientation = Orientation.portrait
        }
    }
    
    private func setContainerConstraints() {
        if orientation == .portrait {
            NSLayoutConstraint.deactivate(landscapeLayout)
            NSLayoutConstraint.activate(portraitLayout)
        }
        if orientation == .lanscape {
            NSLayoutConstraint.deactivate(portraitLayout)
            NSLayoutConstraint.activate(landscapeLayout)
        }
        
        self.view.layoutIfNeeded()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(cellType: DetailTableViewCell.self)
    }
    /*
    private func configureTableViewScroll() {
        tableView.isScrollEnabled = tableView.contentSize.height > tableView.frame.height;
        //Table_rowcount * rowheight > tableview.frame.size.height;
        
        print(tableView.visibleSize)
        print("tableView.contentSize.height: " + String(Double(tableView.contentSize.height)))
        print("tableView.frame.height: " + String(Double(tableView.frame.height)))
    }
    */
    private func setImageViewData() {
        let photoUrl = URL(string: viewModel.getCharacterImageURL())
        DispatchQueue.main.async { [weak self] in
            self?.characterImageView.kf.setImage(with: photoUrl)
        }
    }
    
}

// MARK: - TableView Delegate & DataSource
extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfElementsForTableView()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let detail = viewModel.getDetailForCell(at: indexPath) else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailTableViewCell.className, for: indexPath) as! DetailTableViewCell
        cell.setupCell(title: detail.title, text: detail.text)
        return cell
    }
    
}

// MARK: - ViewModel Listener
extension DetailViewController {
    func addObservationListener() {
        self.viewModel.stateClosure = { [weak self] result in
            switch result {
            case .success(let data):
                self?.handleClosureData(data: data)
            case .failure(_):
                break
            }
        }
    }
    
    private func handleClosureData(data: DetailViewModelImpl.ViewInteractivity) {
        switch data {
        case .setDetails:
            self.tableView.reloadData()
        }
    }
}
