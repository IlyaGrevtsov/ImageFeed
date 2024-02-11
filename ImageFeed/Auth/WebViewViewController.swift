import UIKit
import WebKit

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

final class WebViewViewController: UIViewController {
    @IBOutlet private var webView: WKWebView!

    weak var delegate: WebViewViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self

        loadWebView()
    }

    @IBAction private func didTapBackButton(_ sender: Any?) {
        delegate?.webViewViewControllerDidCancel(self)
    }
}

extension WebViewViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let code = fetchCode(url: navigationAction.request.url) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
}

private extension WebViewViewController {
    func loadWebView() {
        var components = URLComponents(string: "https://unsplash.com/oauth/authorize")
        components?.queryItems = [URLQueryItem(name: "client_id", value: AccessKey),
                                  URLQueryItem(name: "redirect_uri", value: RedirectURI),
                                  URLQueryItem(name: "response_type", value: "code"),
                                  URLQueryItem(name: "scope", value: AccessScope)]
        
        if let url = components?.url {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    func fetchCode(url: URL?) -> String? {
        guard let url = url,
              let components = URLComponents(string: url.absoluteString),
              components.path == "/oauth/authorize/native",
              let codeItem = components.queryItems?.first(where: { $0.name == "code" }) else { return nil }
        return codeItem.value
    }
}
