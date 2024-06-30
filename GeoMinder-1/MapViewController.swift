import UIKit
import MapKit

protocol MapViewControllerDelegate: AnyObject {
    func didSelectLocation(coordinate: CLLocationCoordinate2D)
}

class MapViewController: UIViewController {
    
    weak var delegate: MapViewControllerDelegate?
    
    private let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.isUserInteractionEnabled = true
        return mapView
    }()
    
    private let zoomInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("+", for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 25
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let zoomOutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("-", for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 25
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search for places"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapMap(_:)))
        mapView.addGestureRecognizer(tapGesture)
        
        zoomInButton.addTarget(self, action: #selector(zoomIn), for: .touchUpInside)
        zoomOutButton.addTarget(self, action: #selector(zoomOut), for: .touchUpInside)
        searchBar.delegate = self
    }
    
    private func setupUI() {
        view.addSubview(mapView)
        view.addSubview(zoomInButton)
        view.addSubview(zoomOutButton)
        view.addSubview(searchBar)
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            zoomInButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            zoomInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            zoomInButton.widthAnchor.constraint(equalToConstant: 50),
            zoomInButton.heightAnchor.constraint(equalToConstant: 50),
            
            zoomOutButton.bottomAnchor.constraint(equalTo: zoomInButton.topAnchor, constant: -20),
            zoomOutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            zoomOutButton.widthAnchor.constraint(equalToConstant: 50),
            zoomOutButton.heightAnchor.constraint(equalToConstant: 50),
            
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    @objc private func didTapMap(_ gesture: UITapGestureRecognizer) {
        let locationInView = gesture.location(in: mapView)
        let coordinate = mapView.convert(locationInView, toCoordinateFrom: mapView)
        
        delegate?.didSelectLocation(coordinate: coordinate)
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func zoomIn() {
        let region = mapView.region
        let span = MKCoordinateSpan(latitudeDelta: region.span.latitudeDelta / 2, longitudeDelta: region.span.longitudeDelta / 2)
        let newRegion = MKCoordinateRegion(center: region.center, span: span)
        mapView.setRegion(newRegion, animated: true)
    }
    
    @objc private func zoomOut() {
        let region = mapView.region
        let span = MKCoordinateSpan(latitudeDelta: region.span.latitudeDelta * 2, longitudeDelta: region.span.longitudeDelta * 2)
        let newRegion = MKCoordinateRegion(center: region.center, span: span)
        mapView.setRegion(newRegion, animated: true)
    }
}

extension MapViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        
        searchBar.resignFirstResponder()
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        
        let search = MKLocalSearch(request: request)
        search.start { [weak self] response, error in
            guard let self = self else { return }
            guard let response = response, error == nil else {
                print("Search error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            let matchingItems = response.mapItems
            if let firstItem = matchingItems.first {
                let coordinate = firstItem.placemark.coordinate
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = firstItem.name
                self.mapView.addAnnotation(annotation)
                self.mapView.setRegion(MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000), animated: true)
            }
        }
    }
}
