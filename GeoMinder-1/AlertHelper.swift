import UIKit

typealias EditReminderCompletion = (String, Double, Double) -> Void

class AlertHelper {
    
    static func showEditAlert(for reminder: Reminder, completion: @escaping EditReminderCompletion) -> UIAlertController {
        let alertController = UIAlertController(title: "Edit Reminder", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter Title"
            textField.text = reminder.title
            textField.font = UIFont.systemFont(ofSize: 15)
            textField.borderStyle = .roundedRect
        }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter Latitude"
            textField.text = String(format: "%.6f", reminder.latitude)
            textField.keyboardType = .numbersAndPunctuation
            textField.font = UIFont.systemFont(ofSize: 15)
            textField.borderStyle = .roundedRect
        }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter Longitude"
            textField.text = String(format: "%.6f", reminder.longitude)
            textField.keyboardType = .numbersAndPunctuation
            textField.font = UIFont.systemFont(ofSize: 15)
            textField.borderStyle = .roundedRect
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { (_) in
            guard let title = alertController.textFields?[0].text, !title.isEmpty,
                  let latitudeStr = alertController.textFields?[1].text, let latitude = Double(latitudeStr),
                  let longitudeStr = alertController.textFields?[2].text, let longitude = Double(longitudeStr) else {
                return
            }
            
            completion(title, latitude, longitude)
        }
        
        alertController.addAction(saveAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        return alertController
    }
}
