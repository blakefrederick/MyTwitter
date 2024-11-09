// PostRowView.swift
import SwiftUI

struct PostRowView: View {
    var post: Post
    @Environment(\.openURL) var openURL

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // User Avatar - grab the site's favicon
            if let faviconURL = getFaviconURL(from: post.username) {
                AsyncImage(url: faviconURL) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 48, height: 48)
                    case .success(let image):
                        image
                            .resizable()
                            .frame(width: 48, height: 48)
                            .clipShape(Circle())
                    case .failure:
                        // default fallback if no favicon found
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .frame(width: 48, height: 48)
                            .foregroundColor(.blue)
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .frame(width: 48, height: 48)
                    .foregroundColor(.blue)
            }
            
            // Post Content
            VStack(alignment: .leading, spacing: 4) {
                Text(post.username)
                    .font(.subheadline)
                    .foregroundColor(.blue)
                    .onTapGesture {
                        if let url = URL(string: post.username), UIApplication.shared.canOpenURL(url) {
                            openURL(url)
                        } else if let url = URL(string: "https://" + post.username), UIApplication.shared.canOpenURL(url) {
                            openURL(url)
                        }
                    }
                
                // Text with excess whitespace removed
                Text(post.text.replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression))
                    .font(.body)
                    .lineLimit(nil)
                
                // Image
                if let imageUrl = URL(string: post.imageUrl), !post.imageUrl.isEmpty {
                    AsyncImage(url: imageUrl) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxHeight: 200)
                        case .failure:
                            EmptyView()
                        @unknown default:
                            EmptyView()
                        }
                    }
                }
            }
        }
        .padding(.vertical, 8)
    }
    
    func getFaviconURL(from urlString: String) -> URL? {
        var urlString = urlString
        if !urlString.contains("://") {
            urlString = "https://" + urlString
        }
        if let url = URL(string: urlString), let host = url.host {
            let faviconURLString = "https://www.google.com/s2/favicons?sz=64&domain_url=\(host)"
            return URL(string: faviconURLString)
        }
        return nil
    }
}
