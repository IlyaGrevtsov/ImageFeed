import UIKit
import Kingfisher

protocol ImagesListCellDelegate: AnyObject {
  func imagesListCellDidTapLike(_ cell: ImagesListCell)
}
final class ImagesListCell: UITableViewCell {
    override func prepareForReuse() {
        super.prepareForReuse()
        
        cellImage.kf.cancelDownloadTask()
    }
    static let reuseIdentifier = "ImagesListCell"
    private let placeholderImage = UIImage(named: "placeholder")
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM YYYY"
        return dateFormatter
    }()
    weak var delegate: ImagesListCellDelegate?

    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var cellImage: UIImageView!
    
    @IBOutlet weak var likeButton: UIButton!
    
    @IBAction func didTapLikeButton(_ sender: Any) {
        delegate?.imagesListCellDidTapLike(self)
    }
  }

extension ImagesListCell {
    func setIsLiked(_ isLiked: Bool) {
      let likedImage = isLiked ? UIImage(named: "like") : UIImage(named: "no_like")
        likeButton.setImage(likedImage, for: .normal)
    }

    func loadPhotos (from photo: Photo) -> Bool {
        var status = false
        
        if let photoDate = photo.createdAt {
            dateLabel.text = dateFormatter.string(from: photoDate)
        } else {
            dateLabel.text = ""
        }
        
        guard let photoUrl = URL(string: photo.thumbImageURL) else {return status}
        
        cellImage.kf.indicatorType = .activity
        cellImage.kf.setImage(with: photoUrl, placeholder: placeholderImage) {[weak self] result in
            guard let self else {return}
            switch result {
            case .success(_):
                status = true
            case .failure(let error):
                cellImage.image = placeholderImage
                debugPrint("Error: \(error.localizedDescription)")
            }
        }
        return status
    }
}
