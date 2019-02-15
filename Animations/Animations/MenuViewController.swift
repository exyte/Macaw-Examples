//
//  ViewController.swift
//  Animations
//
//  Created by Alisa Mylnikova on 07/08/2018.
//  Copyright © 2018 Exyte. All rights reserved.
//

import UIKit

//func classFromString(_ className: String) -> AnyClass! {
//    let namespace = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
//    return NSClassFromString("\(namespace).\(className)")!
//}

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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewControllers.count
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menu_cell")!
        cell.textLabel?.text = String(describing: type(of: viewControllers[indexPath.row]))
        return cell
    }
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(viewControllers[indexPath.row], animated: true)
    }


}

