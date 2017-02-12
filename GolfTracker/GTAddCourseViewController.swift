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
    
    var teeNames = Dictionary<String, String>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        form
            +++ Section("")
            <<< TextRow() {
                $0.title = "Course name"
                $0.placeholder = "Name here"
            }
            
            +++ Section("Tees")
            <<< ButtonRow(){
                $0.title = "Add Tee"
                }.onCellSelection({ (_, _) in
                    var section = self.form.allSections[1]
                    section.insert(TextRow("\(section.count)") {
                        $0.title = "Tee name"
                        $0.placeholder = "Name"
                        }.onChange({ (row) in
                            self.teeNames[row.tag!] = row.value
                        }), at: section.count-1)
                })
            +++ Section()
            <<< ButtonRow(){
                $0.title = "Add Holes"
                }.onCellSelection({ (cell, row) in
                    if (self.teeNames.keys.count == 0){
                        return;
                    }
                    row.hidden = true
                    row.evaluateHidden()
                    for i in 1...18 {
                        let holesSection = Section("Hole \(i)")
                        holesSection <<< TextRow(){
                            $0.title = "Par"
                            $0.placeholder = "Par"
                        }
                        for (_, teeName) in self.teeNames {
                            holesSection <<< TextRow(){
                                $0.title = teeName
                                $0.placeholder = "Distance"
                            }
                        }
                        self.form +++ holesSection
                    }
                    let addTeeButton = self.form.allSections[1].last
                    addTeeButton?.hidden = true
                    addTeeButton?.evaluateHidden()
                    print(self.teeNames)
                })
    }
}
