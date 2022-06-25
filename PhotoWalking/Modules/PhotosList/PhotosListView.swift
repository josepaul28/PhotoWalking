//
//  PhotosListView.swift
//
//  Created by Paul Soto on 24/6/22.
//

import SwiftUI
import CoreData

struct PhotosListView: View {
    @StateObject var viewModel: PhotosListViewModel

    var body: some View {
        NavigationView() {
            VStack {
                if let error = viewModel.error {
                    HStack {
                        Spacer()
                        Image(systemName: "xmark.octagon.fill")
                        Text(error.localizedDescription)
                        Spacer()
                    }
                    .padding(.bottom, 16)
                    .foregroundColor(.white)
                    .background(Color.red)
                }

                if viewModel.photos.isEmpty {
                    Text("You don't have any stored photo, press start and walk :)")
                        .frame(maxHeight: .infinity)
                } else {
                    List {
                        ForEach(viewModel.photos) { item in
                            AsyncImage(url: item.imageUrl) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                            } placeholder: {
                                VStack(alignment: .center) {
                                    Image(systemName: "photo")
                                        .foregroundStyle(.secondary)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 32)
                            }.listRowSeparator(.hidden)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("My walking photos")
                        .bold()
                        .foregroundColor(viewModel.error == nil ? Color.black : Color.white)
                }
                ToolbarItem {
                    Group {
                        if !viewModel.isLocating {
                            Button(action: viewModel.start) {
                                Text("Start")
                            }
                        } else {
                            Button(action: viewModel.stop) {
                                Text("Stop")
                            }
                        }
                    }
                    .foregroundColor(viewModel.error == nil ? Color.black : Color.white)
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}
