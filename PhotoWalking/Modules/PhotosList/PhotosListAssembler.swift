//
//  PhotosListAssembler.swift
//
//  Created by Paul Soto on 24/6/22.
//

import Foundation
import SwiftUI

protocol Assemblable {
    associatedtype Instance
    static func assemble() -> Instance
}

protocol AssemblableWithParams {
    associatedtype Instance
    associatedtype Params
    static func assemble(withParams params: Params) -> Instance
}

enum PhotosListAssembler: Assemblable {
    static func assemble() -> some View {
        let repository: PhotoRepository = PhotosRepositoryImpl()
        let viewModel = PhotosListViewModel(repository: repository,
                                            locationManager: LocationManagerImpl.shared)
        let view = PhotosListView(viewModel: viewModel).task(priority: .high) {
            await viewModel.getPhotos()
        }
        return view
    }
}
