//
//  SearchViewModel.swift
//  Locrimo
//
//  Created by Muhammed Enes Kılıçlı on 16.03.2023.
//

import Foundation
import Alamofire

protocol SearchViewModel: BaseViewModel {
    /// ViewModel ' den viewController' a eventleri tetitkler.
    var stateClosureForInitial: ((Result<SearchViewModelImpl.ViewInteractivity, Error>) -> ())? { set get }
    var stateClosureForLocations: ((Result<SearchViewModelImpl.ViewInteractivity, Error>) -> ())? { set get }
    var stateClosureForCharacters: ((Result<SearchViewModelImpl.ViewInteractivity, Error>) -> ())? { set get }
    
    /// ViewController' daki tableView'in row sayısını döner.
    /// - Returns: Int
    func getNumberOfElementsForTableView() -> Int
    
    /// ViewController' daki collectionView'in column sayısını döner.
    /// - Returns: Int
    func getNumberOfElementsForCollectionView() -> Int
    
    /// ViewController' daki tableView için cell datasını döner.
    /// - Parameter indexPath: Görünür cell'in index'i
    func getCharacterForCell(at indexPath: IndexPath) -> Character?
    
    /// ViewController' daki collectionView için cell datasını döner.
    /// - Parameter indexPath: Görünür cell'in index'i
    func getLocationForCell(at indexPath: IndexPath) -> Location?
    
    /// - Returns: Character data
    func getCharacters(location: Location)
    
    /// - Returns: Location data
    func getMoreLocations()

    /// - Returns: Location data + Character data
    func getInitialData()
    
    /// - characterList array'ini temizler.
    func cleanCharacterArray()
    
    /// - locationList array'ini temizler.
    func cleanLocationArray()
    
    func changeSelectedLocation(location: Location)
    func isSelectedLocation(location: Location) -> Bool
    func thereAreNoLocationsLeft() -> Bool
}

final class SearchViewModelImpl: SearchViewModel {
    
    enum DefaultEndPoints: String {
        case locationURL = "https://rickandmortyapi.com/api/location?page=1"
        case characterURL = "https://rickandmortyapi.com/api/character/"
    }
    
    private var locationSearchResult : SearchLocation?
    private var locationList : [Location] = []
    private var characterList : [Character] = []
    
    private var selectedLocation: Location?
    
    var stateClosureForInitial: ((Result<ViewInteractivity, Error>) -> ())?
    var stateClosureForLocations: ((Result<ViewInteractivity, Error>) -> ())?
    var stateClosureForCharacters: ((Result<ViewInteractivity, Error>) -> ())?
    
    var noMoreLocationLeft = false
    
    private func getCharacterIds(location: Location) -> String {
        var ids = String()
        
        for resident in location.residents {
            if let creature = resident {
                //"https://rickandmortyapi.com/api/character/1"
                let parsed = creature.replacingOccurrences(of: "https://rickandmortyapi.com/api/character/", with: "")
                ids += parsed + ","
            }
        }
        
        if !ids.isEmpty {
            ids.removeLast()
        }
        
        return ids
    }
    
    func getCharacters(location: Location) {
        cleanCharacterArray()
        
        let ids = getCharacterIds(location: location)
        if ids.isEmpty {
            self.updateCharacters()
            return
        }
        
        AF.request(DefaultEndPoints.characterURL.rawValue + "\(ids)", method: .get).response { response in
            if let data = response.data {
                do {
                    let decodedSearchCharacterData = try JSONDecoder().decode(SearchCharacter.self, from: data)
                    self.characterList.append(contentsOf: decodedSearchCharacterData)
                    self.updateCharacters()
                } catch {
                    self.updateCharacters()
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func getMoreLocations() {
        guard let nextLocationSearchURLString = locationSearchResult?.info.next else {
            self.updateLocations()
            return
        }
        
        AF.request(nextLocationSearchURLString, method: .get).response { response in
            if let data = response.data {
                do {
                    let decodedSearchLocationData = try JSONDecoder().decode(SearchLocation.self, from: data)
                    self.locationList.append(contentsOf: decodedSearchLocationData.results)
                    self.locationSearchResult = decodedSearchLocationData
                    if self.locationSearchResult?.info.next == nil { self.noMoreLocationLeft = true }
                    self.updateLocations()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func getInitialData() {
        
        AF.request(DefaultEndPoints.locationURL.rawValue, method: .get).response { locationResponse in
            if let locationData = locationResponse.data {
                do {
                    let decodedSearchLocationData = try JSONDecoder().decode(SearchLocation.self, from: locationData)
                    self.locationList.append(contentsOf: decodedSearchLocationData.results)
                    self.locationSearchResult = decodedSearchLocationData
                    
                    if let firstLocationOnTheList = self.locationList.first {
                        
                        let ids = self.getCharacterIds(location: firstLocationOnTheList)
                        if ids.isEmpty { return }
                  
                        self.cleanCharacterArray()
                        self.setSelectedLocation(location: firstLocationOnTheList)
                        
                        AF.request(DefaultEndPoints.characterURL.rawValue + "\(ids)", method: .get).response { characterResponse in
                            if let characterData = characterResponse.data {
                                do{
                                    let decodedSearchCharacterData = try JSONDecoder().decode(SearchCharacter.self, from: characterData)
                                    self.characterList.append(contentsOf: decodedSearchCharacterData)
                                    self.start()
                                } catch {
                                    print(error.localizedDescription)
                                }
                            }
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func cleanCharacterArray() {
        characterList.removeAll()
    }
    
    func cleanLocationArray() {
        locationList.removeAll()
    }
    
    func start() {
        self.stateClosureForInitial?(.success(.getInitialData))
    }
    
    func updateLocations() {
        self.stateClosureForLocations?(.success(.updateLocationList))
    }
    
    func updateCharacters() {
        self.stateClosureForCharacters?(.success(.updateCharacterList))
    }
    
    func isSelectedLocation(location: Location) -> Bool {
        return self.selectedLocation!.name == location.name
    }
    
    func thereAreNoLocationsLeft() -> Bool{
        return self.noMoreLocationLeft
    }
    
    func changeSelectedLocation(location: Location) {
        self.selectedLocation = location
    }
    
    private func setSelectedLocation(location: Location) {
        self.selectedLocation = location
    }
    
}

// MARK: ViewModel to ViewController interactivity
extension SearchViewModelImpl {
    enum ViewInteractivity {
        case updateCharacterList
        case updateLocationList
        case getInitialData
    }
}

// MARK: - TableView DataSource
extension SearchViewModelImpl {
    func getNumberOfElementsForTableView() -> Int {
        return self.characterList.count
    }
    
    func getCharacterForCell(at indexPath: IndexPath) -> Character? {
        guard let character = self.characterList[indexPath.row] as Character? else {return nil}
        return character
    }
}

// MARK: - CollectionView DataSource
extension SearchViewModelImpl {
    func getNumberOfElementsForCollectionView() -> Int {
        return self.locationList.count
    }
    
    func getLocationForCell(at indexPath: IndexPath) -> Location? {
        guard let location = self.locationList[indexPath.row] as Location? else {return nil}
        return location
    }
}
