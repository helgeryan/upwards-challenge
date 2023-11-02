//
//  TopAlbumsViewController.swift
//  upwards-ios-challenge
//
//  Created by Alex Livenson on 9/13/21.
//

import UIKit

final class TopAlbumsViewController: UIViewController {
    
    private let viewModel: TopAlbumViewModel
    private let tableView = UITableView()
    private let sortMenu: SortMenu = .fromNib()
    private var isShowingSortMenu: Bool = false
    private var sortMenuTopConstraint: NSLayoutConstraint?
    
    init(viewModel: TopAlbumViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        navigationItem.title = "Top Albums"
    
        configureTableView()
        configureSortMenu()
        configureRightBarButtonItem()
        
        viewModel.loadData()
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(TopAlbumTableViewCell.self, forCellReuseIdentifier: TopAlbumTableViewCell.description())
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func configureSortMenu() {
        let sortTypes = AlbumSortType.allCases
        sortMenu.setupMenu(delegate: self, sortTypes: sortTypes)
        sortMenu.backgroundColor = .white
        sortMenu.alpha = 0
        sortMenu.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sortMenu)
        sortMenuTopConstraint = sortMenu.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        
        let sortMenuHeight: CGFloat = sortTypes.count < 5 ?  CGFloat(sortTypes.count) * 50.0 : 250.0
        NSLayoutConstraint.activate([
            sortMenuTopConstraint!,
            sortMenu.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sortMenu.heightAnchor.constraint(equalToConstant: sortMenuHeight),
            sortMenu.widthAnchor.constraint(equalToConstant: 200),
        ])
    }
    
    func configureRightBarButtonItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "text.alignleft"), style: .done, target: self, action: #selector(toggleSortMenu))
        self.navigationController?.navigationBar.tintColor = .white
        
    }
    
    
    // MARK: - Actions
    
    @objc private func toggleSortMenu() {
        isShowingSortMenu = !isShowingSortMenu
        
        UIView.animate(withDuration: 0.1, animations: {
            self.sortMenu.alpha = self.isShowingSortMenu ? 1 : 0
        })
    }

}

// MARK: - UITableViewDataSource
extension TopAlbumsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let album = viewModel.albums[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: TopAlbumTableViewCell.description(), for: indexPath) as! TopAlbumTableViewCell
        cell.albumLabel.text = album.name
        cell.artistNameLabel.text = album.artistName
                
        return cell
    }
}

// MARK: - Top Album Delegate
extension TopAlbumsViewController: TopAlbumViewModelDelegate {
    func dataFinishedLoading() {
        tableView.reloadData()
    }
}

// MARK: - Sort Menu Delegate
extension TopAlbumsViewController: SortMenuDelegate {
    func selectedSortType(type: SortType) {
        if isShowingSortMenu {
            toggleSortMenu()
        }
        if let albumSortType = type as? AlbumSortType {
            viewModel.sortData(type: albumSortType)
        }
    }
}
