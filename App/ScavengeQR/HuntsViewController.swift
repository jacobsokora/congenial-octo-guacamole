//
//  HuntsViewController.swift
//  ScavengeQR
//
//  Created by Jacob Sokora on 4/30/18.
//  Copyright © 2018 ScavengeQR. All rights reserved.
//

import UIKit

class HuntsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var hunts: [Hunt] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(refreshHunts), for: .valueChanged)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshHunts()
    }
    
    @objc func refreshHunts() {
        self.tableView.refreshControl?.beginRefreshing()
        var request = URLRequest(url: URL(string: "http://158.69.219.75/access_db.php?choice=gethunts")!)
        request.httpMethod = "GET"
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: request) { responseData, response, responseError in
            DispatchQueue.main.async {
                if let error = responseError {
                    print(error)
                } else if let jsonData = responseData {
                    let decoder = JSONDecoder()
                    do {
                        self.hunts = try decoder.decode([Hunt].self, from: jsonData)
                        self.tableView.reloadData()
                    } catch {
                        print(error)
                    }
                }
                self.tableView.isHidden = false
                self.tableView.refreshControl?.endRefreshing()
            }
        }
        task.resume()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let destination = segue.destination as? HuntViewController {
            destination.hunt = hunts[(tableView.indexPathForSelectedRow?.row)!]
        } else if let destination = segue.destination as? CreateHuntViewController {
            destination.huntsView = self
        }
    }

}

extension HuntsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hunts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "huntCell", for: indexPath)
        let hunt = hunts[indexPath.row]
        cell.textLabel?.text = hunt.name
        cell.detailTextLabel?.text = hunt.description
        return cell
    }
}

extension HuntsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
