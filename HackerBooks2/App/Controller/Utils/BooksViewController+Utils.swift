//
//  BooksViewController+Utils.swift
//  HackerBooks2
//
//  Created by Eric Risco de la Torre on 25/02/2017.
//  Copyright © 2017 ERISCO. All rights reserved.
//

import Foundation
import UIKit
import CoreData

// MARK: - UICollectionViewDelegate - UICollectionViewDataSource

extension BooksViewController:  UICollectionViewDelegate, UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.fetchedResultsController!.sections?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController?.sections![section]
        return sectionInfo!.numberOfObjects
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookCell", for: indexPath) as? BookCollectionViewCell
        
        cell?.book = (self.fetchedResultsController?.object(at: indexPath))!
        cell?.context = self.context
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var v : UICollectionReusableView! = nil
        if kind == UICollectionElementKindSectionHeader {
            v = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier:"SectionHeader", for: indexPath)
            let lab = v.subviews[0] as! UILabel
            lab.text = self.fetchedResultsController?.sections?[indexPath.section].name.replacingOccurrences(of: "_", with: "")
        }
        return v
    }
    
    
}

// MARK: - UISearchBarDelegate

extension BooksViewController: UISearchBarDelegate{
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.text = ""
        callFetch()
        self.searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        callFetch()
        self.searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        callFetch()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        callFetch()
        self.searchBar.resignFirstResponder()
    }
    
    func callFetch(){
        self.fetchedResultsController = BookTag.fetchController(context: self.context!, text: self.searchBar.text!)
        self.collectionView.reloadData()
    }

}
