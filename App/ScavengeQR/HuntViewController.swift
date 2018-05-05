//
//  HuntViewController.swift
//  ScavengeQR
//
//  Created by Jacob Sokora on 5/1/18.
//  Copyright © 2018 ScavengeQR. All rights reserved.
//

import UIKit

class HuntViewController: UIViewController {

    @IBOutlet weak var huntNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var numberOfCluesLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var cluesTable: UITableView!
    
    var hunt: Hunt?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let hunt = hunt {
            huntNameLabel.text = hunt.name
            descriptionLabel.text = hunt.description
            locationLabel.text = hunt.location
            numberOfCluesLabel.text = "\(hunt.clues.count) clues"
            deleteButton.isHidden = UIDevice.current.identifierForVendor?.uuidString != hunt.ownerId
            editButton.isHidden = deleteButton.isHidden
            cluesTable.isHidden = deleteButton.isHidden
            if !cluesTable.isHidden {
                cluesTable.delegate = self
                cluesTable.dataSource = self
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let destination = segue.destination as? ClueViewController {
            destination.hunt = hunt
        }
    }

    @IBAction func deleteHunt(_ sender: UIButton) {
        guard let hunt = hunt else {
            return
        }
        var request = URLRequest(url: URL(string: "http://158.69.219.75/access_db.php?choice=deletehunt&id=\(hunt.id)")!)
        request.httpMethod = "GET"
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: request)
        task.resume()
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editName(_ sender: UIButton) {
        let alert = UIAlertController(title: "Edit Name", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Save", style: .default) { action in
            let textField = alert.textFields![0] as UITextField
            if let hunt = self.hunt, let name = textField.text, name.count > 0 {
                self.huntNameLabel.text = name
                var request = URLRequest(url: URL(string: "http://158.69.219.75/access_db.php?choice=edithuntname&id=\(hunt.id)&name=\(name)".replacingOccurrences(of: " ", with: "%20"))!)
                request.httpMethod = "GET"
                
                let session = URLSession(configuration: URLSessionConfiguration.default)
                let task = session.dataTask(with: request)
                task.resume()
            }
        }
        alert.addAction(action)
        alert.addTextField { textField in
            textField.placeholder = "Name"
        }
        present(alert, animated: true)
    }
}

extension HuntViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hunt?.clues.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "clueCell", for: indexPath)
        let clue = hunt?.clues[indexPath.row]
        cell.textLabel?.text = clue?.clueText
        cell.detailTextLabel?.text = clue?.clueCode
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Clues"
    }
}

extension HuntViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
