//
//  DetailViewController.swift
//  iOS App
//
//  Created by Ankit Mendiratta on 29/05/24.
//

import UIKit

class DetailViewController: UIViewController {
    
    // MARK: Declaration
    var listModel: ListModel?
    private var detailLabel: UILabel!
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDetailView()
        displayDetails()
    }
    
    // MARK: Other Methods
    private func setupDetailView() {
        detailLabel = UILabel(frame: view.bounds)
        detailLabel.numberOfLines = 0
        detailLabel.textAlignment = .center
        view.addSubview(detailLabel)
    }
    
    private func displayDetails() {
        guard let listModel = listModel else { return }
        detailLabel.text = "ID: \(listModel.id)\nTitle: \(listModel.title)\nBody: \(listModel.body)"
    }
}
