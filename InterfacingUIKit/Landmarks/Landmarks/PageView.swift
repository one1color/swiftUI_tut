import SwiftUI

struct PageView<Page: View>: View {
    var viewControllers: [UIHostingController<Page>]
    @State var currentPage = 0

    init(viewControllers: [UIHostingController<Page>]) {
        self.viewControllers = viewControllers
    }
    
    init(_ views: [Page]) {
        self.viewControllers = views.map { UIHostingController(rootView: $0) }
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            PageViewController(controllers: viewControllers, currentPage: $currentPage)
            PageControl(numberOfPages: viewControllers.count , currentPage: $currentPage)
                .padding(.trailing)
        }
        //PageViewController(controllers: viewControllers)
    }
}

struct PageView_Previews: PreviewProvider {
    // the static in the following line is critical to it working...
    static let controllers = features.map { UIHostingController(rootView: FeatureCard(landmark: $0)) }
    
    static var previews: some View {
        PageView(viewControllers: controllers).aspectRatio(3/2, contentMode: .fit)
    }
}
