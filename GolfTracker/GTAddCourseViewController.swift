//
//  GTAddCourseViewController.swift
//  GolfTracker
//
//  Created by Mark Hall on 2017-02-11.
//  Copyright © 2017 markhall. All rights reserved.
//

import UIKit
import Eureka

class GTAddCourseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var course: GTCourse?
    var holes: [GTHole] = {
        var holes = [GTHole]()
        for index in 0...17 {
            let hole = GTHole(number: index+1)
            holes.append(hole)
        }
        return holes
    }()
    var tees = [GTTee]()
    var doneTees = false
    
    @IBOutlet weak var saveCourseButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = course?.name?.uppercased()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Tees"
        default:
            return doneTees ? "HOLE \(section - 1)" : ""
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return doneTees ? 20 : 2;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return tees.count + (doneTees ? 0 : 1)
        default:
            return doneTees ? tees.count + 1 : 1
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            if indexPath.row == tees.count {
                tees.append(GTTee())
                tableView.beginUpdates()
                tableView.reloadRows(at: [indexPath], with: .automatic)
                tableView.insertRows(at: [IndexPath(row: tees.count, section: 0)], with: .middle)
                tableView.endUpdates()
            }
        case 1:
            if (indexPath.row == 0 && !doneTees) {
                doneTees = true
                for hole in holes {
                    for tee in tees {
                        hole.yardages.append(GTHoleYardage(distance: tee.distance, name: tee.name))
                    }
                }
                tableView.reloadData()
            }
        default:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let holeNumber = indexPath.row
        switch indexPath.section {
        case 0:
            if indexPath.row == self.tees.count {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "buttonCell", for: indexPath) as? GTButtonTableViewCell {
                    cell.buttonTitle.text = "Add Tee"
                    return cell
                }
            }
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: "textCell", for: indexPath) as? GTTextTableViewCell {
                cell.titleLabel.text = "Tee Name"
                cell.inputField.placeholder = "Name"
                cell.inputField.text = self.tees[indexPath.row].name
                cell.onChangeClosure = { [unowned self] in
                    let tee = self.tees[indexPath.row]
                    if let name = cell.inputField.text {
                        tee.name = name
                    }
                }
                cell.selectionStyle = .none
                return cell
            }
            
        default:
            if (!doneTees){
                if let cell = tableView.dequeueReusableCell(withIdentifier: "buttonCell", for: indexPath) as? GTButtonTableViewCell {
                    cell.buttonTitle.text = "Add Holes"
                    return cell
                }
            }
            else{
                switch indexPath.row {
                case 0:
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "textCell", for: indexPath) as? GTTextTableViewCell {
                        cell.titleLabel.text = "Par"
                        cell.inputField.placeholder = "Par"
                        if let par = holes[indexPath.section - 1].par {
                            cell.inputField.text = "\(par)"
                        }
                        else{
                            cell.inputField.text = ""
                        }
                        cell.onChangeClosure = { [unowned self] in
                            let hole = self.holes[indexPath.section-1]
                            if let par = cell.inputField.text {
                                hole.par = Int(par)
                            }
                            print(self.holes)
                        }
                        cell.selectionStyle = .none
                        return cell
                    }
                default:
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "textCell", for: indexPath) as? GTTextTableViewCell {
                        cell.titleLabel.text = holes[holeNumber].yardages[indexPath.row-1].name
                        cell.inputField.placeholder = "Yards"
                        if let yards = holes[indexPath.section - 1].yardages[indexPath.row-1].distance {
                            cell.inputField.text = "\(yards)"
                        }
                        else{
                            cell.inputField.text = ""
                        }
                        cell.onChangeClosure = { [unowned self] in
                            let tee = self.holes[indexPath.section - 1].yardages[indexPath.row-1]
                            if let yards = cell.inputField.text {
                                tee.distance = Int(yards)
                            }
                            print(self.holes)
                        }
                        cell.selectionStyle = .none
                        return cell
                    }
                }
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        switch indexPath.section {
        case 0:
            return indexPath.row != self.tees.count
        default:
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            switch indexPath.section {
            case 1:
                tees.remove(at: indexPath.row)
                tableView.beginUpdates()
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.endUpdates()
            default:
                return
            }
        }
    }
    
    @IBAction func saveCoursePressed(_ sender: Any) {
        if let course = course{
            course.tees = tees
            course.holes = holes
            GTNetworkingManager.sharedManager.saveCourse(course: course) { (response) in
                if let errorMessage = response["error"].string{
                    print(errorMessage)
                }
                else{
                    print(response)
                }
            }
        }
        
    }
    @IBAction func cancelPressed(_ sender: Any) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
