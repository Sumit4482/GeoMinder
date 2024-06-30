//
//  GeoMinder_1Tests.swift
//  GeoMinder-1Tests
//
//  Created by E5000855 on 28/06/24.
//

import XCTest
@testable import GeoMinder_1

struct Reminder: Equatable {
    let title: String
    let latitude: Double
    let longitude: Double
    let createdAt: Date
    var isCompleted: Bool = false

    static func ==(lhs: Reminder, rhs: Reminder) -> Bool {
        return lhs.title == rhs.title && lhs.createdAt == rhs.createdAt
    }
}

// Define a ReminderManager class to manage reminders
class ReminderManager {
    private var reminders: [Reminder] = []

    func addReminder(_ reminder: Reminder) {
        reminders.append(reminder)
    }

    func removeReminder(_ reminder: Reminder) {
        reminders.removeAll { $0 == reminder }
    }

    func completeReminder(_ reminder: Reminder) {
        if let index = reminders.firstIndex(of: reminder) {
            reminders[index].isCompleted = true
        }
    }

    func fetchReminders() -> [Reminder] {
        return reminders
    }

    func removeAllReminders() {
        reminders.removeAll()
    }
}

// Unit test cases for ReminderManager
class GeoMinderTests: XCTestCase {

    var reminderManager: ReminderManager!

    override func setUp() {
        super.setUp()
        reminderManager = ReminderManager()
    }

    override func tearDown() {
        reminderManager = nil
        super.tearDown()
    }

    func testAddReminder() {
        let reminder = Reminder(title: "Test Reminder", latitude: 37.7749, longitude: -122.4194, createdAt: Date())
        reminderManager.addReminder(reminder)
        let reminders = reminderManager.fetchReminders()
        XCTAssertTrue(reminders.contains(reminder))
    }

    func testAddMultipleReminders() {
        let reminder1 = Reminder(title: "Test Reminder 1", latitude: 37.7749, longitude: -122.4194, createdAt: Date())
        let reminder2 = Reminder(title: "Test Reminder 2", latitude: 40.7128, longitude: -74.0060, createdAt: Date())
        reminderManager.addReminder(reminder1)
        reminderManager.addReminder(reminder2)
        let reminders = reminderManager.fetchReminders()
        XCTAssertEqual(reminders.count, 2)
        XCTAssertTrue(reminders.contains(reminder1))
        XCTAssertTrue(reminders.contains(reminder2))
    }

    func testRemoveReminder() {
        let reminder = Reminder(title: "Test Reminder", latitude: 37.7749, longitude: -122.4194, createdAt: Date())
        reminderManager.addReminder(reminder)
        reminderManager.removeReminder(reminder)
        let reminders = reminderManager.fetchReminders()
        XCTAssertFalse(reminders.contains(reminder))
    }

    func testRemoveNonExistentReminder() {
        let reminder = Reminder(title: "Test Reminder", latitude: 37.7749, longitude: -122.4194, createdAt: Date())
        reminderManager.removeReminder(reminder)
        let reminders = reminderManager.fetchReminders()
        XCTAssertFalse(reminders.contains(reminder))
    }

    func testCompleteReminder() {
        let reminder = Reminder(title: "Test Reminder", latitude: 37.7749, longitude: -122.4194, createdAt: Date())
        reminderManager.addReminder(reminder)
        reminderManager.completeReminder(reminder)
        let reminders = reminderManager.fetchReminders()
        XCTAssertTrue(reminders.contains { $0.title == reminder.title && $0.isCompleted })
    }

    func testCompleteNonExistentReminder() {
        let reminder = Reminder(title: "Test Reminder", latitude: 37.7749, longitude: -122.4194, createdAt: Date())
        reminderManager.completeReminder(reminder)
        let reminders = reminderManager.fetchReminders()
        XCTAssertFalse(reminders.contains { $0.title == reminder.title && $0.isCompleted })
    }

    func testFetchRemindersWhenEmpty() {
        let reminders = reminderManager.fetchReminders()
        XCTAssertTrue(reminders.isEmpty)
    }

    func testFetchRemindersWithInitialReminders() {
        let reminder1 = Reminder(title: "Test Reminder 1", latitude: 37.7749, longitude: -122.4194, createdAt: Date())
        let reminder2 = Reminder(title: "Test Reminder 2", latitude: 40.7128, longitude: -74.0060, createdAt: Date())
        reminderManager.addReminder(reminder1)
        reminderManager.addReminder(reminder2)
        let reminders = reminderManager.fetchReminders()
        XCTAssertEqual(reminders.count, 2)
    }

    func testRemoveAllReminders() {
        let reminder1 = Reminder(title: "Test Reminder 1", latitude: 37.7749, longitude: -122.4194, createdAt: Date())
        let reminder2 = Reminder(title: "Test Reminder 2", latitude: 40.7128, longitude: -74.0060, createdAt: Date())
        reminderManager.addReminder(reminder1)
        reminderManager.addReminder(reminder2)
        reminderManager.removeAllReminders()
        let reminders = reminderManager.fetchReminders()
        XCTAssertTrue(reminders.isEmpty)
    }

    func testEdgeCaseEmptyTitleReminder() {
        let reminder = Reminder(title: "", latitude: 37.7749, longitude: -122.4194, createdAt: Date())
        reminderManager.addReminder(reminder)
        let reminders = reminderManager.fetchReminders()
        XCTAssertTrue(reminders.contains(reminder))
    }

    func testEdgeCaseZeroCoordinatesReminder() {
        let reminder = Reminder(title: "Zero Coordinates", latitude: 0.0, longitude: 0.0, createdAt: Date())
        reminderManager.addReminder(reminder)
        let reminders = reminderManager.fetchReminders()
        XCTAssertTrue(reminders.contains(reminder))
    }
}
