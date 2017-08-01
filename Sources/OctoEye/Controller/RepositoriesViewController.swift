//
//  RepositoriesViewController.swift
//  OctoEye
//
//  Created by mzp on 2017/08/01.
//  Copyright © 2017 mzp. All rights reserved.
//

import Ikemen
import UIKit

internal class RepositoriesViewController: UITableViewController {
    let repositories: [String] = ["mzp/OctoEye"]

    init() {
        super.init(nibName: nil, bundle: nil)
        self.title = "Repositories"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(barButtonSystemItem: .add,
                            target: self,
                            action: #selector(addRepository(sender:)))
    }

    @objc
    private func addRepository(sender: Any) {
        navigationController?.pushViewController(AddRepositoryViewController(), animated: true)
    }

    // MARK: - TableView
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell(style: .default, reuseIdentifier: nil) ※ {
            $0.textLabel?.text = repositories[indexPath.row]
        }
    }
}
