//
//  ImageURL.swift
//  Trip Planner
//
//  Created by Michał Lubowicz on 02/03/2021.
//

import SwiftUI

struct ImageURL: View {
    private enum LoadState {
        case loading, success, failure
    }

    private class Loader: ObservableObject {
        var data = Data()
        var state = LoadState.loading

        init(name: String) {
            // for database 1 for next databases url must be changed due to limits of free account
            let url = "https://firebasestorage.googleapis.com/v0/b/trip-planner-c4add.appspot.com/o/user1%2F\(name).jpg?alt=media&token=fcc1f93e-3509-4e51-acb3-88eae0f35dac"
            let parsedURL = URL(string: url)
            URLSession.shared.dataTask(with: parsedURL!) { data, response, error in
                if let data = data, data.count > 0 {
                    self.data = data
                    self.state = .success
                } else {
                    self.state = .failure
                }

                DispatchQueue.main.async {
                    self.objectWillChange.send()
                }
            }.resume()
        }
    }

    @StateObject private var loader: Loader
    var loading: Image
    var failure: Image

    var body: some View {
        selectImage()
            .resizable()
    }

    init(name: String, loading: Image = Image(systemName: "photo"), failure: Image = Image(systemName: "multiply.circle")) {
        _loader = StateObject(wrappedValue: Loader(name: name))
        self.loading = loading
        self.failure = failure
    }

    private func selectImage() -> Image {
        switch loader.state {
        case .loading:
            return loading
        case .failure:
            return failure
        default:
            if let image = UIImage(data: loader.data) {
                return Image(uiImage: image)
            } else {
                return failure
            }
        }
    }
}
