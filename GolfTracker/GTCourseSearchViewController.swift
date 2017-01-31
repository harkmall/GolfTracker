//
//  GTCourseSearchViewController.swift
//  GolfTracker
//
//  Created by Mark Hall on 2017-01-29.
//  Copyright © 2017 markhall. All rights reserved.
//

import UIKit

class GTCourseSearchViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var searchBar: UISearchBar!{
        didSet{
            searchBar.delegate = self
        }
    }
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    var searchResults = Array<Any>()
    var selectedCourse: GTCourse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)

    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        view.endEditing(true)
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchResults = Array<Any>()
        if (searchText.characters.count > 0){
            GTNetworkingManager.sharedManager.searchForCourse(name: searchText) { (response) in
                for course in response.array!{
                    self.searchResults.append(GTCourse.init(withJson: course))
                }
                self.tableView.reloadData()
            }
        }
        else{
            tableView.reloadData()
        }
    }
    
    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GTCourseSearchCell", for: indexPath)
        let courseObject = self.searchResults[indexPath.row] as! GTCourse
        cell.textLabel?.text = courseObject.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCourse = self.searchResults[indexPath.row] as! GTCourse
        performSegue(withIdentifier: "GTShowCourseDetailsSegue", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "GTShowCourseDetailsSegue"){
            let detailVC = segue.destination as! GTCourseDetailsViewController
            detailVC.course = selectedCourse
        }
    }

}
