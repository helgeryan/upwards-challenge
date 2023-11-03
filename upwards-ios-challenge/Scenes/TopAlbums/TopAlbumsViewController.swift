//
//  TopAlbumsViewController.swift
//  upwards-ios-challenge
//
//  Created by Alex Livenson on 9/13/21.
//

import UIKit
import Lottie

final class TopAlbumsViewController: UIViewController {
    
    private let viewModel: TopAlbumViewModel
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let lottieView = LottieAnimationView()
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
     
        view.backgroundColor = .darkGray
        navigationItem.title = "Top Albums"
    
        configureCollectionView()
        configureLoaderView()
        configureSortMenu()
        configureRightBarButtonItem()
        
        viewModel.loadData()
    }
    
    private func configureLoaderView() {
        let name = "Spinner"
        let loopMode: LottieLoopMode = .loop
        let animation = LottieAnimation.named(name)
        lottieView.animation = animation
        lottieView.contentMode = .scaleAspectFit
        lottieView.loopMode = loopMode
        lottieView.play()

        lottieView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lottieView)
        
        NSLayoutConstraint.activate([
            lottieView.heightAnchor.constraint(equalToConstant: 150),
            lottieView.widthAnchor.constraint(equalToConstant: 150),
            lottieView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            lottieView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    private func configureCollectionView() {
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(UINib(nibName: "TopAlbumCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: TopAlbumCollectionViewCell.description())
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
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
        return CGSize(width: width! / 2.0 - 20, height: 315)
    }
}

extension TopAlbumsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
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

// MARK: - Top Album Delegate
extension TopAlbumsViewController: TopAlbumViewModelDelegate {
    func dataFinishedLoading() {
        lottieView.stop()
        lottieView.isHidden = true
        collectionView.reloadData()
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
