//
//  AllScheduleViewController.swift
//  HomeBase
//
//  Created by JUN LEE on 2017. 8. 8..
//  Copyright © 2017년 LemonKooma. All rights reserved.
//

import UIKit
import UserNotifications
import SQLite

class AllScheduleViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet var scheduleTableView: UITableView!
    
    /// Array of all team schedules
    fileprivate var scheduleArray = [TeamSchedule]()
    
    fileprivate let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
        return formatter
    }()
    
    // MARK: Override
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.automaticallyAdjustsScrollViewInsets = false
        
        scheduleTableView.delegate = self
        scheduleTableView.dataSource = self
        scheduleTableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        scheduleArray = TeamScheduleDAO.shared.selectAllColumn()!
        scheduleTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == .segueScheduleToDetail {
            if let row = self.scheduleTableView.indexPathForSelectedRow?.row {
                
                let detailViewController = segue.destination as! DetailScheduleViewController
                detailViewController.scheduleItem = scheduleArray[row]
            }
        }
    }
    
    // MARK: Actions
    
    @IBAction private func addButtonDidTapped(_ sender: UIBarButtonItem) {
        guard let addScheduleViewController = storyboard?.instantiateViewController(
            withIdentifier: .addScheduleViewController) else { return }
        
        present(addScheduleViewController, animated: true, completion: nil)
    }
}

// MARK: TableView Delegate, DataSource

extension AllScheduleViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let scheduleCount = TeamScheduleDAO.shared.countAll()
        
        return scheduleCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: .allScheduleTableViewCell, for: indexPath) as! AllScheduleTableViewCell
        
        cell.matchDateLabel.text = dateFormatter.string(from: scheduleArray[indexPath.row].matchDate)
        cell.matchOpponentLabel.text = "vs " + scheduleArray[indexPath.row].matchOpponent + " >"
        
        switch (indexPath.row % 2) {
        case 0:
            cell.backgroundColor = UIColor(
                red: 60.0/255.0, green: 66.0/255.0, blue: 90.0/255.0, alpha: 1.0)
        case 1:
            cell.backgroundColor = UIColor(
                red: 60.0/255.0, green: 66.0/255.0, blue: 90.0/255.0, alpha: 0.7)
        default:
            cell.backgroundColor = UIColor(
                red: 60.0/255.0, green: 66.0/255.0, blue: 90.0/255.0, alpha: 1.0)
        }
        
        return cell
    }

    func tableView(
        _ tableView: UITableView,
        editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteIndex = indexPath.row
        let selectedSchedule = self.scheduleArray[deleteIndex]
        let delete = UITableViewRowAction(style: .destructive , title: " ✕ ") { (action, indexPath) in
            // delete item at indexPath

            let ac = UIAlertController(
                title: .deleteActionTitle,
                message: .alertMessageOfDeleteSchedule,
                preferredStyle: .actionSheet)
            let cancelAction = UIAlertAction(
                title: .cancelActionTitle,
                style: .cancel,
                handler: nil)
            let deleteAction = UIAlertAction(
                title: .deleteActionTitle,
                style: .destructive,
                handler: { (action) -> Void in
                    self.scheduleArray.remove(at: deleteIndex)
                    TeamScheduleDAO.shared.delete(id: selectedSchedule.scheduleID)
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                    MyNotification.remove(identifierID: selectedSchedule.scheduleID)

            })
            ac.addAction(deleteAction)
            ac.addAction(cancelAction)
            self.present(ac, animated: true, completion: nil)
        }
        delete.backgroundColor = UIColor(red: 255.0/255.0, green: 60.0/255.0, blue: 50.0/255.0, alpha: 0.9)

        let editScheduleViewController = storyboard?.instantiateViewController(
            withIdentifier: .editScheduleViewController) as? EditScheduleViewController
        
        let edit = UITableViewRowAction(style: .normal, title: " ✎ ") { (action, indexPath) in

            let selectedSchedule = self.scheduleArray[indexPath.row]
            editScheduleViewController?.preSchedule = selectedSchedule
            self.present(editScheduleViewController!, animated: true, completion: nil)
        }
        edit.backgroundColor = UIColor(red: 47.0/255.0, green: 113.0/255.0, blue: 176.0/255.0, alpha: 0.9)
    
        let currentDate = Date()
        if currentDate > selectedSchedule.matchDate {
            return [delete]
        }
        else {
            return [delete, edit]
        }
    }
}
