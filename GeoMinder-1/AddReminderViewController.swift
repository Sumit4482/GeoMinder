//
//  AddReminderViewController.swift
//  GeoMinder-1
//
//  Created by E5000855 on 28/06/24.
//
import UIKit
import MapKit

class AddReminderViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.font = .systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    
    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter reminder title"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let latitudeLabel: UILabel = {
        let label = UILabel()
        label.text = "Latitude"
        label.font = .systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    
    private let latitudeTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter latitude"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .decimalPad
        return textField
    }()
    
    private let longitudeLabel: UILabel = {
        let label = UILabel()
        label.text = "Longitude"
        label.font = .systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    
    private let longitudeTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter longitude"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .decimalPad
        return textField
    }()
    
    private let mapButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select Location on Map", for: .normal)
        button.addTarget(self, action: #selector(didTapMapButton), for: .touchUpInside)
        return button
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save Reminder", for: .normal)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
        return button
    }()
    
    private var locationManager: CLLocationManager?
    private var selectedCoordinate: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(titleTextField)
        view.addSubview(latitudeLabel)
        view.addSubview(latitudeTextField)
        view.addSubview(longitudeLabel)
        view.addSubview(longitudeTextField)
        view.addSubview(mapButton)
        view.addSubview(saveButton)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        latitudeLabel.translatesAutoresizingMaskIntoConstraints = false
        latitudeTextField.translatesAutoresizingMaskIntoConstraints = false
        longitudeLabel.translatesAutoresizingMaskIntoConstraints = false
        longitudeTextField.translatesAutoresizingMaskIntoConstraints = false
        mapButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            titleTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            titleTextField.heightAnchor.constraint(equalToConstant: 40),
            
            latitudeLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 20),
            latitudeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            latitudeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            latitudeTextField.topAnchor.constraint(equalTo: latitudeLabel.bottomAnchor, constant: 8),
            latitudeTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            latitudeTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            latitudeTextField.heightAnchor.constraint(equalToConstant: 40),
            
            longitudeLabel.topAnchor.constraint(equalTo: latitudeTextField.bottomAnchor, constant: 20),
            longitudeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            longitudeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            longitudeTextField.topAnchor.constraint(equalTo: longitudeLabel.bottomAnchor, constant: 8),
            longitudeTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            longitudeTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            longitudeTextField.heightAnchor.constraint(equalToConstant: 40),
            
            mapButton.topAnchor.constraint(equalTo: longitudeTextField.bottomAnchor, constant: 20),
            mapButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mapButton.heightAnchor.constraint(equalToConstant: 40),
            
            saveButton.topAnchor.constraint(equalTo: mapButton.bottomAnchor, constant: 20),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: 200),
            saveButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func didTapMapButton() {
        let mapVC = MapViewController()
        mapVC.delegate = self
        navigationController?.pushViewController(mapVC, animated: true)
    }
    
    @objc private func didTapSaveButton() {
        guard let title = titleTextField.text, !title.isEmpty,
              let latitudeText = latitudeTextField.text, let latitude = Double(latitudeText),
              let longitudeText = longitudeTextField.text, let longitude = Double(longitudeText) else {
            let alert = UIAlertController(title: "Error", message: "Please enter all fields correctly", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        
        CoreDataManager.shared.addReminder(title: title, latitude: latitude, longitude: longitude)
        navigationController?.popViewController(animated: true)
    }
}

extension AddReminderViewController: MapViewControllerDelegate {
    func didSelectLocation(coordinate: CLLocationCoordinate2D) {
        selectedCoordinate = coordinate
        latitudeTextField.text = "\(coordinate.latitude)"
        longitudeTextField.text = "\(coordinate.longitude)"
    }
}
