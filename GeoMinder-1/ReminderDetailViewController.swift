import UIKit
import MapKit
import CoreLocation

class ReminderDetailViewController: UIViewController {
    
    var reminder: Reminder?
    let locationManager = CLLocationManager()
    
    private let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    private let zoomInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Zoom In", for: .normal)
        button.addTarget(self, action: #selector(zoomIn), for: .touchUpInside)
        return button
    }()
    
    private let zoomOutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Zoom Out", for: .normal)
        button.addTarget(self, action: #selector(zoomOut), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Reminder Detail"
        
        setupMapView()
        setupZoomButtons()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    private func setupMapView() {
        guard let reminder = reminder else { return }
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .none
        
        view.addSubview(mapView)
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        

        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: reminder.latitude, longitude: reminder.longitude)
        annotation.title = reminder.title
        
        mapView.addAnnotation(annotation)
        

        let circle = MKCircle(center: annotation.coordinate, radius: 2000) // 2 km
        mapView.addOverlay(circle)
        
        // Set initial region and zoom level 4 km x 4 km region
        let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 4000, longitudinalMeters: 4000)
        mapView.setRegion(region, animated: true)
    }
    
    private func setupZoomButtons() {
        view.addSubview(zoomInButton)
        view.addSubview(zoomOutButton)
        
        zoomInButton.translatesAutoresizingMaskIntoConstraints = false
        zoomOutButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            zoomInButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            zoomInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            zoomOutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            zoomOutButton.trailingAnchor.constraint(equalTo: zoomInButton.leadingAnchor, constant: -20)
        ])
    }
    
    @objc private func zoomIn() {
        var region = mapView.region
        region.span.latitudeDelta /= 2.0
        region.span.longitudeDelta /= 2.0
        mapView.setRegion(region, animated: true)
    }
    
    @objc private func zoomOut() {
        var region = mapView.region
        region.span.latitudeDelta *= 2.0
        region.span.longitudeDelta *= 2.0
        mapView.setRegion(region, animated: true)
    }
}

extension ReminderDetailViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let circleOverlay = overlay as? MKCircle {
            let circleRenderer = MKCircleRenderer(circle: circleOverlay)
            circleRenderer.strokeColor = .red
            circleRenderer.fillColor = UIColor.red.withAlphaComponent(0.2)
            circleRenderer.lineWidth = 1
            return circleRenderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
}

extension ReminderDetailViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            // Handle authorized status
            mapView.showsUserLocation = true
            mapView.userTrackingMode = .none
        case .denied, .restricted:
            print("Location access denied or restricted. Please enable location services for this app.")
        case .notDetermined:

            break
        @unknown default:
            break
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager did fail with error: \(error.localizedDescription)")
    }
}

