//
//  File.swift
//  ImageFeed
//
//  Created by Илья on 19.08.2024.
//

import Foundation
import Kingfisher

 public protocol ImageListPresenterProtocol {
    var view: ImagesListViewControllerProtocol? {get set}
    var photosCount: Int { get }
    func viewDidLoad()
    func updateTableViewAnimated()
    func needUploadImage (indexPath: IndexPath)
    func heightForRowAt(indexPath: IndexPath) -> CGFloat
    func imagesListCellDidTapLike(_ cell: ImagesListCell, indexPath: IndexPath)
    func returnPhotoModelAt (indexPath: IndexPath) -> Photo?
}

final class ImageListPresenter {
    
    let imageListService = ImageListService.shared
    
    weak var view:ImagesListViewControllerProtocol?
    var photos: [Photo] = []
    var photosTotalCount: Int {
        photos.count
    }
    
}
extension ImageListPresenter {
    func setupImageListService() {
        imageListService.fetchPhotoNextPage()
    }
}

extension ImageListPresenter: ImageListPresenterProtocol {
    var photosCount: Int {
        photosTotalCount
    }
    
    
    func viewDidLoad() {
        updateTableViewAnimated()
        setupImageListService()
        view?.setupTableView()
    }
    func updateTableViewAnimated() {
        let oldCount =  photosTotalCount
        photos = imageListService.photos
        let newCount = photosTotalCount
        if oldCount != newCount {
            view?.tableView.performBatchUpdates{
                let indexPaths = (oldCount..<newCount).map { index in
                    IndexPath(row: index, section: 0)
                }
                view?.tableView.insertRows(at: indexPaths, with: .automatic)
            }
        }
    }

    func needUploadImage (indexPath: IndexPath) {
        if indexPath.row + 2 == photosTotalCount {
            imageListService.fetchPhotoNextPage()
        }
    }
    func returnPhotoModelAt (indexPath: IndexPath) -> Photo? {
        photos[indexPath.row]
    }
 
    
    func heightForRowAt(indexPath: IndexPath) -> CGFloat {
        guard let view else {return 0}
        let thumbImageSize = photos[indexPath.row].thumbSize
        let imageInsets = (top: CGFloat (4), left: CGFloat (16), bottom: CGFloat (4), right: CGFloat (16))
        let imageViewWidth = view.tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = thumbImageSize.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = thumbImageSize.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
    
    func imagesListCellDidTapLike(_ cell: ImagesListCell, indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        UIBlockingProgressHUD.show()
        imageListService.changeLike(photoId: photo.id, indexPath: indexPath, isLike: !photo.isLiked) { [weak self ] result in
            guard let self else { return }
            switch result {
            case .success(let isLiked):
                self.photos[indexPath.row].isLiked = isLiked
                cell.setIsLiked(isLiked)
                UIBlockingProgressHUD.dismiss()
            case .failure(let error):
                UIBlockingProgressHUD.dismiss()
            }
        }
    }
}
