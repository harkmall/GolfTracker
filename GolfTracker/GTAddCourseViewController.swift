//
//  GTAddCourseViewController.swift
//  GolfTracker
//
//  Created by Mark Hall on 2017-02-11.
//  Copyright © 2017 markhall. All rights reserved.
//

import UIKit
import Eureka

class GTAddCourseViewController: FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        form
            +++ Section("")
            <<< TextRow() {
                $0.title = "Course name"
                $0.placeholder = "Name here"
            }
            
            +++ Section("Tees")
            <<< TextRow(){
                $0.title = "Tee Name"
                $0.placeholder = "Name"
            }
            <<< ButtonRow(){
                $0.title = "Add Tee"
            }.onCellSelection({ (_, _) in
                var section = self.form.allSections[1]
                section.insert(TextRow() {
                    $0.title = "Tee name"
                    $0.placeholder = "Name"
                }, at: section.count-1)
            })
        +++ Section()
            <<< ButtonRow(){
                $0.title = "Add Holes"
                }.onCellSelection({ (cell, row) in
                    row.hidden = true
                    row.evaluateHidden()
                    for i in 1...18 {
                        let holesSection = self.form.allSections[i+2]
                        holesSection.hidden = false
                        holesSection.evaluateHidden()
                    }
                })
        
        for i in 1...18{
            var holesSection = Section("Hole \(i)")
            holesSection += [TextRow(){
                $0.title = "Par"
                $0.placeholder = "Par"
                }]
            holesSection.hidden = true
            holesSection.evaluateHidden()
            form +++ holesSection
        }
    }
    
}
