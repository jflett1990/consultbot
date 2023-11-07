import SwiftUI

struct PortfolioView: View {
    @State private var portfolioItems = [PortfolioItem]()

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                    ForEach(portfolioItems) { item in
                        NavigationLink(destination: PortfolioDetailView(item: item)) {
                            PortfolioItemView(item: item)
                        }
                    }
                }
            }
            .navigationTitle("Portfolio")
            .onAppear {
                NetworkManager.shared.fetchPortfolioItems { items in
                    self.portfolioItems = items
                }
            }
        }
    }
}

struct PortfolioItemView: View {
    var item: PortfolioItem

    var body: some View {
        Image(uiImage: item.image)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .clipped()
    }
}

struct PortfolioDetailView: View {
    var item: PortfolioItem

    var body: some View {
        // Detailed view for a portfolio item
    }
}

