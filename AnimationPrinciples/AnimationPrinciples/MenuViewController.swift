//
//  ViewController.swift
//  Animations
//
//  Created by Alisa Mylnikova on 07/08/2018.
//  Copyright © 2018 Exyte. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    fileprivate var viewControllers = [
        MaterialViewController(),
        TrajectoryViewController(),
        TimingViewController(),
        FocusViewController(),
        SecondaryViewController(),
        AnticipationViewController(),
        RhythmViewController(),
        OverlappingViewController()
    ]
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewControllers.count
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menu_cell")!
        cell.textLabel?.text = String(describing: type(of: viewControllers[indexPath.row])).replacingOccurrences(of: "ViewController", with: "")
        return cell
    }
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(viewControllers[indexPath.row], animated: true)
    }


}

