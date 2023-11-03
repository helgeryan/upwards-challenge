//
//  TopAlbumsViewController.swift
//  upwards-ios-challenge
//
//  Created by Alex Livenson on 9/13/21.
//

import UIKit

final class TopAlbumsViewController: UIViewController {
    
    private let viewModel: TopAlbumViewModel
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
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
        navigationController?.navigationBar.barTintColor = .black
    
        configureCollectionView()
//        configureTableView()
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
    
    private func configureCollectionView() {
        collectionView.backgroundColor = .darkGray
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(UINib(nibName: "TopAlbumCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: TopAlbumCollectionViewCell.description())
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 5),
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

extension TopAlbumsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.window?.windowScene?.screen.bounds.width
        return CGSize(width: width! / 2.0 - 10, height: 300)
    }
}

extension TopAlbumsViewController: UICollectionViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.albums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let album = viewModel.albums[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopAlbumCollectionViewCell.description(), for: indexPath) as! TopAlbumCollectionViewCell
        
        cell.album = album
        return cell
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
        collectionView.reloadData()
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
