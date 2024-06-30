import UIKit
import CoreData
import MapKit
import UserNotifications

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private var reminders: [Reminder] = []
    private var locationManager: CLLocationManager?
    private var backgroundTimer: Timer?

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Reminders"
        view.backgroundColor = .white
        setupTableView()
        fetchReminders()
        tableView.register(ReminderTableViewCell.self, forCellReuseIdentifier: "ReminderCell")
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddReminder))
        
        NotificationCenter.default.addObserver(self, selector: #selector(didUpdateLocation(_:)), name: .didUpdateLocation, object: nil)
        
        // Initialise location manager
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        locationManager?.startUpdatingLocation()
        locationManager?.allowsBackgroundLocationUpdates = true
        locationManager?.pausesLocationUpdatesAutomatically = false

        // Starttimer to get loaction every 10 seconds
        backgroundTimer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(fetchUserLocationInBackground), userInfo: nil, repeats: true)
    }

    deinit {
        backgroundTimer?.invalidate()
        NotificationCenter.default.removeObserver(self, name: .didUpdateLocation, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchReminders()
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
    }

    private func fetchReminders() {
        reminders = CoreDataManager.shared.fetchReminders()
        tableView.reloadData()
    }

    @objc private func didTapAddReminder() {
        let addReminderVC = AddReminderViewController()
        navigationController?.pushViewController(addReminderVC, animated: true)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminders.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "ReminderCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? ReminderTableViewCell

        if cell == nil {
            cell = ReminderTableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }

        let reminder = reminders[indexPath.row]
        cell?.configure(with: reminder)

        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let reminder = reminders[indexPath.row]
        let reminderDetailVC = ReminderDetailViewController()
        reminderDetailVC.reminder = reminder
        navigationController?.pushViewController(reminderDetailVC, animated: true)
    }

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [weak self] (action, view, completionHandler) in
            self?.showEditAlert(forRowAt: indexPath)
            completionHandler(true)
        }
        editAction.backgroundColor = .blue

        return UISwipeActionsConfiguration(actions: [editAction])
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completionHandler) in
            self?.deleteReminder(at: indexPath)
            completionHandler(true)
        }

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

    private func showEditAlert(forRowAt indexPath: IndexPath) {
        let reminder = reminders[indexPath.row]

        let alertController = AlertHelper.showEditAlert(for: reminder) { [weak self] (title, latitude, longitude) in
            self?.editReminder(reminder, title: title, latitude: latitude, longitude: longitude)
        }

        present(alertController, animated: true, completion: nil)
    }

    private func editReminder(_ reminder: Reminder, title: String, latitude: Double, longitude: Double) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("Could not retrieve AppDelegate.")
            return
        }

        reminder.title = title
        reminder.latitude = latitude
        reminder.longitude = longitude

        let managedContext = appDelegate.persistentContainer.viewContext
        do {
            try managedContext.save()
            print("Successfully saved data.")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        tableView.reloadData()
    }

    private func deleteReminder(at indexPath: IndexPath) {
        let reminderToDelete = reminders[indexPath.row]
        CoreDataManager.shared.deleteReminder(reminder: reminderToDelete)
        reminders.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }

    @objc private func fetchUserLocationInBackground() {
        locationManager?.requestLocation()
        print("Fetching user location")
    }
    
    @objc private func didUpdateLocation(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let location = userInfo["location"] as? CLLocation else { return }
        checkReminders(for: location)
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else { return }
        print("Current Location:", currentLocation)
        checkReminders(for: currentLocation)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager did fail with error: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
        case .denied, .restricted:
            print("Location access denied or restricted. Please enable location services for this app.")
        case .notDetermined:
            break
        @unknown default:
            break
        }
    }
}

extension ViewController {
    private func checkReminders(for location: CLLocation) {
        for reminder in reminders {
            let reminderLocation = CLLocation(latitude: reminder.latitude, longitude: reminder.longitude)
            let distance = location.distance(from: reminderLocation)
            print("Distance:", distance)
            if distance <= 2000 {
                fireNotification(for: reminder)
            }
        }
    }
    
    private func fireNotification(for reminder: Reminder) {
        let content = UNMutableNotificationContent()
        content.title = "Reminder Alert"
        content.body = "Hey! You are near \(reminder.title ?? ""). Don't you have any Work Here ? "
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        let request = UNNotificationRequest(identifier: "ReminderNotification-\(reminder.id?.uuidString ?? UUID().uuidString)", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error adding notification request: \(error.localizedDescription)")
            } else {
                print("Notification scheduled: \(reminder.title ?? "")")
            }
        }
    }
}

extension Notification.Name {
    static let didUpdateLocation = Notification.Name("didUpdateLocation")
}
