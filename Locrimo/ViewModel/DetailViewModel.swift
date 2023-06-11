//
//  DetailViewModel.swift
//  Locrimo
//
//  Created by Muhammed Enes Kılıçlı on 20.03.2023.
//

import Foundation

struct Information {
    var title: String
    var text: String
}

protocol DetailViewModel: BaseViewModel {
    /// ViewModel ' den viewController' a event tetitkler.
    var stateClosure: ((Result<DetailViewModelImpl.ViewInteractivity, Error>) -> ())? { set get }
    
    /// ViewController' daki tableView'in row sayısını döner.
    /// - Returns: Int
    func getNumberOfElementsForTableView() -> Int
    
    /// ViewController' daki tableView için cell datasını döner.
    /// - Parameter indexPath: Görünür cell'in index'i
    func getDetailForCell(at indexPath: IndexPath) -> Information?
    
    /// InformationList array'ini  oluşturur
    func parseCharacterData()
    
    /// - InformationList array'ini temizler.
    func cleanInformationArray()
    
    /// Character datası oluşturur 
    func setCharacter(character: Character)
    
    /// Character için image url döner
    /// - Returns: String
    func getCharacterImageURL() -> String
    
    /// Character için name döner
    /// - Returns: String
    func getCharacterName() -> String
}

final class DetailViewModelImpl: DetailViewModel {
    
    private var informationList : [Information] = []
    private var character: Character?

    func setCharacter(character: Character) {
        self.character = character
    }

    func parseCharacterData() {
        
        self.cleanInformationArray()
        
        guard let character = character else { self.start(); return }
        
        let status = character.status.capitalized
        let species = character.species.capitalized
        let gender = character.gender.capitalized
        let origin = character.origin.name.capitalized
        let location = character.location.name.capitalized
        
        let episodesArray = character.episode.map({
            $0.replacingOccurrences(of: "https://rickandmortyapi.com/api/episode/", with: "")
        })
        let episodes = episodesArray.joined(separator: ", ")
        
        var createdAt = character.created
        createdAt.removeLast(5)
        createdAt = createdAt.replacingOccurrences(of: "T", with: ", ")
        let createdAtTitle = """
                             Created at
                             (in API):
                             """
        
        informationList.append(Information(title: "Status:", text: status))
        informationList.append(Information(title: "Species:", text: species))
        informationList.append(Information(title: "Gender:", text: gender))
        informationList.append(Information(title: "Origin:", text: origin))
        informationList.append(Information(title: "Location:", text: location))
        informationList.append(Information(title: "Episodes:", text: episodes))
        informationList.append(Information(title: createdAtTitle, text: createdAt))
        
        self.start()
    }
    
    func getCharacterImageURL() -> String {
        guard let character = character else { return String() }
        return character.image
    }
    
    func getCharacterName() -> String {
        guard let character = character else { return String() }
        return character.name
    }
    
    var stateClosure: ((Result<ViewInteractivity, Error>) -> ())?
    
    func start() {
        self.stateClosure?(.success(.setDetails))
    }
    
    func cleanInformationArray() {
        informationList.removeAll()
    }
    
}

// MARK: ViewModel to ViewController interactivity
extension DetailViewModelImpl {
    enum ViewInteractivity {
        case setDetails
    }
}


// MARK: TableView DataSource
extension DetailViewModelImpl {
    func getNumberOfElementsForTableView() -> Int {
        return self.informationList.count
    }
    
    func getDetailForCell(at indexPath: IndexPath) -> Information? {
        guard let info = self.informationList[indexPath.row] as Information? else {return nil}
        return info
    }
    
}
