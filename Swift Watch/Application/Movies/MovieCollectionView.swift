//
//  MovieCollectionView.swift
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

// MARK: - MovieCollectionView
class MovieCollectionView: CVTCell {
    var section: Int?
    var movies: [Movie]? = nil
    weak var delegate: MovieCollectionViewTableViewCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configure(.Regular)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(movies: [Movie], section: Int) {
        self.movies = movies
        self.section = section
        self.hideSkeleton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UICollectionViewDelegate
extension MovieCollectionView {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let correctIndexPath = IndexPath(row: indexPath.row, section: section ?? indexPath.section)
        self.delegate?.select(movie: correctIndexPath)
        return
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = movies?.count {
            return count
        }
        
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RegularCell.reuseIdentifier, for: indexPath) as! RegularCell
        
        if let movie = movies?[indexPath.row] {
            if let poster = movie.posterPath {
                cell.configure(primary: movie.title, image: K.Poster.URL + poster)
                return cell
            } else {
                cell.configure(primary: movie.title)
            }
        }
        
        return cell
    }
}
