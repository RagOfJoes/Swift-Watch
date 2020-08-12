//
//  MovieCollectionViewTableViewCell.swift
//  Swift Watch
//
//  Created by Victor Ragojos on 7/27/20.
//  Copyright © 2020 Victor Ragojos. All rights reserved.
//

import UIKit
import SkeletonView

protocol MovieCollectionViewTableViewCellDelegate: class {
    func select(movie: IndexPath)
}

// MARK: - MovieCollectionViewTableViewCell
class MovieCollectionViewTableViewCell: UITableViewCell {
    var section: Int?
    var data: [Movie]? = nil
    weak var delegate: MovieCollectionViewTableViewCellDelegate?
    
    lazy var collectionView: UICollectionView = {
        // Setup Layout
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 15
        layout.scrollDirection = .horizontal
        
        // Setup CollectionView
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.clipsToBounds = true
        collectionView.backgroundColor = .clear
        collectionView.delaysContentTouches = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.isSkeletonable = true
        collectionView.skeletonCornerRadius = 5
        collectionView.showAnimatedGradientSkeleton(transition: .crossDissolve(0.25))
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        collectionView.register(OverviewCell.self, forCellWithReuseIdentifier: OverviewCell.reuseIdentifier)
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        addSubview(collectionView)
        
        setupAnchors()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(_ movies: [Movie]) {
        data = movies
        collectionView.hideSkeleton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Helper Functions
extension MovieCollectionViewTableViewCell {
    private func setupAnchors() {
        let collectionViewConstraints: [NSLayoutConstraint] = [
            collectionView.heightAnchor.constraint(equalTo: heightAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor , constant: 10)
        ]
        NSLayoutConstraint.activate(collectionViewConstraints)
    }
}

// MARK: - UICollectionViewDelegate
extension MovieCollectionViewTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let correctIndexPath = IndexPath(row: indexPath.row, section: section ?? indexPath.section)
        self.delegate?.select(movie: correctIndexPath)
        return
    }
}

extension MovieCollectionViewTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = data?.count {
            return count
        }
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OverviewCell.reuseIdentifier, for: indexPath) as! OverviewCell
        
        if let movie = data?[indexPath.row] {
            if let poster = movie.posterPath {
                cell.configure(name: movie.title, poster: MovieSection.posterURL + poster)
            } else {
                cell.configure(name: movie.title)
            }
        }
        return cell
    }
}

extension MovieCollectionViewTableViewCell: SkeletonCollectionViewDataSource {
    func numSections(in collectionSkeletonView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return OverviewCell.reuseIdentifier
    }
}

// MARK: - UICollectionViewLayout
extension MovieCollectionViewTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: K.Overview.widthConstant, height: K.Overview.heightConstant)
    }
}
