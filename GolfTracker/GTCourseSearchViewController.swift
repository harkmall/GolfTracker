//
//  GTCourseSearchViewController.swift
//  GolfTracker
//
//  Created by Mark Hall on 2017-01-29.
//  Copyright © 2017 markhall. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class GTCourseSearchViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {

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
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView()

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
                    self.searchResults.append(GTCourse(withJson: course))
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
        selectedCourse = self.searchResults[indexPath.row] as? GTCourse
        tableView.deselectRow(at: indexPath, animated: true)
        view.endEditing(true)
        performSegue(withIdentifier: "GTShowCourseDetailsSegue", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "GTShowCourseDetailsSegue"){
            if let detailVC = segue.destination as? GTCourseDetailsViewController {
                detailVC.course = selectedCourse
            }
        }
    }
    
    //MARK: Empty Data delegate/data source
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "Can't find your course?"
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView, for state: UIControlState) -> NSAttributedString? {
        let str = "Add Course"
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.callout)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func emptyDataSet(_ scrollView: UIScrollView, didTap button: UIButton) {
        performSegue(withIdentifier: "GTAddCourseSegue", sender: self)
    }

}
