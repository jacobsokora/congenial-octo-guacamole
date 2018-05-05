//
//  CreateHuntViewController.swift
//  ScavengeQR
//
//  Created by Jacob Sokora on 4/30/18.
//  Copyright © 2018 ScavengeQR. All rights reserved.
//

import UIKit

class CreateHuntViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var clueField: UITextField!
    
    var clues: [String] = []
    
    var huntsView: HuntsViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        
        let viewForDoneButtonOnKeyboard = UIToolbar()
        viewForDoneButtonOnKeyboard.sizeToFit()
        let spaceBar = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let btnDoneOnKeyboard = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(hideKeyboard))
        viewForDoneButtonOnKeyboard.items = [spaceBar, btnDoneOnKeyboard]
        
        nameField.inputAccessoryView = viewForDoneButtonOnKeyboard
        descriptionField.inputAccessoryView = viewForDoneButtonOnKeyboard
        locationField.inputAccessoryView = viewForDoneButtonOnKeyboard
        clueField.inputAccessoryView = viewForDoneButtonOnKeyboard
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        clues.removeAll()
        if clues.count == 0 {
            tableView.isHidden = true
        }
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addClue(_ sender: UIButton) {
        if let clue = clueField.text, clue.count > 0 {
            clues.append(clue)
            tableView.reloadData()
            clueField.text = ""
            tableView.isHidden = false
            clueField.becomeFirstResponder()
        } else {
            let alert = UIAlertController(title: "Invalid Input", message: "Please enter a clue and answer.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func createHunt(_ sender: UIButton) {
        if let name = nameField.text, name.count > 0, let description = descriptionField.text, description.count > 0, let location = locationField.text, location.count > 0, clues.count > 0 {
            var urlString = "http://158.69.219.75/access_db.php?choice=addhunt&name=\(name)&ownerId=\(UIDevice.current.identifierForVendor!.uuidString)&location=\(location)&description=\(description)"
            for clue in clues {
                urlString.append("&clues[]=\(clue)")
            }
            var request = URLRequest(url: URL(string: urlString.replacingOccurrences(of: " ", with: "%20"))!)
            request.httpMethod = "GET"
            
            let session = URLSession(configuration: URLSessionConfiguration.default)
            
            let task = session.dataTask(with: request)
            task.resume()
            dismiss(animated: true)
        } else {
            let alert = UIAlertController(title: "Invalid Input", message: "Please make sure you have a name and at least one clue for your scavenger hunt.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

extension CreateHuntViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "madeClueCell", for: indexPath)
        let clue = clues[indexPath.row]
        cell.textLabel?.text = clue
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Clues"
    }
}

extension CreateHuntViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "") { (ac: UIContextualAction, view: UIView, success: (Bool) -> Void) in
            self.clues.remove(at: indexPath.row)
            success(true)
            tableView.reloadData()
            
        }
        deleteAction.image = UIImage(named: "delete")
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

extension CreateHuntViewController: UINavigationBarDelegate {
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}
