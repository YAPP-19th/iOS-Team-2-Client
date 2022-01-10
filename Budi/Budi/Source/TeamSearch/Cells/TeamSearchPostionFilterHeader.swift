//
//  TeamSearchPostionFilterHeader.swift
//  Budi
//
//  Created by 최동규 on 2022/01/05.
//

import UIKit
import Combine
import CombineCocoa
import Moya

protocol LeftAlignedHorizontalLayoutDelegate: AnyObject {
  func collectionView(
    _ collectionView: UICollectionView,
    widthIndexPath indexPath: IndexPath) -> CGFloat
}

final class LeftAlignedHorizontalLayout: UICollectionViewFlowLayout {

    weak var delegate: LeftAlignedHorizontalLayoutDelegate?
    private let numberOfRaws = 2
    private let cellPadding: CGFloat = 0

    // 3
    private var cache: [UICollectionViewLayoutAttributes] = []

    // 4
    private var contentWidth: CGFloat = 0

    private var contentHeight: CGFloat {
      guard let collectionView = collectionView else {
        return 0
      }
      let insets = collectionView.contentInset
        return collectionView.bounds.height - (insets.top + insets.bottom)
    }

    // 5
    override var collectionViewContentSize: CGSize {
      return CGSize(width: contentWidth, height: contentHeight)
    }

    override func prepare() {
      // 1
      guard
        cache.isEmpty,
        let collectionView = collectionView
        else {
          return
      }
      // 2
        let rawHeight = 32.0 + 4.0 //contentHeight / CGFloat(numberOfRaws)
      var yOffset: [CGFloat] = []
      for raw in 0..<numberOfRaws {
          yOffset.append(CGFloat(raw) * rawHeight + (raw == 0 ? 0.0 : minimumInteritemSpacing))
      }
        var raw = 0
      var xOffset: [CGFloat] = .init(repeating: 0, count: numberOfRaws)

      // 3
      for item in 0..<collectionView.numberOfItems(inSection: 0) {
        let indexPath = IndexPath(item: item, section: 0)

        // 4
        let labelWidth = delegate?.collectionView(
          collectionView,
          widthIndexPath: indexPath) ?? 32.0
        let width = cellPadding * 2 + labelWidth
        let frame = CGRect(x: xOffset[raw],
                           y: yOffset[raw],
                           width: width,
                           height: rawHeight)
        let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)

        // 5
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.frame = insetFrame
        cache.append(attributes)

        // 6
        contentWidth = max(contentWidth, frame.maxX)
          xOffset[raw] = xOffset[raw] + width + minimumLineSpacing

          raw = raw < (numberOfRaws - 1) ? (raw + 1) : 0
      }
    }

    override func layoutAttributesForElements(in rect: CGRect)
        -> [UICollectionViewLayoutAttributes]? {
      var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []

      // Loop through the cache and look for items in the rect
      for attributes in cache {
        if attributes.frame.intersects(rect) {
          visibleLayoutAttributes.append(attributes)
        }
      }
      return visibleLayoutAttributes
    }
}


final class TeamSearchPostionFilterHeader: UICollectionReusableView {

    @IBOutlet weak var collectionView: UICollectionView!
    private let provider = MoyaProvider<BudiTarget>()
    private var positions: [String] = []
    private var cancellables = Set<AnyCancellable>()

    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }

    func fetch(position: Position) {
        self.provider
            .requestPublisher(.detailPositions(position: position))
            .map(APIResponse<[String]>.self)
            .map(\.data)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in
            }, receiveValue: { [weak self] positions in
                self?.positions = positions
                self?.collectionView.reloadData()
            })
            .store(in: &self.cancellables)
    }
}

private extension TeamSearchPostionFilterHeader {
    func configure() {
        let flowLayout = LeftAlignedHorizontalLayout()
        flowLayout.delegate = self
        flowLayout.minimumLineSpacing = 8
        flowLayout.minimumInteritemSpacing = 8
        flowLayout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = flowLayout
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.register(.init(nibName: PositionLabelCell.identifier, bundle: nil), forCellWithReuseIdentifier: PositionLabelCell.identifier)
    }
    
}

extension TeamSearchPostionFilterHeader: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return positions.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PositionLabelCell.identifier, for: indexPath) as? PositionLabelCell else { return UICollectionViewCell() }
        let position = positions[indexPath.item]
        cell.backgroundColor = .clear
        cell.layer.borderColor = UIColor.budiGray.cgColor
        cell.layer.borderWidth = 1
        cell.label.text = position
        cell.layer.cornerRadius = 32 / 2
        return cell
    }
}

extension TeamSearchPostionFilterHeader: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.text = positions[indexPath.item]
        label.sizeToFit()
        label.layoutIfNeeded()
        return .init(width: label.frame.width + 24, height: 32)
    }
}

extension TeamSearchPostionFilterHeader: LeftAlignedHorizontalLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, widthIndexPath indexPath: IndexPath) -> CGFloat {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.text = positions[indexPath.item]
        label.sizeToFit()
        label.layoutIfNeeded()
        return label.frame.width + 24
    }
}
