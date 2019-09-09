//
//  MessageListTableViewController.swift
//  BulletingBoard
//
//  Created by Lewis Jones on 08/03/2019.
//  Copyright © 2019 Rodrigo. All rights reserved.
//

import UIKit

class MessageListTableViewController: UITableViewController {
    @IBOutlet weak var messageTextField: UITextField!
    
//    let dateFormatter: DateFormatter = {
//      let formatter = DateFormatter()
//        formatter.dateStyle = .medium
//        formatter.timeStyle = .medium
//        return formatter
//    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadViews), name: MessageController.shared.messagesWereUpdatedNotification, object: nil)
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        MessageController.shared.fetchMessageRecordsFromiCloud()
    }
    
    
    @objc func reloadViews() {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self.tableView.reloadData()
        }
    }
    
    @IBAction func postMessageButtonTapped(_ sender: Any) {
        
        guard let messageText = messageTextField.text else { return }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        MessageController.shared.saveMessageRecordToiCloud(text: messageText)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return MessageController.shared.messages.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath)

        // Configure the cell...
        let message = MessageController.shared.messages[indexPath.row]
        cell.textLabel?.text = message.text
        cell.detailTextLabel?.text = DateHelper.dateFormatter.string(from: message.timestamp)
        return cell
    }
}



