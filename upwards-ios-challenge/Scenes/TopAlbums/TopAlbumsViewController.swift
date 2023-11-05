//
//  TopAlbumsViewController.swift
//  upwards-ios-challenge
//
//  Created by Alex Livenson on 9/13/21.
//

import UIKit
import Combine
import Lottie

final class TopAlbumsViewController: UIViewController {
    
    private var subscriptions: [AnyCancellable] = []
    private let viewModel: TopAlbumViewModel
    private var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let lottieView = LottieAnimationView()
    private let errorLabel = UILabel()
    private let reloadButton = UIButton()
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
    
        // Configure the views
        configureSubViews()
        
        // Bind the data model to the view
        bindViewModel()
        
        // Load the data
        viewModel.loadData()
    }
    
    // MARK: - Configure/View Layout
    private func configureSubViews() {
        configureErrorState()
        configureCollectionView()
        configureLoaderView()
        configureSortMenu()
        configureRightBarButtonItem()
    }
    
    private func configureErrorState() {
        errorLabel.textColor = .red
            
        errorLabel.numberOfLines = 0
        errorLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        errorLabel.isHidden = true
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(errorLabel)
        
        NSLayoutConstraint.activate([
            errorLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15),
            errorLabel.heightAnchor.constraint(equalToConstant: 100),
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
        reloadButton.setTitle("Reload data", for: .normal)
        reloadButton.isHidden = true
        
        reloadButton.addTarget(self, action: #selector(reloadData), for: .touchUpInside)
        reloadButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(reloadButton)
        
        NSLayoutConstraint.activate([
            reloadButton.widthAnchor.constraint(equalToConstant: 150),
            reloadButton.heightAnchor.constraint(equalToConstant: 100),
            reloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            reloadButton.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 10),
        ])
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
        collectionView.isHidden = true
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
        sortMenu.cornerRadius = 5
        sortMenu.clipsToBounds = true
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
    
    // MARK: - Binding
    private func bindViewModel() {
        bindAlbums()
        bindError()
        bindLoading()
    }
    
    private func bindAlbums() {
        let albumsCancellable = viewModel.$albumsPublished.sink() { [weak self] albums in
            if albums != nil {
                self?.collectionView.isHidden = false
                self?.collectionView.reloadData()
            } else {
                self?.collectionView.isHidden = true
            }
        }
        subscriptions.append(albumsCancellable)
    }
    
    private func bindError() {
        let errorCancellable = viewModel.$error.sink() { [weak self] error in
            if let error = error as? APIErrors {
                self?.errorLabel.text = error.localizedDescription
                self?.errorLabel.isHidden = false
                self?.reloadButton.isHidden = false
            } else {
                self?.errorLabel.isHidden = true
                self?.reloadButton.isHidden = true
            }
        }
        subscriptions.append(errorCancellable)
    }
    
    private func bindLoading() {
        let loadingCancellable = viewModel.$isLoading.sink() { [weak self] loading in
            if loading {
                self?.lottieView.isHidden = false
                self?.lottieView.play()
            }else {
                self?.lottieView.stop()
                self?.lottieView.isHidden = true
            }
        }
        subscriptions.append(loadingCancellable)
    }
    
    // MARK: - Actions
    
    @objc private func toggleSortMenu() {
        isShowingSortMenu = !isShowingSortMenu
        
        UIView.animate(withDuration: 0.1, animations: {
            self.sortMenu.alpha = self.isShowingSortMenu ? 1 : 0
        })
    }

    @objc private func reloadData() {
        viewModel.loadData()
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
        if let albums = viewModel.albumsPublished {
            return albums.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopAlbumCollectionViewCell.description(), for: indexPath) as! TopAlbumCollectionViewCell
        if let albums = viewModel.albumsPublished {
            let album = albums[indexPath.row]
            
            cell.album = album
        }
        return cell
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
