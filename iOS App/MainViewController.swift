//
//  MainViewController.swift
//  iOS App
//
//  Created by Ankit Mendiratta on 29/05/24.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Declaration
    private var tableView: UITableView!
    private var listModels: [ListModel] = []
    private var currentPage: Int = 1
    private var isLoading: Bool = false
    private var computationCache = [Int: String]()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        loadData(page: currentPage)
    }
    
    // MARK: Table Load
    private func setupTableView() {
        tableView = UITableView(frame: view.bounds)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
    }
    
    private func loadData(page: Int) {
        guard !isLoading else { return }
        isLoading = true
        NetworkService.shared.fetchFeedData(page: page) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            DispatchQueue.main.async { // Ensure UI updates are performed on the main thread
                switch result {
                case .success(let newListModels):
                    self.listModels.append(contentsOf: newListModels)
                    self.tableView.reloadData()
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        }
    }
    
    // MARK: Optimizing Heavy Computation
    private func performHeavyComputation(for item: ListModel, completion: @escaping (String) -> Void) {
        if let cachedResult = computationCache[item.id] {
            completion(cachedResult)
            return
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let start = Date()
            // Simulate heavy computation
            let result = "Computed result for \(item.title)"
            let end = Date()
            let computationTime = end.timeIntervalSince(start)
            print("Heavy computation took \(computationTime) seconds")
            DispatchQueue.main.async {
                self.computationCache[item.id] = result
                completion(result)
            }
        }
    }
    
    // MARK: UITableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let listModel = listModels[indexPath.row]
        cell.textLabel?.text = "\(listModel.id): \(listModel.title)"
        // Integrating Heavy Computation in the Cell
        performHeavyComputation(for: listModel) { result in
            // Update the cell with the computation result
            cell.detailTextLabel?.text = result
        }
        return cell
    }
    
    // MARK: UITableViewDelegate Methods
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == listModels.count - 1 {
            currentPage += 1
            loadData(page: currentPage)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedFeed = listModels[indexPath.row]
        performSegue(withIdentifier: "showDetail", sender: selectedFeed)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail",
           let detailVC = segue.destination as? DetailViewController,
           let selectedList = sender as? ListModel {
            detailVC.listModel = selectedList
        }
    }
}
